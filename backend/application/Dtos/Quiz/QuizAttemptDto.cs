namespace CampusConnect.Application.Dtos.Quiz
{
    public class QuizAttemptDto
    {
        public int Id { get; set; }
        public int QuizId { get; set; }
        public string StudentId { get; set; }
        public string StudentName { get; set; }
        public string Title { get; set; }
        public double Score { get; set; }
        public string Status { get; set; }
        public string EssayAnswer { get; set; }
    }
}
