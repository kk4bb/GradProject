using CampusConnect.Application.Dtos.Course;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface ICourseService
    {
        // For Students
        Task<List<CourseSummaryDto>> GetAllEnrolledCoursesAsync(string studentId);
        Task<CourseDetailDto> GetCourseDetailsAsync(int courseId, string userId, bool isTA = false);

        // For Instructors and TAs
        Task<List<CourseSummaryDto>> GetAssignedCoursesAsync(string instructorId, bool isTA = false);
        Task<int> CreateModuleAsync(int courseId, string title, string userId, bool isTA = false);
        Task<int> AddLessonAsync(int moduleId, string title, string userId, bool isTA = false);
        Task<int> AddContentToLessonAsync(int lessonId, string type, string url, string userId, bool isTA = false);
    }
}
