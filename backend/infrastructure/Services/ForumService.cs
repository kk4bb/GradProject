using CampusConnect.Application.Dtos.Forum;
using CampusConnect.Application.Interfaces;
using CampusConnect.Domain.Entities;
using CampusConnect.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.SignalR;
using CampusConnect.Infrastructure.Hubs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Services
{
    public class ForumService : IForumService
    {
        private readonly ApplicationDbContext _context;
        private readonly IHubContext<ForumHub> _hubContext;

        public ForumService(ApplicationDbContext context, IHubContext<ForumHub> hubContext)
        {
            _context = context;
            _hubContext = hubContext;
        }

        // ── Helpers ──────────────────────────────────────────────────────────

        private async Task<bool> IsAuthorizedForCourseAsync(int courseId, string userId, string role)
        {
            if (role == "TA" || role == "Instructor") return true;

            var isEnrolled  = await _context.Enrollments.AnyAsync(e => e.CourseId == courseId && e.StudentId == userId);
            var isInstructor = await _context.Courses.AnyAsync(c => c.Id == courseId && c.InstructorId == userId);
            return isEnrolled || isInstructor;
        }

        private bool IsInstructorOrTa(string role) =>
            role == "Doctor" || role == "TA" || role == "Instructor";

        // ── Discussions ───────────────────────────────────────────────────────

        public async Task<List<DiscussionDto>> GetDiscussionsByCourseAsync(int courseId, string userId, string role)
        {
            if (!await IsAuthorizedForCourseAsync(courseId, userId, role))
                throw new UnauthorizedAccessException("Not authorized to view forum for this course.");

            return await _context.Discussions
                .Where(d => d.CourseId == courseId)
                .OrderByDescending(d => d.CreatedAt)
                .Select(d => new DiscussionDto
                {
                    Id        = d.Id,
                    Title     = d.Title,
                    PostCount = d.Posts.Count,
                    Status    = d.Status,
                    CreatedAt = d.CreatedAt.ToString("o"),
                    AuthorName = d.Posts.OrderBy(p => p.CreatedAt)
                                  .Select(p => _context.Users.Where(u => u.Id == p.UserId).Select(u => u.FirstName + " " + u.LastName).FirstOrDefault())
                                  .FirstOrDefault() ?? "Unknown",
                    Content   = d.Content,
                }).ToListAsync();
        }

        public async Task<int> CreateDiscussionAsync(int courseId, CreateDiscussionDto dto, string userId, string authorName)
        {
            var discussion = new Discussion
            {
                CourseId   = courseId,
                Title      = dto.Title,
                Content    = dto.Content,
                Status     = "OPEN",
                CreatedAt  = DateTime.UtcNow,
            };
            _context.Discussions.Add(discussion);
            await _context.SaveChangesAsync();

            // اتبعتت كأوبجكت مباشر
            await _hubContext.Clients.Group(courseId.ToString()).SendAsync("ReceiveNewDiscussion", new {
                id = discussion.Id, title = discussion.Title, postCount = 0, status = discussion.Status,
                createdAt = discussion.CreatedAt.ToString("o"), authorName = authorName, content = discussion.Content
            });

            return discussion.Id;
        }

        public async Task UpdateDiscussionStatusAsync(int discussionId, string status, string userId)
        {
            var discussion = await _context.Discussions
                .Include(d => d.Posts)
                .FirstOrDefaultAsync(d => d.Id == discussionId);
            if (discussion == null) throw new Exception("Discussion not found.");

            var allowed = new[] { "OPEN", "CLOSED", "RESOLVED" };
            if (!allowed.Contains(status.ToUpper()))
                throw new ArgumentException($"Invalid status '{status}'. Allowed: OPEN, CLOSED, RESOLVED.");

            discussion.Status = status.ToUpper();
            await _context.SaveChangesAsync();
        }

        // ── Posts ─────────────────────────────────────────────────────────────

        public async Task<List<PostDto>> GetPostsByDiscussionAsync(int discussionId, string userId, string role)
        {
            var discussion = await _context.Discussions.FindAsync(discussionId);
            if (discussion == null) return null;

            if (!await IsAuthorizedForCourseAsync(discussion.CourseId, userId, role))
                throw new UnauthorizedAccessException("Not authorized to view this discussion.");

            return await _context.Posts
                .Where(p => p.DiscussionId == discussionId)
                .OrderByDescending(p => p.Votes)
                .ThenBy(p => p.CreatedAt)
                .Select(p => new PostDto
                {
                    Id           = p.Id,
                    AuthorName   = _context.Users
                                    .Where(u => u.Id == p.UserId)
                                    .Select(u => $"{u.FirstName} {u.LastName}")
                                    .FirstOrDefault() ?? "Unknown",
                    Content      = p.Content,
                    CommentCount = p.Comments.Count,
                    IsCorrect    = p.IsCorrect,
                    ApprovedByRole = p.ApprovedByRole,
                    Votes        = p.Votes,
                    CreatedAt    = p.CreatedAt.ToString("o"),
                    Comments     = p.Comments.Select(c => new CommentDto
                    {
                        Id         = c.Id,
                        AuthorName = _context.Users
                                        .Where(u => u.Id == c.UserId)
                                        .Select(u => $"{u.FirstName} {u.LastName}")
                                        .FirstOrDefault() ?? "Unknown",
                        Content    = c.Content,
                    }).ToList()
                }).ToListAsync();
        }

        public async Task<int> CreatePostAsync(int discussionId, PostCreateDto dto, string userId, string role, string authorName)
        {
            var discussion = await _context.Discussions.FindAsync(discussionId);
            if (discussion == null) throw new Exception("Discussion not found.");

            if (!await IsAuthorizedForCourseAsync(discussion.CourseId, userId, role))
                throw new UnauthorizedAccessException("Not authorized to post in this forum.");

            var post = new Post
            {
                DiscussionId   = discussionId,
                UserId         = userId,
                Content        = dto.Content,
                CreatedAt      = DateTime.UtcNow,
                ApprovedByRole = "",
            };
            _context.Posts.Add(post);
            await _context.SaveChangesAsync();

            // تم التعديل: اتبعتت كأوبجكت مباشر
            await _hubContext.Clients.Group(discussion.CourseId.ToString()).SendAsync("ReceiveNewPost", new {
                id = post.Id, discussionId = discussion.Id, authorName = authorName, content = post.Content,
                commentCount = 0, isCorrect = false, votes = 0, createdAt = post.CreatedAt.ToString("o"), approvedByRole = ""
            });

            return post.Id;
        }

        public async Task MarkPostAsCorrectAsync(int postId, string userId, string role)
        {
            var post = await _context.Posts
                .Include(p => p.Discussion)
                .FirstOrDefaultAsync(p => p.Id == postId);
            if (post == null) throw new Exception("Post not found.");

            // Toggle — clicking again un-marks it
            post.IsCorrect = !post.IsCorrect;
            
            if (post.IsCorrect)
            {
                post.Discussion.Status = "RESOLVED";
            }
            post.ApprovedByRole = post.IsCorrect ? role : "";

            await _context.SaveChangesAsync();

            // تم التعديل: اتبعتت كأوبجكت مباشر
            await _hubContext.Clients.Group(post.Discussion.CourseId.ToString()).SendAsync("ReceiveCorrectAnswer", new {
                id = post.Id, isCorrect = post.IsCorrect, approvedByRole = post.ApprovedByRole
            });
        }

        public async Task VotePostAsync(int postId, bool isUpvote, string userId)
        {
            var post = await _context.Posts
                .Include(p => p.Discussion)
                .FirstOrDefaultAsync(p => p.Id == postId);
            if (post == null) throw new Exception("Post not found.");
            post.Votes += isUpvote ? 1 : -1;
            await _context.SaveChangesAsync();

            // تم التعديل: اتبعتت كأوبجكت مباشر
            await _hubContext.Clients.Group(post.Discussion.CourseId.ToString()).SendAsync("ReceiveVoteUpdate", new {
                id = post.Id, votes = post.Votes
            });
        }

        // ── Comments ──────────────────────────────────────────────────────────

        public async Task<int> CreateCommentAsync(int postId, CommentCreateDto dto, string userId, string role)
        {
            var post = await _context.Posts
                .Include(p => p.Discussion)
                .FirstOrDefaultAsync(p => p.Id == postId);
            if (post == null) throw new Exception("Post not found.");

            if (!await IsAuthorizedForCourseAsync(post.Discussion.CourseId, userId, role))
                throw new UnauthorizedAccessException("Not authorized to comment in this forum.");

            var comment = new Comment
            {
                PostId  = postId,
                UserId  = userId,
                Content = dto.Content,
            };
            _context.Comments.Add(comment);
            await _context.SaveChangesAsync();
            return comment.Id;
        }
    }
}