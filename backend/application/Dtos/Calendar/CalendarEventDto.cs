using System;

namespace CampusConnect.Application.Dtos.Calendar
{
    public class CalendarEventDto
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public DateTime EventDate { get; set; }
        public string EventType { get; set; } = string.Empty; // "Assignment", "Quiz"
        public int CourseId { get; set; }
        public string CourseTitle { get; set; } = string.Empty;
    }
}
