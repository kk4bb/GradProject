using CampusConnect.Application.Dtos.Assignment;
using CampusConnect.Application.Interfaces;
using CampusConnect.Domain.Entities;
using CampusConnect.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Services
{
    public class AssignmentService : IAssignmentService
    {
        private readonly ApplicationDbContext _context;
        private readonly INotificationService _notificationService;

        public AssignmentService(ApplicationDbContext context, INotificationService notificationService)
        {
            _context = context;
            _notificationService = notificationService;
        }

        public async Task<List<AssignmentDto>> GetAssignmentsByCourseAsync(int courseId, string userId)
        {
            // Permission check: Must be enrolled or instructor
            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == courseId && e.StudentId == userId);
            var isInstructor = await _context.Courses.AnyAsync(c => c.Id == courseId && c.InstructorId == userId);

            if (!isEnrolled && !isInstructor)
                throw new UnauthorizedAccessException("Not authorized to view assignments for this course.");

            return await _context.Assignments
                .Where(a => a.CourseId == courseId)
                .Select(a => new AssignmentDto
                {
                    Id = a.Id,
                    Title = a.Title,
                    Description = a.Description,
                    DueDate = a.DueDate,
                    IsSubmitted = a.Submissions.Any(s => s.StudentId == userId)
                }).ToListAsync();
        }

        public async Task<AssignmentDto> GetAssignmentDetailAsync(int assignmentId, string userId)
        {
            var assignment = await _context.Assignments
                .Include(a => a.Course)
                .FirstOrDefaultAsync(a => a.Id == assignmentId);

            if (assignment == null) return null;

            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == assignment.CourseId && e.StudentId == userId);
            var isInstructor = assignment.Course.InstructorId == userId;

            if (!isEnrolled && !isInstructor)
                throw new UnauthorizedAccessException("Not authorized to view this assignment.");

            return new AssignmentDto
            {
                Id = assignment.Id,
                Title = assignment.Title,
                Description = assignment.Description,
                DueDate = assignment.DueDate,
                IsSubmitted = await _context.Submissions.AnyAsync(s => s.AssignmentId == assignmentId && s.StudentId == userId)
            };
        }

        public async Task<int> SubmitAssignmentAsync(int assignmentId, SubmissionSubmitDto submissionDto, string userId)
        {
            var assignment = await _context.Assignments.FindAsync(assignmentId);
            if (assignment == null) throw new Exception("Assignment not found.");

            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == assignment.CourseId && e.StudentId == userId);
            if (!isEnrolled) throw new UnauthorizedAccessException("Not enrolled in this course.");

            if (DateTime.UtcNow > assignment.DueDate)
                throw new Exception("Assignment due date has passed.");

            var existingSubmission = await _context.Submissions
                .FirstOrDefaultAsync(s => s.AssignmentId == assignmentId && s.StudentId == userId);

            if (existingSubmission != null)
            {
                existingSubmission.FileUrl = submissionDto.FileUrl;
                _context.Submissions.Update(existingSubmission);
            }
            else
            {
                var submission = new Submission
                {
                    AssignmentId = assignmentId,
                    StudentId = userId,
                    FileUrl = submissionDto.FileUrl,
                    Grade = 0 // Initial grade
                };
                _context.Submissions.Add(submission);
            }

            await _context.SaveChangesAsync();
            return assignmentId;
        }

        public async Task<int> CreateAssignmentAsync(int courseId, AssignmentCreateDto dto, string userId)
        {
            var course = await _context.Courses.FindAsync(courseId);
            if (course == null) throw new Exception("Course not found.");

            if (course.InstructorId != userId)
                throw new UnauthorizedAccessException("Only the instructor can create assignments.");

            var assignment = new Assignment
            {
                CourseId = courseId,
                Title = dto.Title,
                Description = dto.Description,
                DueDate = dto.DueDate
            };

            _context.Assignments.Add(assignment);
            await _context.SaveChangesAsync();

            // Notify students
            await _notificationService.NotifyStudentsInCourseAsync(
                courseId,
                "New Assignment",
                $"A new assignment '{dto.Title}' has been posted for {course.Title}."
            );

            return assignment.Id;
        }

        public async Task<List<SubmissionDto>> GetSubmissionsForAssignmentAsync(int assignmentId, string userId)
        {
            var assignment = await _context.Assignments
                .Include(a => a.Course)
                .FirstOrDefaultAsync(a => a.Id == assignmentId);

            if (assignment == null) throw new Exception("Assignment not found.");

            if (assignment.Course.InstructorId != userId)
                throw new UnauthorizedAccessException("Only the instructor can view all submissions.");

            return await _context.Submissions
                .Where(s => s.AssignmentId == assignmentId)
                .Select(s => new SubmissionDto
                {
                    Id = s.Id,
                    AssignmentId = s.AssignmentId,
                    StudentId = s.StudentId,
                    FileUrl = s.FileUrl,
                    Grade = s.Grade
                }).ToListAsync();
        }

        public async Task<bool> GradeSubmissionAsync(int submissionId, SubmissionGradeDto gradeDto, string userId)
        {
            var submission = await _context.Submissions
                .Include(s => s.Assignment)
                .ThenInclude(a => a.Course)
                .FirstOrDefaultAsync(s => s.Id == submissionId);

            if (submission == null) throw new Exception("Submission not found.");

            if (submission.Assignment.Course.InstructorId != userId)
                throw new UnauthorizedAccessException("Only the instructor can grade submissions.");

            submission.Grade = gradeDto.Grade;
            _context.Submissions.Update(submission);
            return await _context.SaveChangesAsync() > 0;
        }
    }
}
