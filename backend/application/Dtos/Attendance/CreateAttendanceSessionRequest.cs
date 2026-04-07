using System;

namespace CampusConnect.Application.Dtos.Attendance
{
    public class CreateAttendanceSessionRequest
    {
        public int CourseId { get; set; }
        public string SessionTitle { get; set; }
        public int DurationMinutes { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
    }
}
