namespace CampusConnect.Application.Dtos.Attendance
{
    public class RemoveAttendanceRecordRequest
    {
        public int CourseId { get; set; }
        public string StudentId { get; set; }
    }
}
