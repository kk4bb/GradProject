using CampusConnect.Application.Dtos.Assignment;
using CampusConnect.Application.Interfaces;
using CampusConnect.Infrastructure.Hubs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.IO;
using System.Security.Claims;
using System.Threading.Tasks;

namespace CampusConnect.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class AssignmentController : ControllerBase
    {
        private readonly IAssignmentService _assignmentService;
        private readonly IHubContext<AssignmentHub> _hubContext;
        private readonly IWebHostEnvironment _env;

        public AssignmentController(IAssignmentService assignmentService, IHubContext<AssignmentHub> hubContext, IWebHostEnvironment env)
        {
            _assignmentService = assignmentService;
            _hubContext = hubContext;
            _env = env;
        }

        [HttpGet("course/{courseId}")]
        public async Task<IActionResult> GetAssignments(int courseId)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var isTA = User.IsInRole("TA") || User.IsInRole("TeachingAssistant");
                var assignments = await _assignmentService.GetAssignmentsByCourseAsync(courseId, userId, isTA);
                return Ok(assignments);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetAssignment(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var isTA = User.IsInRole("TA") || User.IsInRole("TeachingAssistant");
                var assignment = await _assignmentService.GetAssignmentDetailAsync(id, userId, isTA);
                if (assignment == null) return NotFound();
                return Ok(assignment);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpPost("{id:int}/submit")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> SubmitAssignment(int id, [FromForm] SubmissionSubmitDto submissionDto, IFormFile? file)
        {
            if (file == null && string.IsNullOrEmpty(submissionDto.Url))
            {
                return BadRequest("Either a file or a URL must be provided.");
            }
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var result = await _assignmentService.SubmitAssignmentAsync(id, submissionDto, userId);
                return Ok(new { AssignmentId = result });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
            catch (DbUpdateException ex)
            {
                var errorMessage = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                return BadRequest(errorMessage);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost("create")]
        [Consumes("multipart/form-data")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> CreateAssignment([FromForm] AssignmentCreateDto dto, IFormFile? file)
        {
            try
            {
                if (file != null && file.Length > 0)
                {
                    var uploadsFolder = Path.Combine(_env.WebRootPath, "uploads", "assignments");
                    if (!Directory.Exists(uploadsFolder))
                        Directory.CreateDirectory(uploadsFolder);

                    var uniqueFileName = Guid.NewGuid().ToString() + "_" + file.FileName;
                    var filePath = Path.Combine(uploadsFolder, uniqueFileName);

                    using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        await file.CopyToAsync(stream);
                    }

                    dto.FileUrl = $"/uploads/assignments/{uniqueFileName}";
                }

                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var isTA = User.IsInRole("TA") || User.IsInRole("TeachingAssistant");
                var assignmentId = await _assignmentService.CreateAssignmentAsync(dto.CourseId, dto, userId, isTA);
                
                // Notify students in the course group
                await _hubContext.Clients.Group(dto.CourseId.ToString()).SendAsync("NewAssignmentAdded", new { Id = assignmentId, Title = dto.Title });

                return Ok(new { Id = assignmentId });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
            catch (DbUpdateException ex)
            {
                var errorMessage = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                return BadRequest(errorMessage);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("{id:int}/submissions")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> GetSubmissions(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var isTA = User.IsInRole("TA") || User.IsInRole("TeachingAssistant");
                var submissions = await _assignmentService.GetSubmissionsForAssignmentAsync(id, userId, isTA);
                return Ok(submissions);
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

        [HttpPatch("submission/{id}/grade")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> GradeSubmission(int id, [FromBody] SubmissionGradeDto gradeDto)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var isTA = User.IsInRole("TA") || User.IsInRole("TeachingAssistant");
                var result = await _assignmentService.GradeSubmissionAsync(id, gradeDto, userId, isTA);
                
                if (result.Success)
                {
                    await _hubContext.Clients.User(result.StudentId).SendAsync("SubmissionGraded", new { AssignmentId = id });
                }

                return Ok(new { Success = result.Success });
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
