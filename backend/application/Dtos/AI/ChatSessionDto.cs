using System;

namespace CampusConnect.Application.Dtos.AI
{
    public class ChatSessionDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
