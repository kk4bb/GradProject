using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Quiz
{
    public class QuizResultDto
    {
        public double Score { get; set; }
        public int TotalQuestions { get; set; }
        public int CorrectAnswersCount { get; set; }
        public string Status { get; set; }
        public List<QuestionResultDto>? Breakdown { get; set; }
    }

    public class QuestionResultDto
    {
        public int QuestionId { get; set; }
        public string QuestionText { get; set; }
        public string SelectedOptionText { get; set; }
        public string CorrectOptionText { get; set; }
        public bool IsCorrect { get; set; }
    }
}
