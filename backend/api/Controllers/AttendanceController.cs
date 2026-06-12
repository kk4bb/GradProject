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
        [Authorize(Roles = "Instructor,TeachingAssistant,TA")]
        public async Task<IActionResult> CreateSession([FromBody] CreateAttendanceSessionRequest request)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var isTA = User.IsInRole("TeachingAssistant") || User.IsInRole("TA");
                var response = await _attendanceService.CreateSessionAsync(request, userId, isTA);
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
            catch (Exception ex) when (ex.Message.Contains("Invalid QR") || ex.Message.Contains("expired"))
            {
                // Return 404 so Flutter's _extractErrorMessage displays the correct fallback
                return NotFound(new { Message = ex.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { Message = ex.Message });
            }
        }

        [HttpGet("course/{courseId}")]
        [Authorize(Roles = "Instructor,TeachingAssistant,TA,Student")]
        public async Task<IActionResult> GetCourseAttendance(int courseId)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var isStudent = User.IsInRole("Student");

                if (isStudent)
                {
                    // Students only see their own attendance history
                    var records = await _attendanceService.GetStudentAttendanceAsync(courseId, userId);
                    return Ok(records);
                }
                else
                {
                    // Instructors and TAs see the full course report
                    var report = await _attendanceService.GetCourseAttendanceAsync(courseId, userId);
                    return Ok(report);
                }
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

        [HttpDelete("record")]
        [Authorize(Roles = "Instructor,TeachingAssistant,TA")]
        public async Task<IActionResult> RemoveAttendanceRecord([FromBody] RemoveAttendanceRecordRequest request)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var success = await _attendanceService.RemoveAttendanceRecordAsync(request.CourseId, request.StudentId, userId);
                if (success)
                {
                    return Ok(new { Message = "Attendance record removed successfully." });
                }
                return NotFound("Attendance record not found.");
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

        /// <summary>
        /// DEV ONLY: Simulates a student scan for emulator/presentation testing.
        /// </summary>
        [HttpPost("mock-scan/{courseId}")]
        [Authorize(Roles = "Instructor,TeachingAssistant,TA")]
        public async Task<IActionResult> MockScan(int courseId)
        {
            try
            {
                var result = await _attendanceService.MockScanAsync(courseId);
                if (result)
                    return Ok(new { Message = "Mock scan successful. A student attendance has been simulated." });
                return BadRequest(new { Message = "No active session found for this course, or no enrolled students available to mock." });
            }
            catch (Exception ex)
            {
                return BadRequest(new { Message = ex.Message });
            }
        }
    }
}
