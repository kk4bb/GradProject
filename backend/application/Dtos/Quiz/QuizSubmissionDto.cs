using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Quiz
{
    public class QuizSubmissionDto
    {
        public List<AnswerSubmissionDto> Answers { get; set; } = new List<AnswerSubmissionDto>();
    }

    public class AnswerSubmissionDto
    {
        public int QuestionId { get; set; }
        public int? SelectedOptionId { get; set; }
        public string? EssayAnswer { get; set; }
    }
}
