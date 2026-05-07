using CampusConnect.Application.Dtos.Quiz;
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
    public class QuizController : ControllerBase
    {
        private readonly IQuizService _quizService;

        public QuizController(IQuizService quizService)
        {
            _quizService = quizService;
        }

        [HttpGet("course/{courseId}")]
        public async Task<IActionResult> GetQuizzes(int courseId)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var quizzes = await _quizService.GetQuizzesByCourseAsync(courseId, userId);
                return Ok(quizzes);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpGet("{id}/take")]
        public async Task<IActionResult> TakeQuiz(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var quiz = await _quizService.GetQuizForTakingAsync(id, userId);
                if (quiz == null) return NotFound();
                return Ok(quiz);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpPost("{id}/submit")]
        public async Task<IActionResult> SubmitQuiz(int id, [FromBody] QuizSubmissionDto submission, [FromQuery] bool showBreakdown = false)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var result = await _quizService.SubmitQuizAsync(id, submission, userId, showBreakdown);
                return Ok(result);
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

        [HttpPost("course/{courseId}")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> CreateQuiz(int courseId, [FromBody] QuizCreateDto dto)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var quizId = await _quizService.CreateQuizAsync(courseId, dto, userId);
                return Ok(new { Id = quizId });
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
