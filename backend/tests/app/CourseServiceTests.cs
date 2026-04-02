using CampusConnect.Application.Dtos.Course;
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
    public class CourseServiceTests
    {
        private ApplicationDbContext GetDbContext()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;
            return new ApplicationDbContext(options);
        }

        [Fact]
        public async Task GetCourseDetailsAsync_EnrolledStudent_ReturnsDetails()
        {
            // Arrange
            var context = GetDbContext();
            var studentId = "student-1";
            var instructorId = "inst-1";

            var instructor = new ApplicationUser { Id = instructorId, FirstName = "Dr.", LastName = "Smith", Faculty = "Science" };
            context.Users.Add(instructor);

            var course = new Course { Id = 1, Title = "CS101", InstructorId = instructorId, Description = "Intro to CS" };
            context.Courses.Add(course);
            context.Enrollments.Add(new Enrollment { StudentId = studentId, CourseId = 1 });
            
            var module = new Module { Id = 1, CourseId = 1, Title = "Module 1" };
            context.Modules.Add(module);
            context.Lessons.Add(new Lesson { Id = 1, ModuleId = 1, Title = "Lesson 1" });
            context.EducationalContents.Add(new EducationalContent { LessonId = 1, ContentType = "Video", FileUrl = "http://test.com" });

            await context.SaveChangesAsync();

            var service = new CourseService(context);

            // Act
            var result = await service.GetCourseDetailsAsync(1, studentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("CS101", result.Title);
            Assert.Single(result.Modules);
            Assert.Single(result.Modules[0].Lessons);
            Assert.Single(result.Modules[0].Lessons[0].Contents);
        }

        [Fact]
        public async Task GetCourseDetailsAsync_UnenrolledStudent_ThrowsUnauthorized()
        {
            // Arrange
            var context = GetDbContext();
            var course = new Course { Id = 1, Title = "CS101", InstructorId = "inst-1", Description = "Test" };
            context.Courses.Add(course);
            await context.SaveChangesAsync();

            var service = new CourseService(context);

            // Act & Assert
            await Assert.ThrowsAsync<UnauthorizedAccessException>(() => service.GetCourseDetailsAsync(1, "stranger-1"));
        }

        [Fact]
        public async Task CreateModuleAsync_Instructor_Success()
        {
            // Arrange
            var context = GetDbContext();
            var instructorId = "inst-1";
            var course = new Course { Id = 1, Title = "CS101", InstructorId = instructorId, Description = "Test" };
            context.Courses.Add(course);
            await context.SaveChangesAsync();

            var service = new CourseService(context);

            // Act
            var moduleId = await service.CreateModuleAsync(1, "New Module", instructorId);

            // Assert
            Assert.True(moduleId > 0);
            Assert.Equal("New Module", context.Modules.First().Title);
        }

        [Fact]
        public async Task CreateModuleAsync_NotInstructor_ThrowsUnauthorized()
        {
            // Arrange
            var context = GetDbContext();
            var course = new Course { Id = 1, Title = "CS101", InstructorId = "inst-1", Description = "Test" };
            context.Courses.Add(course);
            await context.SaveChangesAsync();

            var service = new CourseService(context);

            // Act & Assert
            await Assert.ThrowsAsync<UnauthorizedAccessException>(() => service.CreateModuleAsync(1, "New Module", "other-inst"));
        }
    }
}
