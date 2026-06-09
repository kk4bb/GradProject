using CampusConnect.Application.Dtos.Quiz;
using CampusConnect.Application.Interfaces;
using CampusConnect.Infrastructure.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using CampusConnect.Infrastructure.Hubs;
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
        private readonly IFileStorageService _fileStorageService;
        private readonly IHubContext<QuizHub> _quizHub;

        public QuizController(IQuizService quizService, IFileStorageService fileStorageService, IHubContext<QuizHub> quizHub)
        {
            _quizService = quizService;
            _fileStorageService = fileStorageService;
            _quizHub = quizHub;
        }
        // ... (existing endpoints)
        
        [HttpPost]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> CreateQuiz([FromBody] CreateQuizDto createQuizDto)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var createdQuiz = await _quizService.CreateQuizAsync(createQuizDto, userId);

                // Broadcast to students enrolled in this course
                await _quizHub.Clients.Group(createQuizDto.CourseId.ToString())
                    .SendAsync("ReceiveNewQuiz", createdQuiz);

                return Ok(createdQuiz);
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (Exception ex) { return BadRequest(ex.Message); }
        }

        [HttpPost("question/{questionId}/image")]
        [Authorize(Roles = "Instructor")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadQuestionImage(int questionId, IFormFile file)
        {
            if (!FileUploadHelper.IsValidFile(file, out var errorMessage))
                return BadRequest(errorMessage);

            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var fileUrl = await _fileStorageService.SaveFileAsync(file);
                await _quizService.UpdateQuestionImageAsync(questionId, fileUrl, userId);

                return Ok(new { Url = fileUrl });
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (Exception ex) { return BadRequest(ex.Message); }
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
                return StatusCode(403, ex.Message);
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
                return StatusCode(403, ex.Message);
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
                return StatusCode(403, ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut("{id}/attempts/{attemptId}/grade")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> GradeEssay(int id, int attemptId, [FromBody] double manualScore)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var result = await _quizService.GradeEssayAsync(id, attemptId, manualScore, userId);
                return Ok(result);
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (Exception ex) { return BadRequest(ex.Message); }
        }

        [HttpPut("{id}/publish-grades")]
        [Authorize(Roles = "Instructor")]
        public async Task<IActionResult> PublishGrades(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var result = await _quizService.PublishGradesAsync(id, userId);
                return Ok(result);
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (Exception ex) { return BadRequest(ex.Message); }
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> UpdateQuiz(int id, [FromBody] UpdateQuizDto dto)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var result = await _quizService.UpdateQuizAsync(id, dto, userId);
                return Ok(result);
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (Exception ex) { return BadRequest(ex.Message); }
        }

        [HttpGet("{id}/attempts")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> GetQuizAttempts(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var attempts = await _quizService.GetQuizAttemptsAsync(id, userId);
                return Ok(attempts);
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (Exception ex) { return BadRequest(ex.Message); }
        }

        [HttpGet("{id}/my-attempt")]
        [Authorize(Roles = "Student")]
        public async Task<IActionResult> GetMyAttempt(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var attempt = await _quizService.GetStudentQuizAttemptAsync(id, userId);
                return Ok(attempt);
            }
            catch (UnauthorizedAccessException ex) { return StatusCode(403, ex.Message); }
            catch (Exception ex) { return BadRequest(ex.Message); }
        }
    }
}
