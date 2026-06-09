using CampusConnect.Application.Dtos.Quiz;
using System.Collections.Generic;
using System.Threading.Tasks;
using CampusConnect.Domain.Entities;
namespace CampusConnect.Application.Interfaces
{
    public interface IQuizService
    {
        Task<List<QuizDto>> GetQuizzesByCourseAsync(int courseId, string userId);
        Task<QuizTakeDto> GetQuizForTakingAsync(int quizId, string userId);
        Task<QuizResultDto> SubmitQuizAsync(int quizId, QuizSubmissionDto submission, string userId, bool requestBreakdown);
        Task UpdateQuestionImageAsync(int questionId, string imageUrl, string userId);
        Task<Quiz> CreateQuizAsync(CreateQuizDto createQuizDto, string userId);
        Task<bool> GradeEssayAsync(int quizId, int attemptId, double manualScore, string userId);
        Task<bool> PublishGradesAsync(int quizId, string userId);
        Task<bool> UpdateQuizAsync(int quizId, UpdateQuizDto dto, string instructorId);
        Task<List<CampusConnect.Application.Dtos.Quiz.QuizAttemptDto>> GetQuizAttemptsAsync(int quizId, string instructorId);
        Task<CampusConnect.Application.Dtos.Quiz.QuizAttemptDto> GetStudentQuizAttemptAsync(int quizId, string studentId);
    }
}
