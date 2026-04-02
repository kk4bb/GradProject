using CampusConnect.Application.Dtos.Dashboard;
using CampusConnect.Application.Dtos.Student;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IStudentService
    {
        Task<StudentDashboardDto> GetStudentDashboardAsync(string studentId);
        Task<StudentProfileDto> GetStudentProfileAsync(string studentId);
        Task<bool> IsInstructorForStudentAsync(string instructorId, string studentId);
    }
}
