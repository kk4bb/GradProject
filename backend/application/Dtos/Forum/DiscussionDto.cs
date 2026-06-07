namespace CampusConnect.Application.Dtos.Forum
{
    public class DiscussionDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int PostCount { get; set; }
        public string Status { get; set; }
        public string CreatedAt { get; set; }
        public string AuthorName { get; set; }
        public string Content { get; set; }
    }
}
