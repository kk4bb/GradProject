using System.Collections.Generic;
using System.Threading.Tasks;
using CampusConnect.Application.Dtos.Grades;

namespace CampusConnect.Application.Interfaces
{
    public interface IGradeService
    {
        Task<GradeRecordDto> GetGradeRecordAsync(int courseId, string studentId);
        Task<List<GradeRecordDto>> GetCourseGradesAsync(int courseId);
        Task<GradeRecordDto> UpdateGradeRecordAsync(int courseId, string studentId, UpdateGradeDto dto, string userId, bool isTA);
        Task<bool> PublishTermWorkAsync(int courseId, string instructorId);
        Task<bool> UnlockTermWorkAsync(int courseId, string instructorId);
        Task AggregateStudentGradesAsync(int courseId, string studentId);
    }
}
