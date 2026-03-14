using CampusConnect.Application.Dtos.Dashboard;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IStudentService
    {
        Task<StudentDashboardDto> GetStudentDashboardAsync(string studentId);
        Task<bool> IsInstructorForStudentAsync(string instructorId, string studentId);
    }
}
