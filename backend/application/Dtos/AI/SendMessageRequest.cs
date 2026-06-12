namespace CampusConnect.Application.Dtos.AI
{
    public class SendMessageRequest
    {
        public int? SessionId { get; set; }
        public int? CourseId { get; set; }
        public string Content { get; set; }
        public string? Base64Image { get; set; }
    }
}
