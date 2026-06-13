using System;

namespace CampusConnect.Application.Dtos.Attendance
{
    public class MarkAttendanceRequest
    {
        public string QRCodeToken { get; set; }
        public string DeviceId { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
    }
}
