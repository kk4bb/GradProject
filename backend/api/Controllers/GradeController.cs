using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using CampusConnect.Application.Dtos.Grades;
using CampusConnect.Application.Interfaces;
using CampusConnect.Infrastructure.Hubs;

namespace CampusConnect.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class GradeController : ControllerBase
    {
        private readonly IGradeService _gradeService;
        private readonly IHubContext<GradeHub> _hubContext;

        public GradeController(IGradeService gradeService, IHubContext<GradeHub> hubContext)
        {
            _gradeService = gradeService;
            _hubContext = hubContext;
        }

        [HttpGet("{courseId}/student/{studentId}")]
        public async Task<ActionResult<GradeRecordDto>> GetStudentGrades(int courseId, string studentId)
        {
            var record = await _gradeService.GetGradeRecordAsync(courseId, studentId);
            return Ok(record);
        }

        [HttpGet("{courseId}")]
        public async Task<ActionResult<List<GradeRecordDto>>> GetCourseGrades(int courseId)
        {
            var records = await _gradeService.GetCourseGradesAsync(courseId);
            return Ok(records);
        }

        [HttpPut("{courseId}/student/{studentId}")]
        public async Task<ActionResult<GradeRecordDto>> UpdateGrades(int courseId, string studentId, [FromBody] UpdateGradeDto dto)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var isTA = User.IsInRole("TA");

            var updatedRecord = await _gradeService.UpdateGradeRecordAsync(courseId, studentId, dto, userId, isTA);

            // Broadcast real-time update
            await _hubContext.Clients.Group($"Course_{courseId}_Grades").SendAsync("ReceiveGradeUpdate", updatedRecord);

            return Ok(updatedRecord);
        }

        [HttpPost("{courseId}/publish")]
        [Authorize(Roles = "Instructor")]
        public async Task<ActionResult> PublishTermWork(int courseId)
        {
            var instructorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            await _gradeService.PublishTermWorkAsync(courseId, instructorId);
            return Ok(new { message = "Term work published successfully." });
        }

        [HttpPost("{courseId}/unlock")]
        [Authorize(Roles = "Instructor")]
        public async Task<ActionResult> UnlockTermWork(int courseId)
        {
            var instructorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            await _gradeService.UnlockTermWorkAsync(courseId, instructorId);
            return Ok(new { message = "Term work unlocked successfully." });
        }
    }
}
