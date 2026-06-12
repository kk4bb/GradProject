using CampusConnect.Application.Dtos.Forum;
using CampusConnect.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Security.Claims;
using System.Threading.Tasks;

namespace CampusConnect.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ForumController : ControllerBase
    {
        private readonly IForumService _forumService;

        public ForumController(IForumService forumService)
        {
            _forumService = forumService;
        }

        // ── Discussions ───────────────────────────────────────────────────────

        [HttpGet("course/{courseId}")]
        public async Task<IActionResult> GetDiscussions(int courseId)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var role = User.Claims.FirstOrDefault(c => c.Type.Contains("role"))?.Value ?? "Student";
                return Ok(await _forumService.GetDiscussionsByCourseAsync(courseId, userId, role));
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
        }

        [HttpPost("course/{courseId}/discussion")]
        public async Task<IActionResult> CreateDiscussion(int courseId, [FromBody] CampusConnect.Application.Dtos.Forum.CreateDiscussionDto dto)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

                // Try literal claim keys first (custom JWT), then standard ClaimTypes URNs
                var firstName = User.Claims.FirstOrDefault(c => c.Type == "firstName" || c.Type == ClaimTypes.GivenName)?.Value ?? "";
                var lastName = User.Claims.FirstOrDefault(c => c.Type == "lastName" || c.Type == ClaimTypes.Surname)?.Value ?? "";
                var authorName = $"{firstName} {lastName}".Trim();
                if (string.IsNullOrWhiteSpace(authorName)) authorName = "Unknown";

                var id = await _forumService.CreateDiscussionAsync(courseId, dto, userId, authorName, null);
                return Ok(new { Id = id });
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (DbUpdateException ex)            { return BadRequest(ex.InnerException?.Message ?? ex.Message); }
            catch (Exception ex)                    { return BadRequest(ex.Message); }
        }

        /// <summary>PUT /api/Forum/discussion/{id}/status  body: "CLOSED"</summary>
        [Authorize(Roles = "Instructor,TA")]
        [HttpPut("discussion/{id}/status")]
        public async Task<IActionResult> UpdateDiscussionStatus(int id, [FromBody] string status)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                await _forumService.UpdateDiscussionStatusAsync(id, status, userId);
                return NoContent();
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (ArgumentException ex)           { return BadRequest(ex.Message); }
            catch (DbUpdateException ex)           { return BadRequest(ex.InnerException?.Message ?? ex.Message); }
            catch (Exception ex)                   { return BadRequest(ex.Message); }
        }

        // ── Posts ─────────────────────────────────────────────────────────────

        [HttpGet("discussion/{id}")]
        public async Task<IActionResult> GetPosts(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var role = User.Claims.FirstOrDefault(c => c.Type.Contains("role"))?.Value ?? "Student";
                var posts = await _forumService.GetPostsByDiscussionAsync(id, userId, role);
                if (posts == null) return NotFound();
                return Ok(posts);
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
        }

        [HttpPost("discussion/{id}/post")]
        public async Task<IActionResult> CreatePost(int id, [FromBody] PostCreateDto dto)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "";
                var role   = User.Claims.FirstOrDefault(c => c.Type.Contains("role"))?.Value ?? "Student";

                // Try literal claim keys first (custom JWT), then standard ClaimTypes URNs
                var firstName = User.Claims.FirstOrDefault(c => c.Type == "firstName" || c.Type == ClaimTypes.GivenName)?.Value ?? "";
                var lastName = User.Claims.FirstOrDefault(c => c.Type == "lastName" || c.Type == ClaimTypes.Surname)?.Value ?? "";
                var authorName = $"{firstName} {lastName}".Trim();
                if (string.IsNullOrWhiteSpace(authorName)) authorName = "Unknown";

                var postId = await _forumService.CreatePostAsync(id, dto, userId, role, authorName, null);
                return Ok(new { Id = postId });
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (DbUpdateException ex)           { return BadRequest(ex.InnerException?.Message ?? ex.Message); }
            catch (Exception ex)                   { return BadRequest(ex.Message); }
        }

        /// <summary>POST /api/Forum/post/{id}/correct — Toggles IsCorrect flag.</summary>
        [Authorize(Roles = "Instructor,TA")]
        [HttpPost("post/{id}/correct")]
        public async Task<IActionResult> MarkPostAsCorrect(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "";
                var role = User.Claims.FirstOrDefault(c => c.Type.Contains("role"))?.Value ?? "Instructor";
                await _forumService.MarkPostAsCorrectAsync(id, userId, role);
                return NoContent();
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (DbUpdateException ex)           { return BadRequest(ex.InnerException?.Message ?? ex.Message); }
            catch (Exception ex)                   { return BadRequest(ex.Message); }
        }

        /// <summary>POST /api/Forum/post/{id}/vote  body: true (upvote) / false (downvote)</summary>
        [HttpPost("post/{id}/vote")]
        public async Task<IActionResult> VotePost(int id, [FromBody] bool isUpvote)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "";
                await _forumService.VotePostAsync(id, isUpvote, userId);
                return NoContent();
            }
            catch (DbUpdateException ex) { return BadRequest(ex.InnerException?.Message ?? ex.Message); }
            catch (Exception ex)         { return BadRequest(ex.Message); }
        }

        // ── Comments ──────────────────────────────────────────────────────────

        [HttpPost("post/{id}/comment")]
        public async Task<IActionResult> CreateComment(int id, [FromBody] CommentCreateDto dto)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "";
                var role = User.Claims.FirstOrDefault(c => c.Type.Contains("role"))?.Value ?? "Student";
                var commentId = await _forumService.CreateCommentAsync(id, dto, userId, role);
                return Ok(new { Id = commentId });
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (DbUpdateException ex)           { return BadRequest(ex.InnerException?.Message ?? ex.Message); }
            catch (Exception ex)                   { return BadRequest(ex.Message); }
        }
    }
}
