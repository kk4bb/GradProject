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
    public class CalendarController : ControllerBase
    {
        private readonly ICalendarService _calendarService;

        public CalendarController(ICalendarService calendarService)
        {
            _calendarService = calendarService;
        }

        /// <summary>
        /// Returns all calendar events (Assignments, Quizzes) for the authenticated user
        /// within the given date range.
        /// </summary>
        /// <param name="startDate">Start of the range (ISO 8601)</param>
        /// <param name="endDate">End of the range (ISO 8601)</param>
        [HttpGet]
        public async Task<IActionResult> GetCalendarEvents([FromQuery] DateTime startDate, [FromQuery] DateTime endDate)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var events = await _calendarService.GetCalendarEventsAsync(userId, startDate, endDate);
                return Ok(events);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.InnerException?.Message ?? ex.Message);
            }
        }
    }
}
