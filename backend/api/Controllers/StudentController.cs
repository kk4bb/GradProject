using CampusConnect.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.Threading.Tasks;

namespace CampusConnect.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class StudentController : ControllerBase
    {
        private readonly IStudentService _studentService;

        public StudentController(IStudentService studentService)
        {
            _studentService = studentService;
        }

        [HttpGet("{studentId}")]
        public async Task<IActionResult> GetDashboard(string studentId)
        {
            var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var isInstructor = User.IsInRole("Instructor") || User.IsInRole("TA");

            // Security Check
            if (currentUserId != studentId)
            {
                if (!isInstructor || !await _studentService.IsInstructorForStudentAsync(currentUserId, studentId))
                {
                    return Forbid("You do not have permission to view this student's data.");
                }
            }

            var dashboard = await _studentService.GetStudentDashboardAsync(studentId);
            if (dashboard == null) return NotFound();

            return Ok(dashboard);
        }

        [HttpGet("me")]
        public async Task<IActionResult> GetMyDashboard()
        {
            var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var dashboard = await _studentService.GetStudentDashboardAsync(currentUserId);
            return Ok(dashboard);
        }

        [HttpGet("profile/{studentId}")]
        public async Task<IActionResult> GetProfile(string studentId)
        {
            var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var isInstructor = User.IsInRole("Instructor") || User.IsInRole("TA");

            // Security Check
            if (currentUserId != studentId)
            {
                if (!isInstructor || !await _studentService.IsInstructorForStudentAsync(currentUserId, studentId))
                {
                    return Forbid("You do not have permission to view this student's data.");
                }
            }

            var profile = await _studentService.GetStudentProfileAsync(studentId);
            if (profile == null) return NotFound();

            return Ok(profile);
        }

        [HttpGet("profile/me")]
        public async Task<IActionResult> GetMyProfile()
        {
            var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var profile = await _studentService.GetStudentProfileAsync(currentUserId);
            return Ok(profile);
        }
    }
}
