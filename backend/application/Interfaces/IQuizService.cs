using CampusConnect.Application.Dtos.Quiz;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IQuizService
    {
        Task<List<QuizDto>> GetQuizzesByCourseAsync(int courseId, string userId);
        Task<QuizTakeDto> GetQuizForTakingAsync(int quizId, string userId);
        Task<QuizResultDto> SubmitQuizAsync(int quizId, QuizSubmissionDto submission, string userId, bool requestBreakdown);
        Task UpdateQuestionImageAsync(int questionId, string imageUrl, string userId);
    }
}
