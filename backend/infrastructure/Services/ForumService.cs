using CampusConnect.Application.Dtos.Forum;
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
    public class ForumService : IForumService
    {
        private readonly ApplicationDbContext _context;

        public ForumService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<DiscussionDto>> GetDiscussionsByCourseAsync(int courseId, string userId)
        {
            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == courseId && e.StudentId == userId);
            var isInstructor = await _context.Courses.AnyAsync(c => c.Id == courseId && c.InstructorId == userId);

            if (!isEnrolled && !isInstructor)
                throw new UnauthorizedAccessException("Not authorized to view forum for this course.");

            return await _context.Discussions
                .Where(d => d.CourseId == courseId)
                .Select(d => new DiscussionDto
                {
                    Id = d.Id,
                    Title = d.Title,
                    PostCount = d.Posts.Count
                }).ToListAsync();
        }

        public async Task<List<PostDto>> GetPostsByDiscussionAsync(int discussionId, string userId)
        {
            var discussion = await _context.Discussions.FirstOrDefaultAsync(d => d.Id == discussionId);
            if (discussion == null) return null;

            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == discussion.CourseId && e.StudentId == userId);
            var isInstructor = await _context.Courses.AnyAsync(c => c.Id == discussion.CourseId && c.InstructorId == userId);

            if (!isEnrolled && !isInstructor)
                throw new UnauthorizedAccessException("Not authorized to view this discussion.");

            return await _context.Posts
                .Where(p => p.DiscussionId == discussionId)
                .Select(p => new PostDto
                {
                    Id = p.Id,
                    AuthorName = _context.Users
                        .Where(u => u.Id == p.UserId)
                        .Select(u => $"{u.FirstName} {u.LastName}")
                        .FirstOrDefault() ?? "Unknown",
                    Content = p.Content,
                    CommentCount = p.Comments.Count,
                    Comments = p.Comments.Select(c => new CommentDto
                    {
                        Id = c.Id,
                        AuthorName = _context.Users
                            .Where(u => u.Id == c.UserId)
                            .Select(u => $"{u.FirstName} {u.LastName}")
                            .FirstOrDefault() ?? "Unknown",
                        Content = c.Content
                    }).ToList()
                }).ToListAsync();
        }

        public async Task<int> CreatePostAsync(int discussionId, PostCreateDto dto, string userId)
        {
            var discussion = await _context.Discussions.FindAsync(discussionId);
            if (discussion == null) throw new Exception("Discussion not found.");

            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == discussion.CourseId && e.StudentId == userId);
            var isInstructor = await _context.Courses.AnyAsync(c => c.Id == discussion.CourseId && c.InstructorId == userId);

            if (!isEnrolled && !isInstructor)
                throw new UnauthorizedAccessException("Not authorized to post in this forum.");

            var post = new Post
            {
                DiscussionId = discussionId,
                UserId = userId,
                Content = dto.Content
            };

            _context.Posts.Add(post);
            await _context.SaveChangesAsync();
            return post.Id;
        }

        public async Task<int> CreateCommentAsync(int postId, CommentCreateDto dto, string userId)
        {
            var post = await _context.Posts
                .Include(p => p.Discussion)
                .FirstOrDefaultAsync(p => p.Id == postId);

            if (post == null) throw new Exception("Post not found.");

            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == post.Discussion.CourseId && e.StudentId == userId);
            var isInstructor = await _context.Courses.AnyAsync(c => c.Id == post.Discussion.CourseId && c.InstructorId == userId);

            if (!isEnrolled && !isInstructor)
                throw new UnauthorizedAccessException("Not authorized to comment in this forum.");

            var comment = new Comment
            {
                PostId = postId,
                UserId = userId,
                Content = dto.Content
            };

            _context.Comments.Add(comment);
            await _context.SaveChangesAsync();
            return comment.Id;
        }

        public async Task<int> CreateDiscussionAsync(int courseId, string title, string userId)
        {
            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == courseId && e.StudentId == userId);
            var isInstructor = await _context.Courses.AnyAsync(c => c.Id == courseId && c.InstructorId == userId);

            if (!isEnrolled && !isInstructor)
                throw new UnauthorizedAccessException("Only the instructor or enrolled students can create new discussion topics.");

            var discussion = new Discussion
            {
                CourseId = courseId,
                Title = title
            };

            _context.Discussions.Add(discussion);
            await _context.SaveChangesAsync();
            return discussion.Id;
        }
    }
}
