using System;
using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Quiz
{
    public class CreateQuizDto
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public int CourseId { get; set; }
        public int DurationMinutes { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool IsAutoGraded { get; set; }
        public bool AllowMultipleAttempts { get; set; }
        public List<QuestionDto>? Questions { get; set; }
    }
}
