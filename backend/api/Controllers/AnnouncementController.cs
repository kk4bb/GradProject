using System.Threading.Tasks;
using CampusConnect.Application.Dtos.Announcement;
using CampusConnect.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CampusConnect.API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class AnnouncementController : ControllerBase
    {
        private readonly IAnnouncementService _announcementService;

        public AnnouncementController(IAnnouncementService announcementService)
        {
            _announcementService = announcementService;
        }

        [HttpPost]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> CreateAnnouncement([FromBody] AnnouncementCreateDto dto)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            if (!ModelState.IsValid) return BadRequest(ModelState);

            var announcement = await _announcementService.CreateAnnouncementAsync(userId, dto);
            return Ok(announcement);
        }

        [HttpGet("course/{courseId}")]
        public async Task<IActionResult> GetCourseAnnouncements(int courseId)
        {
            var announcements = await _announcementService.GetCourseAnnouncementsAsync(courseId);
            return Ok(announcements);
        }

        [HttpGet("manage/{courseId}")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> GetManageCourseAnnouncements(int courseId)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var announcements = await _announcementService.GetManageCourseAnnouncementsAsync(courseId, userId);
            return Ok(announcements);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> UpdateAnnouncement(int id, [FromBody] AnnouncementUpdateDto dto)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            if (!ModelState.IsValid) return BadRequest(ModelState);

            var announcement = await _announcementService.UpdateAnnouncementAsync(id, userId, dto);
            if (announcement == null) return NotFound();

            return Ok(announcement);
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Instructor,TA")]
        public async Task<IActionResult> DeleteAnnouncement(int id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var success = await _announcementService.DeleteAnnouncementAsync(id, userId);
            if (!success) return NotFound();

            return NoContent();
        }
    }
}
