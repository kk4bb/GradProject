using CampusConnect.Application.Dtos.Forum;
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
    public class ForumServiceTests
    {
        private ApplicationDbContext GetDbContext()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;
            return new ApplicationDbContext(options);
        }

        [Fact]
        public async Task GetDiscussionsByCourseAsync_UnauthorizedStudent_ThrowsUnauthorized()
        {
            // Arrange
            var context = GetDbContext();
            var course = new Course { Id = 1, Title = "Private Course", InstructorId = "inst-1", Description = "Test" };
            context.Courses.Add(course);
            await context.SaveChangesAsync();

            var service = new ForumService(context);

            // Act & Assert
            await Assert.ThrowsAsync<UnauthorizedAccessException>(() => 
                service.GetDiscussionsByCourseAsync(1, "unauthorized-student"));
        }

        [Fact]
        public async Task CreatePostAsync_EnrolledStudent_Success()
        {
            // Arrange
            var context = GetDbContext();
            var studentId = "student-1";
            var courseId = 1;
            
            context.Enrollments.Add(new Enrollment { StudentId = studentId, CourseId = courseId });
            context.Discussions.Add(new Discussion { Id = 1, CourseId = courseId, Title = "General" });
            
            await context.SaveChangesAsync();

            var service = new ForumService(context);

            // Act
            var postId = await service.CreatePostAsync(1, new PostCreateDto { Content = "Hello World" }, studentId);

            // Assert
            Assert.True(postId > 0);
            Assert.Equal("Hello World", context.Posts.First().Content);
        }

        [Fact]
        public async Task GetPostsByDiscussionAsync_ReturnsFullHierarchy()
        {
            // Arrange
            var context = GetDbContext();
            var studentId = "student-1";
            var courseId = 1;

            var user = new ApplicationUser { Id = studentId, FirstName = "John", LastName = "Doe", Faculty = "CS" };
            context.Users.Add(user);

            context.Enrollments.Add(new Enrollment { StudentId = studentId, CourseId = courseId });
            context.Discussions.Add(new Discussion { Id = 1, CourseId = courseId, Title = "General" });
            
            var post = new Post { Id = 1, DiscussionId = 1, UserId = studentId, Content = "Main Post" };
            context.Posts.Add(post);
            
            context.Comments.Add(new Comment { Id = 1, PostId = 1, UserId = studentId, Content = "Reply 1" });
            
            await context.SaveChangesAsync();

            var service = new ForumService(context);

            // Act
            var result = await service.GetPostsByDiscussionAsync(1, studentId);

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.Equal("John Doe", result[0].AuthorName);
            Assert.Single(result[0].Comments);
            Assert.Equal("Reply 1", result[0].Comments[0].Content);
        }
    }
}
