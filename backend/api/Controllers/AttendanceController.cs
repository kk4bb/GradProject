using CampusConnect.Application.Dtos.Attendance;
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
    public class AttendanceController : ControllerBase
    {
        private readonly IAttendanceService _attendanceService;

        public AttendanceController(IAttendanceService attendanceService)
        {
            _attendanceService = attendanceService;
        }

        [HttpPost("session")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> CreateSession([FromBody] CreateAttendanceSessionRequest request)
        {
            try
            {
                var instructorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var response = await _attendanceService.CreateSessionAsync(request, instructorId);
                return Ok(response);
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

        [HttpPost("mark")]
        public async Task<IActionResult> MarkAttendance([FromBody] MarkAttendanceRequest request)
        {
            try
            {
                var studentId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                await _attendanceService.MarkAttendanceAsync(request, studentId);
                return Ok(new { Message = "Attendance marked successfully." });
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

        [HttpGet("course/{courseId}")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> GetCourseAttendance(int courseId)
        {
            try
            {
                var instructorId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var report = await _attendanceService.GetCourseAttendanceAsync(courseId, instructorId);
                return Ok(report);
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

        [HttpGet("my/{courseId}")]
        public async Task<IActionResult> GetMyAttendance(int courseId)
        {
            try
            {
                var studentId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var records = await _attendanceService.GetStudentAttendanceAsync(courseId, studentId);
                return Ok(records);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
