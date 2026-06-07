using CampusConnect.Application.Dtos.AI;
using CampusConnect.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.Threading.Tasks;

namespace CampusConnect.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class AIController : ControllerBase
    {
        private readonly IAIService _aiService;

        public AIController(IAIService aiService)
        {
            _aiService = aiService;
        }

        /// <summary>GET /api/ai/sessions — Get all sessions for the current user.</summary>
        [HttpGet("sessions")]
        public async Task<IActionResult> GetSessions()
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "";
                var sessions = await _aiService.GetUserSessionsAsync(userId);
                return Ok(sessions);
            }
            catch (System.Exception ex) { return BadRequest(ex.Message); }
        }

        /// <summary>GET /api/ai/sessions/{sessionId}/messages — Get messages for a session.</summary>
        [HttpGet("sessions/{sessionId}/messages")]
        public async Task<IActionResult> GetMessages(int sessionId)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "";
                var messages = await _aiService.GetSessionMessagesAsync(sessionId, userId);
                return Ok(messages);
            }
            catch (System.UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (System.Exception ex)                   { return BadRequest(ex.Message); }
        }

        /// <summary>POST /api/ai/message — Send a message and get the AI reply.</summary>
        [HttpPost("message")]
        public async Task<IActionResult> SendMessage([FromBody] SendMessageRequest request)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "";
                var reply = await _aiService.SendMessageAsync(userId, request);
                return Ok(new { reply });
            }
            catch (System.UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (System.Exception ex)                   { return BadRequest(ex.Message); }
        }

        /// <summary>DELETE /api/ai/sessions/{sessionId} — Delete a session and its messages.</summary>
        [HttpDelete("sessions/{sessionId}")]
        public async Task<IActionResult> DeleteSession(int sessionId)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "";
                await _aiService.DeleteSessionAsync(sessionId, userId);
                return NoContent();
            }
            catch (System.UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (System.Exception ex)                   { return BadRequest(ex.Message); }
        }
    }
}
