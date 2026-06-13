using CampusConnect.Application.Dtos.Dashboard;
using CampusConnect.Application.Dtos.Student;
using CampusConnect.Application.Interfaces;
using CampusConnect.Infrastructure.Context;
using CampusConnect.Infrastructure.Services;
using CampusConnect.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;

namespace CampusConnect.Tests.App
{
    public class StudentProfileTests
    {
        private ApplicationDbContext GetDbContext()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;
            return new ApplicationDbContext(options);
        }

        [Fact]
        public async Task GetStudentProfileAsync_ReturnsCorrectData()
        {
            // Arrange
            var context = GetDbContext();
            var userId = "student-1";
            var user = new ApplicationUser
            {
                Id = userId,
                UserName = "JohnDoe",
                Email = "john@example.com",
                FirstName = "John",
                LastName = "Doe",
                Faculty = "Engineering",
                AcademicYear = 3,
                CreditHours = 90
            };
            context.Users.Add(user);

            var course = new Course { Id = 1, Title = "Math 101", InstructorId = "inst-1", Description = "Test" };
            context.Courses.Add(course);
            context.Enrollments.Add(new Enrollment { StudentId = userId, CourseId = 1 });
            await context.SaveChangesAsync();

            var fileStorageMock = new Mock<IFileStorageService>();
            var service = new StudentService(context, fileStorageMock.Object);

            // Act
            var result = await service.GetStudentProfileAsync(userId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(userId, result.Id);
            Assert.Equal("John", result.FirstName);
            Assert.Equal("Doe", result.LastName);
            Assert.Equal("Engineering", result.Faculty);
            Assert.Equal(3, result.AcademicYear);
            Assert.Equal(90, result.CreditHours);
            Assert.Equal(1, result.EnrolledCoursesCount);
        }

        [Fact]
        public async Task GetStudentDashboardAsync_ReturnsCorrectData()
        {
            // Arrange
            var context = GetDbContext();
            var studentId = "student-1";
            var instructorId = "inst-1";

            var student = new ApplicationUser
            {
                Id = studentId,
                UserName = "TestStudent",
                FirstName = "Test",
                LastName = "Student",
                Faculty = "Science"
            };
            var instructor = new ApplicationUser
            {
                Id = instructorId,
                UserName = "DrSmith",
                FirstName = "Dr.",
                LastName = "Smith",
                Faculty = "Science"
            };
            context.Users.AddRange(student, instructor);

            var course = new Course { Id = 1, Title = "CS101", InstructorId = instructorId, Description = "Test" };
            context.Courses.Add(course);
            context.Enrollments.Add(new Enrollment { StudentId = studentId, CourseId = 1 });
            
            context.Quizzes.Add(new Quiz { Id = 1, Title = "Quiz 1", Description = "Test Description", CourseId = 1 });
            context.QuizAttempts.Add(new QuizAttempt { StudentId = studentId, QuizId = 1, Score = 85 });

            await context.SaveChangesAsync();

            var fileStorageMock = new Mock<IFileStorageService>();
            var service = new StudentService(context, fileStorageMock.Object);

            // Act
            var result = await service.GetStudentDashboardAsync(studentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Test", result.FirstName);
            Assert.Equal("Student", result.LastName);
            Assert.Single(result.EnrolledCourses);
            Assert.Equal("Dr. Smith", result.EnrolledCourses[0].InstructorName);
            Assert.Single(result.QuizAttempts);
            Assert.Equal(85, result.QuizAttempts[0].Score);
        }
    }
}
