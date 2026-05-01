using CampusConnect.Application.Dtos.Course;
using CampusConnect.Application.Dtos.Student;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface ICourseService
    {
        // For Students
        Task<List<CourseSummaryDto>> GetAllEnrolledCoursesAsync(string studentId);
        Task<CourseDetailDto> GetCourseDetailsAsync(int courseId, string userId);

        // For Instructors
        Task<List<CourseSummaryDto>> GetAssignedCoursesAsync(string instructorId);
        Task<List<StudentProfileDto>> GetEnrolledStudentsAsync(int courseId, string instructorId);
        Task<int> CreateModuleAsync(int courseId, string title, string userId);
        Task<int> AddLessonAsync(int moduleId, string title, string userId);
        Task<int> AddContentToLessonAsync(int lessonId, string type, string url, string userId);
    }
}
