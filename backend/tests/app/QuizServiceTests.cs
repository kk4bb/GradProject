using CampusConnect.Application.Dtos.Quiz;
using CampusConnect.Application.Interfaces;
using CampusConnect.Infrastructure.Context;
using CampusConnect.Infrastructure.Services;
using CampusConnect.Infrastructure.Hubs;
using CampusConnect.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.SignalR;
using Moq;
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

        private Mock<IHubContext<T>> GetMockHubContext<T>() where T : Hub
        {
            var mockHubContext = new Mock<IHubContext<T>>();
            var mockClients = new Mock<IHubClients>();
            var mockClientProxy = new Mock<IClientProxy>();
            mockHubContext.Setup(h => h.Clients).Returns(mockClients.Object);
            mockClients.Setup(c => c.Group(It.IsAny<string>())).Returns(mockClientProxy.Object);
            return mockHubContext;
        }

        [Fact]
        public async Task GetQuizForTakingAsync_HidesIsCorrect()
        {
            // Arrange
            var context = GetDbContext();
            var quiz = new Quiz { Id = 1, Title = "Unit Test Quiz", Description = "Test Description", CourseId = 1 };
            context.Quizzes.Add(quiz);
            
            var question = new Question { Id = 1, QuizId = 1, Text = "What is 1+1?" };
            context.Questions.Add(question);
            
            context.QuestionOptions.Add(new QuestionOption { Id = 1, QuestionId = 1, Text = "2", IsCorrect = true });
            context.QuestionOptions.Add(new QuestionOption { Id = 2, QuestionId = 1, Text = "3", IsCorrect = false });
            
            context.Enrollments.Add(new Enrollment { StudentId = "student-1", CourseId = 1 });
            await context.SaveChangesAsync();

            var quizHubMock = GetMockHubContext<QuizHub>();
            var notificationHubMock = GetMockHubContext<NotificationHub>();
            var gradeServiceMock = new Mock<IGradeService>();
            var service = new QuizService(context, quizHubMock.Object, notificationHubMock.Object, gradeServiceMock.Object);

            // Act
            var result = await service.GetQuizForTakingAsync(1, "student-1");

            // Assert
            Assert.NotNull(result);
            // The DTO doesn't even have IsCorrect, so we check if it maps correctly
            Assert.Equal(2, result.Questions[0].Options.Count);
        }

        [Fact]
        public async Task SubmitQuizAsync_EssayQuestion_SetsPendingReviewStatus()
        {
            // Arrange
            var context = GetDbContext();
            var quiz = new Quiz { Id = 1, Title = "Essay Test", Description = "Test Description", CourseId = 1 };
            context.Quizzes.Add(quiz);

            // Q1: Essay Question
            context.Questions.Add(new Question { Id = 1, QuizId = 1, Text = "Explain AI", IsEssay = true });

            context.Enrollments.Add(new Enrollment { StudentId = "student-1", CourseId = 1 });
            await context.SaveChangesAsync();

            var quizHubMock = GetMockHubContext<QuizHub>();
            var notificationHubMock = GetMockHubContext<NotificationHub>();
            var gradeServiceMock = new Mock<IGradeService>();
            var service = new QuizService(context, quizHubMock.Object, notificationHubMock.Object, gradeServiceMock.Object);
            var submission = new QuizSubmissionDto
            {
                Answers = new List<AnswerSubmissionDto>
                {
                    new AnswerSubmissionDto { QuestionId = 1, EssayAnswer = "AI is cool." }
                }
            };

            // Act
            var result = await service.SubmitQuizAsync(1, submission, "student-1", false);

            // Assert
            Assert.Equal("Pending Review", result.Status);
            Assert.Equal(0, result.Score);
        }

        [Fact]
        public async Task SubmitQuizAsync_MixedMCQAndEssay_CalculatesPartialScoreAndSetsPendingReview()
        {
            // Arrange
            var context = GetDbContext();
            var quiz = new Quiz { Id = 1, Title = "Mixed Test", Description = "Test Description", CourseId = 1 };
            context.Quizzes.Add(quiz);

            // Q1: MCQ (Correct)
            context.Questions.Add(new Question { Id = 1, QuizId = 1, Text = "Q1" });
            context.QuestionOptions.Add(new QuestionOption { Id = 1, QuestionId = 1, Text = "A", IsCorrect = true });
            
            // Q2: Essay
            context.Questions.Add(new Question { Id = 2, QuizId = 1, Text = "Q2", IsEssay = true });

            context.Enrollments.Add(new Enrollment { StudentId = "student-1", CourseId = 1 });
            await context.SaveChangesAsync();

            var quizHubMock = GetMockHubContext<QuizHub>();
            var notificationHubMock = GetMockHubContext<NotificationHub>();
            var gradeServiceMock = new Mock<IGradeService>();
            var service = new QuizService(context, quizHubMock.Object, notificationHubMock.Object, gradeServiceMock.Object);
            var submission = new QuizSubmissionDto
            {
                Answers = new List<AnswerSubmissionDto>
                {
                    new AnswerSubmissionDto { QuestionId = 1, SelectedOptionId = 1 },
                    new AnswerSubmissionDto { QuestionId = 2, EssayAnswer = "Essay response" }
                }
            };

            // Act
            var result = await service.SubmitQuizAsync(1, submission, "student-1", false);

            // Assert
            Assert.Equal("Pending Review", result.Status);
            // Partial score for auto-graded questions
            Assert.Equal(1, result.Score); 
        }
    }
}
