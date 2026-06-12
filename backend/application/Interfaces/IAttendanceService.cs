using CampusConnect.Application.Dtos.Attendance;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IAttendanceService
    {
        Task<AttendanceSessionResponse> CreateSessionAsync(CreateAttendanceSessionRequest request, string userId, bool isTA);
        
        Task<bool> MarkAttendanceAsync(MarkAttendanceRequest request, string studentId);
        
        Task<IEnumerable<CourseAttendanceReportDto>> GetCourseAttendanceAsync(int courseId, string instructorId);
        
        Task<IEnumerable<AttendanceRecordDto>> GetStudentAttendanceAsync(int courseId, string studentId);

        Task<bool> IsInstructorForCourseAsync(string instructorId, int courseId);

        Task<bool> RemoveAttendanceRecordAsync(int courseId, string studentId, string userId);

        Task<bool> MockScanAsync(int courseId);
    }
}
