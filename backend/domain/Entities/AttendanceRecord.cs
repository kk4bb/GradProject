using System;

namespace CampusConnect.Domain.Entities
{
    public class AttendanceRecord
    {
        public int Id { get; set; }

        public int AttendanceSessionId { get; set; }

        public virtual AttendanceSession Session { get; set; }

        public string StudentId { get; set; }

        public DateTime ScannedAt { get; set; }

        public string DeviceId { get; set; }

        public double? LatitudeAtScan { get; set; }

        public double? LongitudeAtScan { get; set; }
    }
}
