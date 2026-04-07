using System;

namespace CampusConnect.Application.Dtos.Attendance
{
    public class AttendanceSessionResponse
    {
        public int SessionId { get; set; }
        public string SessionTitle { get; set; }
        public string QRCodeToken { get; set; }
        public DateTime ExpiresAt { get; set; }
    }
}
