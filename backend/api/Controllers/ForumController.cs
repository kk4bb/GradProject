using CampusConnect.Application.Dtos.Forum;
using CampusConnect.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
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

        [HttpGet("course/{courseId}")]
        public async Task<IActionResult> GetDiscussions(int courseId)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var discussions = await _forumService.GetDiscussionsByCourseAsync(courseId, userId);
                return Ok(discussions);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpGet("discussion/{id}")]
        public async Task<IActionResult> GetPosts(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var posts = await _forumService.GetPostsByDiscussionAsync(id, userId);
                if (posts == null) return NotFound();
                return Ok(posts);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpPost("discussion/{id}/post")]
        public async Task<IActionResult> CreatePost(int id, [FromBody] PostCreateDto dto)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var postId = await _forumService.CreatePostAsync(id, dto, userId);
                return Ok(new { Id = postId });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost("post/{id}/comment")]
        public async Task<IActionResult> CreateComment(int id, [FromBody] CommentCreateDto dto)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var commentId = await _forumService.CreateCommentAsync(id, dto, userId);
                return Ok(new { Id = commentId });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost("course/{courseId}/discussion")]
        public async Task<IActionResult> CreateDiscussion(int courseId, [FromBody] string title)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var discussionId = await _forumService.CreateDiscussionAsync(courseId, title, userId);
                return Ok(new { Id = discussionId });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
