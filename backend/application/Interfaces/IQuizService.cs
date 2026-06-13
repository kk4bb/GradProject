using CampusConnect.Application.Dtos.Quiz;
using System.Collections.Generic;
using System.Threading.Tasks;
using CampusConnect.Domain.Entities;
namespace CampusConnect.Application.Interfaces
{
    public interface IQuizService
    {
        Task<List<QuizDto>> GetQuizzesByCourseAsync(int courseId, string userId, bool isTA = false);
        Task<QuizTakeDto> GetQuizForTakingAsync(int quizId, string userId);
        Task<QuizResultDto> SubmitQuizAsync(int quizId, QuizSubmissionDto submission, string userId, bool requestBreakdown);
        Task UpdateQuestionImageAsync(int questionId, string imageUrl, string userId, bool isTA = false);
        Task<Quiz> CreateQuizAsync(CreateQuizDto createQuizDto, string userId, bool isTA = false);
        Task<bool> GradeEssayAsync(int quizId, int attemptId, double manualScore, string userId, bool isTA = false);
        Task<bool> PublishGradesAsync(int quizId, string userId, bool isTA = false);
        Task<bool> UpdateQuizAsync(int quizId, UpdateQuizDto dto, string instructorId, bool isTA = false);
        Task<List<CampusConnect.Application.Dtos.Quiz.QuizAttemptDto>> GetQuizAttemptsAsync(int quizId, string instructorId, bool isTA = false);
        Task<CampusConnect.Application.Dtos.Quiz.QuizAttemptDto> GetStudentQuizAttemptAsync(int quizId, string studentId);
    }
}
