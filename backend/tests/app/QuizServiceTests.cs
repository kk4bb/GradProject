using CampusConnect.Application.Dtos.Quiz;
using CampusConnect.Application.Interfaces;
using CampusConnect.Infrastructure.Context;
using CampusConnect.Infrastructure.Services;
using CampusConnect.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;
using Moq;

namespace CampusConnect.Tests.App
{
    public class QuizServiceTests
    {
        private readonly Mock<INotificationService> _mockNotificationService;

        public QuizServiceTests()
        {
            _mockNotificationService = new Mock<INotificationService>();
        }

        private ApplicationDbContext GetDbContext()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;
            return new ApplicationDbContext(options);
        }

        [Fact]
        public async Task CreateQuizAsync_TA_Enrolled_Succeeds()
        {
            // Arrange
            var context = GetDbContext();
            var taId = "ta-1";
            var courseId = 1;

            var course = new Course { Id = courseId, InstructorId = "instructor-1", Title = "CS101", Description = "Test" };
            context.Courses.Add(course);

            // Add TA role
            var taRole = new IdentityRole { Id = "role-ta", Name = "TA", NormalizedName = "TA" };
            context.Roles.Add(taRole);
            context.UserRoles.Add(new IdentityUserRole<string> { UserId = taId, RoleId = "role-ta" });

            // Enroll TA
            context.Enrollments.Add(new Enrollment { StudentId = taId, CourseId = courseId });
            await context.SaveChangesAsync();

            var service = new QuizService(context, _mockNotificationService.Object);

            // Act
            var result = await service.CreateQuizAsync(courseId, new QuizCreateDto { Title = "TA Quiz", Description = "Test", DueDate = DateTime.UtcNow.AddDays(7) }, taId);

            // Assert
            Assert.True(result > 0);
            Assert.True(context.Quizzes.Any(q => q.Title == "TA Quiz"));
        }

        [Fact]
        public async Task GetQuizForTakingAsync_HidesIsCorrect()
        {
            // Arrange
            var context = GetDbContext();
            var quiz = new Quiz { Id = 1, Title = "Unit Test Quiz", CourseId = 1, Description = "Test Description" };
            context.Quizzes.Add(quiz);
            
            var question = new Question { Id = 1, QuizId = 1, Text = "What is 1+1?" };
            context.Questions.Add(question);
            
            context.QuestionOptions.Add(new QuestionOption { Id = 1, QuestionId = 1, Text = "2", IsCorrect = true });
            context.QuestionOptions.Add(new QuestionOption { Id = 2, QuestionId = 1, Text = "3", IsCorrect = false });
            
            context.Enrollments.Add(new Enrollment { StudentId = "student-1", CourseId = 1 });
            await context.SaveChangesAsync();

            var service = new QuizService(context, _mockNotificationService.Object);

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
            var quiz = new Quiz { Id = 1, Title = "Scoring Test", CourseId = 1, Description = "Test Description" };
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

            var service = new QuizService(context, _mockNotificationService.Object);

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
