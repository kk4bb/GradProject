using System;
using System.Collections.Generic;

namespace CampusConnect.Domain.Entities
{
    public class AttendanceSession
    {
        public int Id { get; set; }

        public int CourseId { get; set; }

        public virtual Course Course { get; set; }

        public string SessionTitle { get; set; }

        public string QRCodeToken { get; set; }

        public DateTime CreatedAt { get; set; }

        public DateTime ExpiresAt { get; set; }

        public double? Latitude { get; set; }

        public double? Longitude { get; set; }

        public string InstructorId { get; set; }

        public virtual ICollection<AttendanceRecord> Records { get; set; } = new List<AttendanceRecord>();
    }
}
