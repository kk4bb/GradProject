using CampusConnect.Application.Dtos.Quiz;
using CampusConnect.Application.Interfaces;
using CampusConnect.Domain.Entities;
using CampusConnect.Infrastructure.Context;
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
    public class QuizService : IQuizService
    {
        private readonly ApplicationDbContext _context;
        private readonly IHubContext<QuizHub> _hubContext;
        private readonly IHubContext<NotificationHub> _notificationHubContext;
        private readonly IGradeService _gradeService;

        public QuizService(ApplicationDbContext context, IHubContext<QuizHub> hubContext, IHubContext<NotificationHub> notificationHubContext, IGradeService gradeService)
        {
            _context = context;
            _hubContext = hubContext;
            _notificationHubContext = notificationHubContext;
            _gradeService = gradeService;
        }

        public async Task<List<QuizDto>> GetQuizzesByCourseAsync(int courseId, string userId, bool isTA = false)
        {
            // Permission check: Must be enrolled student or instructor
            var isEnrolled = await _context.Enrollments
                .AnyAsync(e => e.CourseId == courseId && e.StudentId == userId);

            var isInstructor = await _context.Courses
                .AnyAsync(c => c.Id == courseId && c.InstructorId == userId);

            if (!isEnrolled && !isInstructor && !isTA)
                throw new UnauthorizedAccessException("You are not authorized to view quizzes for this course.");

            return await _context.Quizzes
                .Where(q => q.CourseId == courseId)
                .Select(q => new QuizDto
                {
                    Id = q.Id,
                    Title = q.Title,
                    QuestionCount = q.Questions.Count(),
                    TotalMarks = q.Questions.Sum(x => x.Points),
                    StartDate = q.StartDate,
                    EndDate = q.EndDate,
                    DurationMinutes = q.DurationMinutes,
                    IsAutoGraded = q.IsAutoGraded,
                    AreGradesPublished = q.AreGradesPublished,
                    Description = q.Description,
                    CourseId = q.CourseId,
                    HasAttempted = _context.QuizAttempts.Any(a => a.QuizId == q.Id && a.StudentId == userId)
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
                DurationMinutes = quiz.DurationMinutes,
                Questions = quiz.Questions.Select(q => new QuestionDto
                {
                    Id = q.Id,
                    Text = q.Text,
                    ImageUrl = q.ImageUrl,
                    IsEssay = q.IsEssay,
                    Points = q.Points,
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
            double score = 0;
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
                if (isCorrect) 
                {
                    correctCount++;
                    score += question.Points;
                }

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

            // Auto-aggregate if fully auto-graded
            if (!pendingReview)
            {
                await _gradeService.AggregateStudentGradesAsync(quiz.CourseId, userId);
            }

            return new QuizResultDto
            {
                Score = score,
                TotalQuestions = quiz.Questions.Count,
                CorrectAnswersCount = correctCount,
                Status = attempt.Status,
                Breakdown = requestBreakdown ? breakdown : null
            };
        }
        public async Task UpdateQuestionImageAsync(int questionId, string imageUrl, string userId, bool isTA = false)
        {
            var question = await _context.Questions
                .Include(q => q.Quiz)
                .ThenInclude(q => q.Course)
                .FirstOrDefaultAsync(q => q.Id == questionId);

            if (question == null) throw new Exception("Question not found.");
            
            // Check if the user is the instructor of the course
            if (!isTA && question.Quiz.Course.InstructorId != userId)
                throw new UnauthorizedAccessException("Not authorized to modify this quiz.");

            question.ImageUrl = imageUrl;
            await _context.SaveChangesAsync();
        }

        public async Task<Quiz> CreateQuizAsync(CreateQuizDto createQuizDto, string userId, bool isTA = false)
        {
            var isInstructor = await _context.Courses
                .AnyAsync(c => c.Id == createQuizDto.CourseId && c.InstructorId == userId);
                
            if (!isInstructor && !isTA)
                throw new UnauthorizedAccessException("Not authorized to create quiz for this course.");

            var quiz = new Quiz
            {
                Title = createQuizDto.Title,
                Description = createQuizDto.Description,
                CourseId = createQuizDto.CourseId,
                DurationMinutes = createQuizDto.DurationMinutes,
                StartDate = createQuizDto.StartDate,
                EndDate = createQuizDto.EndDate,
                IsAutoGraded = createQuizDto.IsAutoGraded,
                AreGradesPublished = false
            };

            _context.Quizzes.Add(quiz);
            await _context.SaveChangesAsync();

            if (createQuizDto.Questions != null && createQuizDto.Questions.Any())
            {
                foreach (var qDto in createQuizDto.Questions)
                {
                    var question = new Question
                    {
                        QuizId = quiz.Id,
                        Text = qDto.Text,
                        ImageUrl = qDto.ImageUrl,
                        IsEssay = qDto.IsEssay,
                        Points = qDto.Points ?? 1
                    };
                    _context.Questions.Add(question);
                    await _context.SaveChangesAsync(); // Save to get Question Id for options

                    if (qDto.Options != null && qDto.Options.Any())
                    {
                        foreach (var oDto in qDto.Options)
                        {
                            var option = new QuestionOption
                            {
                                QuestionId = question.Id,
                                Text = oDto.Text,
                                IsCorrect = oDto.IsCorrect
                            };
                            _context.QuestionOptions.Add(option);
                        }
                    }
                }
                await _context.SaveChangesAsync();
            }
            var quizDto = new QuizDto
            {
                Id = quiz.Id,
                Title = quiz.Title,
                QuestionCount = createQuizDto.Questions?.Count ?? 0,
                TotalMarks = createQuizDto.Questions?.Sum(q => q.Points ?? 1) ?? 0,
                StartDate = quiz.StartDate,
                EndDate = quiz.EndDate,
                DurationMinutes = quiz.DurationMinutes,
                IsAutoGraded = quiz.IsAutoGraded,
                AreGradesPublished = quiz.AreGradesPublished,
                Description = quiz.Description,
                CourseId = quiz.CourseId,
                HasAttempted = false
            };
            await _hubContext.Clients.Group(createQuizDto.CourseId.ToString()).SendAsync("ReceiveNewQuiz", quizDto);

            // Create a Notification record for each enrolled student
            var studentIds = await _context.Enrollments
                .Where(e => e.CourseId == createQuizDto.CourseId)
                .Select(e => e.StudentId)
                .ToListAsync();

            var quizNotifications = studentIds.Select(sid => new Notification
            {
                UserId = sid,
                Title = "New Quiz Available",
                Message = $"A new quiz '{createQuizDto.Title}' has been added to your course.",
                Type = NotificationType.Quiz,
                ReferenceId = quiz.Id.ToString(),
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            }).ToList();

            if (quizNotifications.Any())
            {
                _context.Notifications.AddRange(quizNotifications);
                await _context.SaveChangesAsync();

                // Broadcast to each student's personal group
                foreach (var sid in studentIds)
                {
                    await _notificationHubContext.Clients.Group($"User_{sid}")
                        .SendAsync("ReceiveNotification", new { title = "New Quiz Available", message = $"A new quiz '{createQuizDto.Title}' has been added to your course." });
                }
            }

            return quiz;
        }

        public async Task<bool> GradeEssayAsync(int quizId, int attemptId, double manualScore, string userId, bool isTA = false)
        {
            var quiz = await _context.Quizzes.Include(q => q.Course).FirstOrDefaultAsync(q => q.Id == quizId);
            if (quiz == null) throw new Exception("Quiz not found.");

            if (!isTA && quiz.Course.InstructorId != userId)
                throw new UnauthorizedAccessException("Not authorized to grade this quiz.");

            var attempt = await _context.QuizAttempts.FirstOrDefaultAsync(a => a.Id == attemptId && a.QuizId == quizId);
            if (attempt == null) throw new Exception("Attempt not found.");

            attempt.ManualScore = manualScore;
            attempt.Status = "Graded";
            await _context.SaveChangesAsync();
            
            // Auto-aggregate after manual grading
            await _gradeService.AggregateStudentGradesAsync(quiz.CourseId, attempt.StudentId);
            return true;
        }

        public async Task<bool> PublishGradesAsync(int quizId, string userId, bool isTA = false)
        {
            var quiz = await _context.Quizzes.Include(q => q.Course).FirstOrDefaultAsync(q => q.Id == quizId);
            if (quiz == null) throw new Exception("Quiz not found.");

            if (!isTA && quiz.Course.InstructorId != userId)
                throw new UnauthorizedAccessException("Not authorized to publish grades for this quiz.");

            quiz.AreGradesPublished = true;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateQuizAsync(int quizId, UpdateQuizDto dto, string instructorId, bool isTA = false)
        {
            var quiz = await _context.Quizzes.Include(q => q.Course)
                .FirstOrDefaultAsync(q => q.Id == quizId);

            if (quiz == null) throw new Exception("Quiz not found.");
            if (!isTA && quiz.Course.InstructorId != instructorId)
                throw new UnauthorizedAccessException("Not authorized to update this quiz.");

            quiz.Title = dto.Title;
            quiz.Description = dto.Description;
            quiz.StartDate = dto.StartDate;
            quiz.EndDate = dto.EndDate;
            quiz.DurationMinutes = dto.DurationMinutes;
            quiz.IsAutoGraded = dto.IsAutoGraded;

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<List<CampusConnect.Application.Dtos.Quiz.QuizAttemptDto>> GetQuizAttemptsAsync(int quizId, string instructorId, bool isTA = false)
        {
            var quiz = await _context.Quizzes.Include(q => q.Course)
                .FirstOrDefaultAsync(q => q.Id == quizId);

            if (quiz == null) throw new Exception("Quiz not found.");
            if (!isTA && quiz.Course.InstructorId != instructorId)
                throw new UnauthorizedAccessException("Not authorized to view attempts.");

            var attempts = await _context.QuizAttempts
                .Where(a => a.QuizId == quizId)
                .Join(_context.Users, 
                    a => a.StudentId, 
                    u => u.Id, 
                    (a, u) => new CampusConnect.Application.Dtos.Quiz.QuizAttemptDto
                    {
                        Id = a.Id,
                        QuizId = a.QuizId,
                        StudentId = a.StudentId,
                        StudentName = u.FirstName + " " + u.LastName,
                        Title = quiz.Title,
                        Score = a.Score + (a.ManualScore ?? 0),
                        Status = a.Status,
                        EssayAnswer = a.EssayAnswer
                    }).ToListAsync();

            return attempts;
        }

        public async Task<CampusConnect.Application.Dtos.Quiz.QuizAttemptDto> GetStudentQuizAttemptAsync(int quizId, string studentId)
        {
            var quiz = await _context.Quizzes.Include(q => q.Course).FirstOrDefaultAsync(q => q.Id == quizId);
            if (quiz == null) throw new Exception("Quiz not found.");

            var attempt = await _context.QuizAttempts.FirstOrDefaultAsync(a => a.QuizId == quizId && a.StudentId == studentId);
            if (attempt == null) throw new Exception("Attempt not found.");

            // Do not show results if grades are not published
            if (!quiz.AreGradesPublished)
                throw new UnauthorizedAccessException("Grades are not published yet.");

            return new CampusConnect.Application.Dtos.Quiz.QuizAttemptDto
            {
                Id = attempt.Id,
                QuizId = attempt.QuizId,
                StudentId = attempt.StudentId,
                Title = quiz.Title,
                Score = attempt.Score + (attempt.ManualScore ?? 0),
                Status = attempt.Status,
                EssayAnswer = attempt.EssayAnswer
            };
        }
    }
}
