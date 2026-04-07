using System;
using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Attendance
{
    public class AttendanceRecordDto
    {
        public string StudentId { get; set; }
        public string StudentName { get; set; }
        public DateTime ScannedAt { get; set; }
        public bool IsPresent { get; set; }
    }

    public class CourseAttendanceReportDto
    {
        public int SessionId { get; set; }
        public string SessionTitle { get; set; }
        public DateTime CreatedAt { get; set; }
        public List<AttendanceRecordDto> AttendanceRecords { get; set; }
    }
}
