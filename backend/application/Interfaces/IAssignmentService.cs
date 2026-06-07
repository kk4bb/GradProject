using CampusConnect.Application.Dtos.Assignment;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IAssignmentService
    {
        // Student endpoints
        Task<List<AssignmentDto>> GetAssignmentsByCourseAsync(int courseId, string userId, bool isTA = false);
        Task<AssignmentDto> GetAssignmentDetailAsync(int assignmentId, string userId, bool isTA = false);
        Task<int> SubmitAssignmentAsync(int assignmentId, SubmissionSubmitDto submission, string userId);

        // Instructor/TA endpoints
        Task<int> CreateAssignmentAsync(int courseId, AssignmentCreateDto assignment, string userId, bool isTA = false);
        Task<List<SubmissionDto>> GetSubmissionsForAssignmentAsync(int assignmentId, string userId, bool isTA = false);
        Task<(bool Success, string StudentId)> GradeSubmissionAsync(int submissionId, SubmissionGradeDto grade, string userId, bool isTA = false);
    }
}
