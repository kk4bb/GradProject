namespace CampusConnect.Application.Dtos.Quiz
{
    public class QuizDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int QuestionCount { get; set; }
        public System.DateTime StartDate { get; set; }
        public System.DateTime EndDate { get; set; }
        public int DurationMinutes { get; set; }
        public bool IsAutoGraded { get; set; }
        public bool AreGradesPublished { get; set; }
        public bool HasAttempted { get; set; }
        public double TotalMarks { get; set; }
        public string Description { get; set; }
        public int CourseId { get; set; }
    }
}
