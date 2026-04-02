namespace CampusConnect.Application.Dtos.Assignment
{
    public class SubmissionDto
    {
        public int Id { get; set; }
        public int AssignmentId { get; set; }
        public string StudentId { get; set; }
        public string FileUrl { get; set; }
        public double Grade { get; set; }
    }
}
