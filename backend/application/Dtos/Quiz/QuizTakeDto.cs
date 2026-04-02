using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Quiz
{
    public class QuizTakeDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public List<QuestionDto> Questions { get; set; }
    }
}
