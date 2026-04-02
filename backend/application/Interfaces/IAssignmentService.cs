using CampusConnect.Application.Dtos.Assignment;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IAssignmentService
    {
        // Student endpoints
        Task<List<AssignmentDto>> GetAssignmentsByCourseAsync(int courseId, string userId);
        Task<AssignmentDto> GetAssignmentDetailAsync(int assignmentId, string userId);
        Task<int> SubmitAssignmentAsync(int assignmentId, SubmissionSubmitDto submission, string userId);

        // Instructor endpoints
        Task<int> CreateAssignmentAsync(int courseId, AssignmentCreateDto assignment, string userId);
        Task<List<SubmissionDto>> GetSubmissionsForAssignmentAsync(int assignmentId, string userId);
        Task<bool> GradeSubmissionAsync(int submissionId, SubmissionGradeDto grade, string userId);
    }
}
