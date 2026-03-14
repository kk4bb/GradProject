using CampusConnect.Application.Dtos.Dashboard;
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

            var courses = enrollments.Select(e => new EnrolledCourseDto
            {
                Id = e.Course.Id,
                Title = e.Course.Title,
                InstructorName = _context.Users.FirstOrDefault(u => u.Id == e.Course.InstructorId)?.UserName ?? "Unknown"
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
                FullName = user.UserName, // Using UserName as DisplayName for now
                Email = user.Email,
                EnrolledCourses = courses,
                QuizAttempts = quizAttempts,
                Submissions = submissions
            };
        }

        public async Task<bool> IsInstructorForStudentAsync(string instructorId, string studentId)
        {
            // Check if the instructor teaches ANY course the student is enrolled in
            return await _context.Enrollments
                .AnyAsync(e => e.StudentId == studentId && e.Course.InstructorId == instructorId);
        }
    }
}
