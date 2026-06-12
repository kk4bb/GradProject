using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CampusConnect.Application.Dtos.Grades;
using CampusConnect.Application.Interfaces;
using CampusConnect.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.SignalR;
using CampusConnect.Infrastructure.Hubs;

namespace CampusConnect.Infrastructure.Services
{
    public class GradeService : IGradeService
    {
        private readonly ApplicationDbContext _context;
        private readonly IHubContext<GradeHub> _hubContext;

        public GradeService(ApplicationDbContext context, IHubContext<GradeHub> hubContext)
        {
            _context = context;
            _hubContext = hubContext;
        }

        public async Task<GradeRecordDto> GetGradeRecordAsync(int courseId, string studentId)
        {
            var record = await _context.GradeRecords
                .FirstOrDefaultAsync(g => g.CourseId == courseId && g.StudentId == studentId);

            if (record == null)
            {
                // Create empty record
                record = new GradeRecord
                {
                    CourseId = courseId,
                    StudentId = studentId
                };
                _context.GradeRecords.Add(record);
                await _context.SaveChangesAsync();
            }

            var user = await _context.Users.FindAsync(studentId);
            return MapToDto(record, user?.FirstName, user?.LastName, user?.ProfilePictureUrl);
        }

        public async Task<List<GradeRecordDto>> GetCourseGradesAsync(int courseId)
        {
            var records = await (from g in _context.GradeRecords
                                 join u in _context.Users on g.StudentId equals u.Id
                                 where g.CourseId == courseId
                                 select new { Grade = g, User = u })
                                 .ToListAsync();

            return records.Select(r => MapToDto(r.Grade, r.User.FirstName, r.User.LastName, r.User.ProfilePictureUrl)).ToList();
        }

        public async Task<GradeRecordDto> UpdateGradeRecordAsync(int courseId, string studentId, UpdateGradeDto dto, string userId, bool isTA)
        {
            var record = await _context.GradeRecords
                .FirstOrDefaultAsync(g => g.CourseId == courseId && g.StudentId == studentId);

            if (record == null)
            {
                record = new GradeRecord
                {
                    CourseId = courseId,
                    StudentId = studentId
                };
                _context.GradeRecords.Add(record);
            }

            // Authorization logic
            // If Term Work is published, TAs cannot update anything.
            if (record.IsTermWorkPublished && isTA)
            {
                throw new UnauthorizedAccessException("Term work grades have been published and cannot be modified by TAs.");
            }

            // Instructors can update anytime.
            var course = await _context.Courses.FindAsync(courseId);
            if (course == null) throw new Exception("Course not found.");

            if (!isTA && course.InstructorId != userId)
            {
                throw new UnauthorizedAccessException("You are not authorized to update grades for this course.");
            }

            // Only TAs and Instructors can update Term Work
            if (dto.QuizzesTotal.HasValue) record.QuizzesTotal = dto.QuizzesTotal.Value;
            if (dto.AssignmentsTotal.HasValue) record.AssignmentsTotal = dto.AssignmentsTotal.Value;
            if (dto.AttendanceTotal.HasValue) record.AttendanceTotal = dto.AttendanceTotal.Value;
            if (dto.ProjectGrade.HasValue) record.ProjectGrade = dto.ProjectGrade.Value;

            // Only Instructors can update Exams (or TAs if not restricted, but usually instructors)
            // If we want to restrict TAs from updating exams, we can add:
            // if (isTA && (dto.Midterm1.HasValue || dto.Midterm2.HasValue || dto.FinalExam.HasValue)) throw ...
            if (dto.Midterm1.HasValue) record.Midterm1 = dto.Midterm1.Value;
            if (dto.Midterm2.HasValue) record.Midterm2 = dto.Midterm2.Value;
            if (dto.FinalExam.HasValue) record.FinalExam = dto.FinalExam.Value;

            await _context.SaveChangesAsync();

            var user = await _context.Users.FindAsync(studentId);
            var updatedDto = MapToDto(record, user?.FirstName, user?.LastName, user?.ProfilePictureUrl);
            await _hubContext.Clients.Group($"Course_{courseId}_Grades").SendAsync("ReceiveGradeUpdate", updatedDto);
            return updatedDto;
        }

        public async Task<bool> PublishTermWorkAsync(int courseId, string instructorId)
        {
            var course = await _context.Courses.FindAsync(courseId);
            if (course == null || course.InstructorId != instructorId)
            {
                throw new UnauthorizedAccessException("Only the instructor can publish term work.");
            }

            var records = await _context.GradeRecords.Where(g => g.CourseId == courseId).ToListAsync();
            foreach (var record in records)
            {
                record.IsTermWorkPublished = true;
            }

            await _context.SaveChangesAsync();
            await _hubContext.Clients.Group($"Course_{courseId}_Grades").SendAsync("TermWorkPublished");
            return true;
        }

        public async Task<bool> UnlockTermWorkAsync(int courseId, string instructorId)
        {
            var course = await _context.Courses.FindAsync(courseId);
            if (course == null || course.InstructorId != instructorId)
            {
                throw new UnauthorizedAccessException("Only the instructor can unlock term work.");
            }

            var records = await _context.GradeRecords.Where(g => g.CourseId == courseId).ToListAsync();
            foreach (var record in records)
            {
                record.IsTermWorkPublished = false;
            }

            await _context.SaveChangesAsync();
            await _hubContext.Clients.Group($"Course_{courseId}_Grades").SendAsync("TermWorkUnlocked");
            return true;
        }

        public async Task AggregateStudentGradesAsync(int courseId, string studentId)
        {
            var record = await _context.GradeRecords
                .FirstOrDefaultAsync(g => g.CourseId == courseId && g.StudentId == studentId);

            if (record == null)
            {
                record = new GradeRecord { CourseId = courseId, StudentId = studentId };
                _context.GradeRecords.Add(record);
            }

            // Sum Quizzes
            var quizzesTotal = await (from a in _context.QuizAttempts
                                      join q in _context.Quizzes on a.QuizId equals q.Id
                                      where q.CourseId == courseId && a.StudentId == studentId
                                      group a by a.QuizId into g
                                      select g.Max(x => x.Score + (x.ManualScore ?? 0.0))).SumAsync();

            // Sum Assignments
            var assignmentsTotal = await _context.Submissions
                .Where(s => s.Assignment.CourseId == courseId && s.StudentId == studentId)
                .GroupBy(s => s.AssignmentId)
                .Select(g => g.Max(s => s.Grade))
                .SumAsync();

            // Update record
            record.QuizzesTotal = quizzesTotal;
            record.AssignmentsTotal = assignmentsTotal;

            await _context.SaveChangesAsync();

            var user = await _context.Users.FindAsync(studentId);
            var updatedDto = MapToDto(record, user?.FirstName, user?.LastName, user?.ProfilePictureUrl);
            await _hubContext.Clients.Group($"Course_{courseId}_Grades").SendAsync("ReceiveGradeUpdate", updatedDto);
        }

        private GradeRecordDto MapToDto(GradeRecord entity, string? firstName, string? lastName, string? avatarUrl)
        {
            return new GradeRecordDto
            {
                Id = entity.Id,
                StudentId = entity.StudentId,
                StudentName = !string.IsNullOrEmpty(firstName) ? $"{firstName} {lastName}" : "Unknown Student",
                StudentAvatarUrl = avatarUrl,
                CourseId = entity.CourseId,
                QuizzesTotal = entity.QuizzesTotal,
                AssignmentsTotal = entity.AssignmentsTotal,
                AttendanceTotal = entity.AttendanceTotal,
                ProjectGrade = entity.ProjectGrade,
                Midterm1 = entity.Midterm1,
                Midterm2 = entity.Midterm2,
                FinalExam = entity.FinalExam,
                IsTermWorkPublished = entity.IsTermWorkPublished,
                TotalGrade = entity.TotalGrade
            };
        }
    }
}
