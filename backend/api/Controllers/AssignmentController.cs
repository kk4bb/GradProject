using CampusConnect.Application.Dtos.Assignment;
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
    public class AssignmentController : ControllerBase
    {
        private readonly IAssignmentService _assignmentService;

        public AssignmentController(IAssignmentService assignmentService)
        {
            _assignmentService = assignmentService;
        }

        [HttpGet("course/{courseId}")]
        public async Task<IActionResult> GetAssignments(int courseId)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var assignments = await _assignmentService.GetAssignmentsByCourseAsync(courseId, userId);
                return Ok(assignments);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetAssignment(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var assignment = await _assignmentService.GetAssignmentDetailAsync(id, userId);
                if (assignment == null) return NotFound();
                return Ok(assignment);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpPost("{id}/submit")]
        public async Task<IActionResult> SubmitAssignment(int id, [FromBody] SubmissionSubmitDto submissionDto)
        {
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
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost("course/{courseId}/create")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> CreateAssignment(int courseId, [FromBody] AssignmentCreateDto dto)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var assignmentId = await _assignmentService.CreateAssignmentAsync(courseId, dto, userId);
                return Ok(new { Id = assignmentId });
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

        [HttpGet("{id}/submissions")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> GetSubmissions(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var submissions = await _assignmentService.GetSubmissionsForAssignmentAsync(id, userId);
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
                var success = await _assignmentService.GradeSubmissionAsync(id, gradeDto, userId);
                return Ok(new { Success = success });
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
