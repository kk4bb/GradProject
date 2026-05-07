using CampusConnect.Application.Dtos.Dashboard;
using CampusConnect.Application.Dtos.Student;
using CampusConnect.Application.Interfaces;
using CampusConnect.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Services
{
    public class StudentService : IStudentService
    {
        private readonly ApplicationDbContext _context;

        public StudentService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<StudentDashboardDto> GetStudentDashboardAsync(string studentId)
        {
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Id == studentId);

            if (user == null) return null;

            var enrollments = await _context.Enrollments
                .Where(e => e.StudentId == studentId)
                .Include(e => e.Course)
                .ToListAsync();

            var courses = enrollments.Select(e => {
                var instructor = _context.Users.FirstOrDefault(u => u.Id == e.Course.InstructorId);
                return new EnrolledCourseDto
                {
                    Id = e.Course.Id,
                    Title = e.Course.Title,
                    InstructorName = instructor != null ? $"{instructor.FirstName} {instructor.LastName}" : "Unknown"
                };
            }).ToList();

            var quizAttempts = await _context.QuizAttempts
                .Where(qa => qa.StudentId == studentId)
                .Select(qa => new QuizAttemptDto
                {
                    Id = qa.Id,
                    QuizTitle = _context.Quizzes.FirstOrDefault(q => q.Id == qa.QuizId).Title,
                    Score = qa.Score
                }).ToListAsync();

            var submissions = await _context.Submissions
                .Where(s => s.StudentId == studentId)
                .Select(s => new SubmissionDto
                {
                    Id = s.Id,
                    AssignmentTitle = _context.Assignments.FirstOrDefault(a => a.Id == s.AssignmentId).Title,
                    Grade = s.Grade
                }).ToListAsync();

            // Get Upcoming Items
            var courseIds = courses.Select(c => c.Id).ToList();

            var pendingAssignments = await _context.Assignments
                .Where(a => courseIds.Contains(a.CourseId))
                .Where(a => !_context.Submissions.Any(s => s.AssignmentId == a.Id && s.StudentId == studentId))
                .Select(a => new UpcomingItemDto
                {
                    Id = a.Id,
                    Title = a.Title,
                    Type = "Assignment",
                    CourseTitle = a.Course.Title,
                    DueDate = a.DueDate
                }).ToListAsync();

            var pendingQuizzes = await _context.Quizzes
                .Where(q => courseIds.Contains(q.CourseId))
                .Where(q => !_context.QuizAttempts.Any(qa => qa.QuizId == q.Id && qa.StudentId == studentId))
                .Select(q => new UpcomingItemDto
                {
                    Id = q.Id,
                    Title = q.Title,
                    Type = "Quiz",
                    CourseTitle = q.Course.Title,
                    DueDate = q.DueDate
                }).ToListAsync();

            var upcomingItems = pendingAssignments.Concat(pendingQuizzes)
                .OrderBy(i => i.DueDate)
                .ToList();

            return new StudentDashboardDto
            {
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                EnrolledCourses = courses,
                QuizAttempts = quizAttempts,
                Submissions = submissions,
                UpcomingItems = upcomingItems
            };
        }

        public async Task<StudentProfileDto> GetStudentProfileAsync(string studentId)
        {
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Id == studentId);

            if (user == null) return null;

            var enrollmentsCount = await _context.Enrollments
                .CountAsync(e => e.StudentId == studentId);

            return new StudentProfileDto
            {
                Id = user.Id,
                Email = user.Email,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Faculty = user.Faculty,
                AcademicYear = user.AcademicYear ?? 0,
                CreditHours = user.CreditHours ?? 0,
                EnrolledCoursesCount = enrollmentsCount
            };
        }

        public async Task<bool> IsInstructorForStudentAsync(string instructorId, string studentId)
        {
            // Get all courses student is in
            var studentCourses = await _context.Enrollments
                .Where(e => e.StudentId == studentId)
                .Select(e => e.CourseId)
                .ToListAsync();

            foreach (var courseId in studentCourses)
            {
                if (await IsAuthorizedToManageCourseAsync(instructorId, courseId))
                    return true;
            }

            return false;
        }

        private async Task<bool> IsAuthorizedToManageCourseAsync(string userId, int courseId)
        {
            var course = await _context.Courses.FindAsync(courseId);
            if (course == null) return false;

            if (course.InstructorId == userId) return true;

            // Check if user has TA role and is enrolled in the course
            var isTA = await _context.UserRoles
                .Join(_context.Roles, ur => ur.RoleId, r => r.Id, (ur, r) => new { ur.UserId, r.Name })
                .AnyAsync(x => x.UserId == userId && x.Name == "TA");

            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == courseId && e.StudentId == userId);

            return isTA && isEnrolled;
        }
    }
}
