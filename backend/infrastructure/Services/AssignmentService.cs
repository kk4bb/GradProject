using CampusConnect.Application.Dtos.Assignment;
using CampusConnect.Application.Interfaces;
using CampusConnect.Domain.Entities;
using CampusConnect.Infrastructure.Context;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;
using CampusConnect.Infrastructure.Hubs;
using CampusConnect.Domain.Enums;

namespace CampusConnect.Infrastructure.Services
{
    public class AssignmentService : IAssignmentService
    {
        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IGradeService _gradeService;
        private readonly IHubContext<NotificationHub> _notificationHubContext;

        public AssignmentService(ApplicationDbContext context, UserManager<ApplicationUser> userManager, IGradeService gradeService, IHubContext<NotificationHub> notificationHubContext)
        {
            _context = context;
            _userManager = userManager;
            _gradeService = gradeService;
            _notificationHubContext = notificationHubContext;
        }

        public async Task<List<AssignmentDto>> GetAssignmentsByCourseAsync(int courseId, string userId, bool isTA = false)
        {
            // Permission check: Must be enrolled, instructor, or TA
            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == courseId && e.StudentId == userId);
            var isInstructor = await _context.Courses.AnyAsync(c => c.Id == courseId && c.InstructorId == userId);

            if (!isEnrolled && !isInstructor && !isTA)
                throw new UnauthorizedAccessException("Not authorized to view assignments for this course.");

            var course = await _context.Courses.FirstOrDefaultAsync(c => c.Id == courseId);
            string instructorName = "Instructor";
            if (course != null)
            {
                var instructor = await _userManager.FindByIdAsync(course.InstructorId);
                if (instructor != null)
                    instructorName = $"{instructor.FirstName} {instructor.LastName}";
            }

            return await _context.Assignments
                .Include(a => a.Course)
                .Where(a => a.CourseId == courseId)
                .Select(a => new AssignmentDto
                {
                    Id = a.Id,
                    Title = a.Title,
                    Description = a.Description,
                    DueDate = a.DueDate,
                    Points = a.Points,
                    IsSubmitted = a.Submissions.Any(s => s.StudentId == userId),
                    Grade = a.Submissions.Where(s => s.StudentId == userId).Select(s => (double?)s.Grade).FirstOrDefault(),
                    Feedback = a.Submissions.Where(s => s.StudentId == userId).Select(s => s.Feedback).FirstOrDefault(),
                    InstructorName = instructorName
                }).ToListAsync();
        }

        public async Task<AssignmentDto> GetAssignmentDetailAsync(int assignmentId, string userId, bool isTA = false)
        {
            var assignment = await _context.Assignments
                .Include(a => a.Course)
                .FirstOrDefaultAsync(a => a.Id == assignmentId);

            if (assignment == null) return null;

            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == assignment.CourseId && e.StudentId == userId);
            var isInstructor = assignment.Course.InstructorId == userId;

            if (!isEnrolled && !isInstructor && !isTA)
                throw new UnauthorizedAccessException("Not authorized to view this assignment.");

            var submission = await _context.Submissions
                .FirstOrDefaultAsync(s => s.AssignmentId == assignmentId && s.StudentId == userId);

            string instructorName = "Instructor";
            var instructor = await _userManager.FindByIdAsync(assignment.Course.InstructorId);
            if (instructor != null)
                instructorName = $"{instructor.FirstName} {instructor.LastName}";

            return new AssignmentDto
            {
                Id = assignment.Id,
                Title = assignment.Title,
                Description = assignment.Description,
                DueDate = assignment.DueDate,
                Points = assignment.Points,
                IsSubmitted = submission != null,
                Grade = submission?.Grade,
                Feedback = submission?.Feedback,
                InstructorName = instructorName
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
                existingSubmission.Url = submissionDto.Url;
                existingSubmission.Comment = submissionDto.Comment;
                _context.Submissions.Update(existingSubmission);
            }
            else
            {
                var submission = new Submission
                {
                    AssignmentId = assignmentId,
                    StudentId = userId,
                    FileUrl = submissionDto.FileUrl,
                    Url = submissionDto.Url,
                    Comment = submissionDto.Comment,
                    Grade = 0
                };
                _context.Submissions.Add(submission);
            }

            await _context.SaveChangesAsync();
            return assignmentId;
        }

        public async Task<int> CreateAssignmentAsync(int courseId, AssignmentCreateDto dto, string userId, bool isTA = false)
        {
            var course = await _context.Courses.FindAsync(courseId);
            if (course == null) throw new Exception("Course not found.");

            if (!isTA && course.InstructorId != userId)
                throw new UnauthorizedAccessException("Only the instructor or TA can create assignments.");

            var assignment = new Assignment
            {
                CourseId = courseId,
                Title = dto.Title,
                Description = dto.Description,
                DueDate = dto.DueDate,
                Points = dto.Points
            };

            _context.Assignments.Add(assignment);
            await _context.SaveChangesAsync();

            // Create Notification records for each enrolled student
            var studentIds = await _context.Enrollments
                .Where(e => e.CourseId == courseId)
                .Select(e => e.StudentId)
                .ToListAsync();

            var assignmentNotifications = studentIds.Select(sid => new Notification
            {
                UserId = sid,
                Title = "New Assignment Posted",
                Message = $"A new assignment '{dto.Title}' has been posted. Due: {dto.DueDate:MMM d, yyyy}.",
                Type = NotificationType.Assignment,
                ReferenceId = assignment.Id.ToString(),
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            }).ToList();

            if (assignmentNotifications.Any())
            {
                _context.Notifications.AddRange(assignmentNotifications);
                await _context.SaveChangesAsync();

                foreach (var sid in studentIds)
                {
                    await _notificationHubContext.Clients.Group($"User_{sid}")
                        .SendAsync("ReceiveNotification", new { title = "New Assignment Posted", message = $"A new assignment '{dto.Title}' has been posted." });
                }
            }

            return assignment.Id;
        }

        public async Task<List<SubmissionDto>> GetSubmissionsForAssignmentAsync(int assignmentId, string userId, bool isTA = false)
        {
            var assignment = await _context.Assignments
                .Include(a => a.Course)
                .FirstOrDefaultAsync(a => a.Id == assignmentId);

            if (assignment == null) throw new Exception("Assignment not found.");

            if (!isTA && assignment.Course.InstructorId != userId)
                throw new UnauthorizedAccessException("Only the instructor or TA can view all submissions.");

            var submissions = await _context.Submissions
                .Where(s => s.AssignmentId == assignmentId)
                .ToListAsync();

            var dtos = new List<SubmissionDto>();
            foreach (var s in submissions)
            {
                var studentName = s.StudentId;
                var student = await _userManager.FindByIdAsync(s.StudentId);
                if (student != null) studentName = $"{student.FirstName} {student.LastName}";

                dtos.Add(new SubmissionDto
                {
                    Id = s.Id,
                    AssignmentId = s.AssignmentId,
                    StudentId = s.StudentId,
                    StudentName = studentName,
                    FileUrl = s.FileUrl,
                    Grade = s.Grade,
                    Feedback = s.Feedback
                });
            }
            return dtos;
        }

        public async Task<(bool Success, string StudentId)> GradeSubmissionAsync(int submissionId, SubmissionGradeDto gradeDto, string userId, bool isTA = false)
        {
            var submission = await _context.Submissions
                .Include(s => s.Assignment)
                .ThenInclude(a => a.Course)
                .FirstOrDefaultAsync(s => s.Id == submissionId);

            if (submission == null) throw new Exception("Submission not found.");

            if (!isTA && submission.Assignment.Course.InstructorId != userId)
                throw new UnauthorizedAccessException("Only the instructor or TA can grade submissions.");

            submission.Grade = gradeDto.Grade;
            submission.Feedback = gradeDto.Feedback;

            _context.Entry(submission).State = EntityState.Modified;
            var success = await _context.SaveChangesAsync() > 0;
            
            if (success)
            {
                await _gradeService.AggregateStudentGradesAsync(submission.Assignment.CourseId, submission.StudentId);
            }
            
            return (success, submission.StudentId);
        }
    }
}
