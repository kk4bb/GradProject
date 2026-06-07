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

            return new StudentDashboardDto
            {
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                EnrolledCourses = courses,
                QuizAttempts = quizAttempts,
                Submissions = submissions
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
            return await _context.Enrollments
                .AnyAsync(e => e.StudentId == studentId && e.Course.InstructorId == instructorId);
        }
    }
}
