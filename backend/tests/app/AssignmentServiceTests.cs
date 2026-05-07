using CampusConnect.Application.Dtos.Assignment;
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
    public class AssignmentServiceTests
    {
        private readonly Mock<INotificationService> _mockNotificationService;

        public AssignmentServiceTests()
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
        public async Task SubmitAssignmentAsync_PastDueDate_ThrowsException()
        {
            // Arrange
            var context = GetDbContext();
            var assignment = new Assignment
            {
                Id = 1,
                CourseId = 1,
                Title = "Late Assignment",
                Description = "This is a late assignment",
                DueDate = DateTime.UtcNow.AddDays(-1)
            };
            context.Assignments.Add(assignment);
            context.Enrollments.Add(new Enrollment { StudentId = "student-1", CourseId = 1 });
            await context.SaveChangesAsync();

            var service = new AssignmentService(context, _mockNotificationService.Object);

            // Act & Assert
            await Assert.ThrowsAsync<Exception>(() => 
                service.SubmitAssignmentAsync(1, new SubmissionSubmitDto { FileUrl = "test.zip" }, "student-1"));
        }

        [Fact]
        public async Task CreateAssignmentAsync_NotInstructor_ThrowsUnauthorized()
        {
            // Arrange
            var context = GetDbContext();
            var course = new Course { Id = 1, Title = "CS101", InstructorId = "instructor-1", Description = "Test" };
            context.Courses.Add(course);
            await context.SaveChangesAsync();

            var service = new AssignmentService(context, _mockNotificationService.Object);

            // Act & Assert
            await Assert.ThrowsAsync<UnauthorizedAccessException>(() => 
                service.CreateAssignmentAsync(1, new AssignmentCreateDto { Title = "Hacking", Description = "Illegal", DueDate = DateTime.UtcNow.AddDays(7) }, "hacker-1"));
        }

        [Fact]
        public async Task CreateAssignmentAsync_TA_Enrolled_Succeeds()
        {
            // Arrange
            var context = GetDbContext();
            var taId = "ta-1";
            var courseId = 1;
            
            var course = new Course { Id = courseId, Title = "CS101", InstructorId = "instructor-1", Description = "Test" };
            context.Courses.Add(course);
            
            // Add TA role
            var taRole = new IdentityRole { Id = "role-ta", Name = "TA", NormalizedName = "TA" };
            context.Roles.Add(taRole);
            
            // Add User to Role
            context.UserRoles.Add(new IdentityUserRole<string> { UserId = taId, RoleId = "role-ta" });
            
            // Enroll TA in course
            context.Enrollments.Add(new Enrollment { StudentId = taId, CourseId = courseId });
            
            await context.SaveChangesAsync();

            var service = new AssignmentService(context, _mockNotificationService.Object);

            // Act
            var result = await service.CreateAssignmentAsync(courseId, new AssignmentCreateDto { Title = "TA Assignment", Description = "Test Description", DueDate = DateTime.UtcNow.AddDays(7) }, taId);

            // Assert
            Assert.True(result > 0);
            Assert.True(context.Assignments.Any(a => a.Title == "TA Assignment"));
        }

        [Fact]
        public async Task GradeSubmissionAsync_UpdatesGrade()
        {
            // Arrange
            var context = GetDbContext();
            var instructorId = "instructor-1";
            var studentId = "student-1";
            
            var course = new Course { Id = 1, InstructorId = instructorId, Title = "CS101", Description = "Test" };
            context.Courses.Add(course);
            
            var assignment = new Assignment { Id = 1, CourseId = 1, Title = "A1", Description = "Test", DueDate = DateTime.UtcNow.AddDays(1) };
            context.Assignments.Add(assignment);
            
            var submission = new Submission { Id = 1, AssignmentId = 1, StudentId = studentId, FileUrl = "res.zip", Grade = 0 };
            context.Submissions.Add(submission);
            
            await context.SaveChangesAsync();

            var service = new AssignmentService(context, _mockNotificationService.Object);

            // Act
            await service.GradeSubmissionAsync(1, new SubmissionGradeDto { Grade = 95.5 }, instructorId);

            // Assert
            Assert.Equal(95.5, context.Submissions.First().Grade);
        }
    }
}
