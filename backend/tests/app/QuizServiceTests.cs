using CampusConnect.Application.Dtos.Quiz;
using CampusConnect.Infrastructure.Context;
using CampusConnect.Infrastructure.Services;
using CampusConnect.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;

namespace CampusConnect.Tests.App
{
    public class QuizServiceTests
    {
        private ApplicationDbContext GetDbContext()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;
            return new ApplicationDbContext(options);
        }

        [Fact]
        public async Task GetQuizForTakingAsync_HidesIsCorrect()
        {
            // Arrange
            var context = GetDbContext();
            var quiz = new Quiz { Id = 1, Title = "Unit Test Quiz", CourseId = 1 };
            context.Quizzes.Add(quiz);
            
            var question = new Question { Id = 1, QuizId = 1, Text = "What is 1+1?" };
            context.Questions.Add(question);
            
            context.QuestionOptions.Add(new QuestionOption { Id = 1, QuestionId = 1, Text = "2", IsCorrect = true });
            context.QuestionOptions.Add(new QuestionOption { Id = 2, QuestionId = 1, Text = "3", IsCorrect = false });
            
            context.Enrollments.Add(new Enrollment { StudentId = "student-1", CourseId = 1 });
            await context.SaveChangesAsync();

            var service = new QuizService(context);

            // Act
            var result = await service.GetQuizForTakingAsync(1, "student-1");

            // Assert
            Assert.NotNull(result);
            // The DTO doesn't even have IsCorrect, so we check if it maps correctly
            Assert.Equal(2, result.Questions[0].Options.Count);
        }

        [Fact]
        public async Task SubmitQuizAsync_CalculatesCorrectScore()
        {
            // Arrange
            var context = GetDbContext();
            var quiz = new Quiz { Id = 1, Title = "Scoring Test", CourseId = 1 };
            context.Quizzes.Add(quiz);

            // Q1: Correct is 1
            context.Questions.Add(new Question { Id = 1, QuizId = 1, Text = "Q1" });
            context.QuestionOptions.Add(new QuestionOption { Id = 1, QuestionId = 1, Text = "A", IsCorrect = true });
            context.QuestionOptions.Add(new QuestionOption { Id = 2, QuestionId = 1, Text = "B", IsCorrect = false });

            // Q2: Correct is 3
            context.Questions.Add(new Question { Id = 2, QuizId = 1, Text = "Q2" });
            context.QuestionOptions.Add(new QuestionOption { Id = 3, QuestionId = 2, Text = "C", IsCorrect = true });
            context.QuestionOptions.Add(new QuestionOption { Id = 4, QuestionId = 2, Text = "D", IsCorrect = false });

            context.Enrollments.Add(new Enrollment { StudentId = "student-1", CourseId = 1 });
            await context.SaveChangesAsync();

            var service = new QuizService(context);

            // Act: 1 correct, 1 wrong
            var submission = new QuizSubmissionDto
            {
                Answers = new List<AnswerSubmissionDto>
                {
                    new AnswerSubmissionDto { QuestionId = 1, SelectedOptionId = 1 }, // Correct
                    new AnswerSubmissionDto { QuestionId = 2, SelectedOptionId = 4 }  // Wrong
                }
            };

            var result = await service.SubmitQuizAsync(1, submission, "student-1", true);

            // Assert
            Assert.Equal(50, result.Score);
            Assert.Equal(2, result.TotalQuestions);
            Assert.Equal(1, result.CorrectAnswersCount);
            Assert.NotNull(result.Breakdown);
            Assert.Equal(2, result.Breakdown.Count);
            Assert.True(result.Breakdown[0].IsCorrect);
            Assert.False(result.Breakdown[1].IsCorrect);
        }
    }
}
