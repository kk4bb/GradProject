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
    public class CourseController : ControllerBase
    {
        private readonly ICourseService _courseService;

        public CourseController(ICourseService courseService)
        {
            _courseService = courseService;
        }

        [HttpGet("enrolled")]
        public async Task<IActionResult> GetEnrolledCourses()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var courses = await _courseService.GetAllEnrolledCoursesAsync(userId);
            return Ok(courses);
        }

        [HttpGet("assigned")]
        [Authorize(Roles = "Instructor")]
        public async Task<IActionResult> GetAssignedCourses()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var courses = await _courseService.GetAssignedCoursesAsync(userId);
            return Ok(courses);
        }

        [HttpGet("{id}/students")]
        [Authorize(Roles = "Instructor")]
        public async Task<IActionResult> GetEnrolledStudents(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var students = await _courseService.GetEnrolledStudentsAsync(id, userId);
                return Ok(students);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCourseDetails(int id)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var course = await _courseService.GetCourseDetailsAsync(id, userId);
                if (course == null) return NotFound();
                return Ok(course);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpPost("{id}/module")]
        [Authorize(Roles = "Instructor")]
        public async Task<IActionResult> CreateModule(int id, [FromBody] string title)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var moduleId = await _courseService.CreateModuleAsync(id, title, userId);
                return Ok(new { Id = moduleId });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpPost("module/{id}/lesson")]
        [Authorize(Roles = "Instructor")]
        public async Task<IActionResult> AddLesson(int id, [FromBody] string title)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var lessonId = await _courseService.AddLessonAsync(id, title, userId);
                return Ok(new { Id = lessonId });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }

        [HttpPost("lesson/{id}/content")]
        [Authorize(Roles = "Instructor")]
        public async Task<IActionResult> AddContent(int id, [FromQuery] string type, [FromBody] string url)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var contentId = await _courseService.AddContentToLessonAsync(id, type, url, userId);
                return Ok(new { Id = contentId });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
        }
    }
}
