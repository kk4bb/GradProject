using CampusConnect.Application.Dtos.AiChat;
using CampusConnect.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace CampusConnect.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class AiController : ControllerBase
    {
        private readonly IAiChatService _aiChatService;

        public AiController(IAiChatService aiChatService)
        {
            _aiChatService = aiChatService;
        }

        [HttpPost("chat")]
        public async Task<IActionResult> Chat([FromBody] AiChatRequestDto request)
        {
            try
            {
                var response = await _aiChatService.GetChatResponseAsync(request);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return BadRequest(new { Message = ex.Message });
            }
        }
    }
}
