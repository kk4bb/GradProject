using CampusConnect.Application.Dtos.Quiz;
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
    public class QuizService : IQuizService
    {
        private readonly ApplicationDbContext _context;

        public QuizService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<QuizDto>> GetQuizzesByCourseAsync(int courseId, string userId)
        {
            // Permission check: Must be enrolled student or instructor
            var isEnrolled = await _context.Enrollments
                .AnyAsync(e => e.CourseId == courseId && e.StudentId == userId);

            var isInstructor = await _context.Courses
                .AnyAsync(c => c.Id == courseId && c.InstructorId == userId);

            if (!isEnrolled && !isInstructor)
                throw new UnauthorizedAccessException("You are not authorized to view quizzes for this course.");

            return await _context.Quizzes
                .Where(q => q.CourseId == courseId)
                .Select(q => new QuizDto
                {
                    Id = q.Id,
                    Title = q.Title,
                    QuestionCount = q.Questions.Count()
                })
                .ToListAsync();
        }

        public async Task<QuizTakeDto> GetQuizForTakingAsync(int quizId, string userId)
        {
            var quiz = await _context.Quizzes
                .Include(q => q.Questions)
                .ThenInclude(qs => qs.Options)
                .FirstOrDefaultAsync(q => q.Id == quizId);

            if (quiz == null) return null;

            // Permission check
            var isEnrolled = await _context.Enrollments
                .AnyAsync(e => e.CourseId == quiz.CourseId && e.StudentId == userId);

            if (!isEnrolled)
                throw new UnauthorizedAccessException("You are not enrolled in the course for this quiz.");

            return new QuizTakeDto
            {
                Id = quiz.Id,
                Title = quiz.Title,
                Questions = quiz.Questions.Select(q => new QuestionDto
                {
                    Id = q.Id,
                    Text = q.Text,
                    Options = q.Options.Select(o => new OptionDto
                    {
                        Id = o.Id,
                        Text = o.Text
                    }).ToList()
                }).ToList()
            };
        }

        public async Task<QuizResultDto> SubmitQuizAsync(int quizId, QuizSubmissionDto submission, string userId, bool requestBreakdown)
        {
            var quiz = await _context.Quizzes
                .Include(q => q.Questions)
                .ThenInclude(qs => qs.Options)
                .FirstOrDefaultAsync(q => q.Id == quizId);

            if (quiz == null) throw new Exception("Quiz not found.");

            var isEnrolled = await _context.Enrollments
                .AnyAsync(e => e.CourseId == quiz.CourseId && e.StudentId == userId);

            if (!isEnrolled)
                throw new UnauthorizedAccessException("You are not enrolled in this course.");

            int correctCount = 0;
            var breakdown = new List<QuestionResultDto>();

            foreach (var question in quiz.Questions)
            {
                var studentAnswer = submission.Answers.FirstOrDefault(a => a.QuestionId == question.Id);
                var correctOption = question.Options.FirstOrDefault(o => o.IsCorrect);
                var selectedOption = question.Options.FirstOrDefault(o => o.Id == studentAnswer?.SelectedOptionId);

                bool isCorrect = selectedOption != null && selectedOption.IsCorrect;
                if (isCorrect) correctCount++;

                if (requestBreakdown)
                {
                    breakdown.Add(new QuestionResultDto
                    {
                        QuestionId = question.Id,
                        QuestionText = question.Text,
                        SelectedOptionText = selectedOption?.Text ?? "No answer provided",
                        CorrectOptionText = correctOption?.Text ?? "N/A",
                        IsCorrect = isCorrect
                    });
                }
            }

            double score = (double)correctCount / quiz.Questions.Count * 100;

            // Save the attempt
            var attempt = new QuizAttempt
            {
                QuizId = quizId,
                StudentId = userId,
                Score = score
            };
            _context.QuizAttempts.Add(attempt);
            await _context.SaveChangesAsync();

            return new QuizResultDto
            {
                Score = score,
                TotalQuestions = quiz.Questions.Count,
                CorrectAnswersCount = correctCount,
                Breakdown = requestBreakdown ? breakdown : null
            };
        }

        public async Task<int> CreateQuizAsync(int courseId, QuizCreateDto dto, string userId)
        {
            var course = await _context.Courses.FindAsync(courseId);
            if (course == null) throw new Exception("Course not found.");

            if (course.InstructorId != userId)
                throw new UnauthorizedAccessException("Only the instructor can create quizzes.");

            var quiz = new Quiz
            {
                CourseId = courseId,
                Title = dto.Title,
                Description = dto.Description,
                DueDate = dto.DueDate
            };

            _context.Quizzes.Add(quiz);
            await _context.SaveChangesAsync();
            return quiz.Id;
        }
    }
}
