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
                    ImageUrl = q.ImageUrl,
                    IsEssay = q.IsEssay,
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
            int essayCount = 0;
            var breakdown = new List<QuestionResultDto>();
            bool pendingReview = false;

            foreach (var question in quiz.Questions)
            {
                var studentAnswer = submission.Answers.FirstOrDefault(a => a.QuestionId == question.Id);
                
                if (question.IsEssay)
                {
                    pendingReview = true;
                    essayCount++;
                    continue; // Skip grading for essays
                }

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

            double score = pendingReview ? 0 : (double)correctCount / (quiz.Questions.Count - essayCount) * 100;

            // Save the attempt
            var attempt = new QuizAttempt
            {
                QuizId = quizId,
                StudentId = userId,
                Score = score,
                Status = pendingReview ? "Pending Review" : "Completed",
                EssayAnswer = submission.Answers.FirstOrDefault(a => quiz.Questions.Any(q => q.Id == a.QuestionId && q.IsEssay))?.EssayAnswer
            };
            _context.QuizAttempts.Add(attempt);
            await _context.SaveChangesAsync();

            return new QuizResultDto
            {
                Score = score,
                TotalQuestions = quiz.Questions.Count,
                CorrectAnswersCount = correctCount,
                Status = attempt.Status,
                Breakdown = requestBreakdown ? breakdown : null
            };
        }
        public async Task UpdateQuestionImageAsync(int questionId, string imageUrl, string userId)
        {
            var question = await _context.Questions
                .Include(q => q.Quiz)
                .ThenInclude(q => q.Course)
                .FirstOrDefaultAsync(q => q.Id == questionId);

            if (question == null) throw new Exception("Question not found.");
            
            // Check if the user is the instructor of the course
            if (question.Quiz.Course.InstructorId != userId)
                throw new UnauthorizedAccessException("Not authorized to modify this quiz.");

            question.ImageUrl = imageUrl;
            await _context.SaveChangesAsync();
        }
    }
}
