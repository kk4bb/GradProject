using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Quiz
{
    public class QuestionDto
    {
        public int Id { get; set; }
        public string Text { get; set; }
        public string? ImageUrl { get; set; }
        public bool IsEssay { get; set; }
        public List<OptionDto> Options { get; set; }
    }
}
