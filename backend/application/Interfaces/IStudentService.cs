using CampusConnect.Application.Dtos.Dashboard;
using CampusConnect.Application.Dtos.Student;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IStudentService
    {
        Task<StudentDashboardDto> GetStudentDashboardAsync(string studentId);
        Task<StudentProfileDto> GetStudentProfileAsync(string studentId);
        Task<string> UploadProfilePictureAsync(string userId, Microsoft.AspNetCore.Http.IFormFile file);
        Task<bool> IsInstructorForStudentAsync(string instructorId, string studentId);
    }
}
