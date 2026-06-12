using System;

namespace CampusConnect.Application.Dtos.AI
{
    public class ChatMessageDto
    {
        public int Id { get; set; }
        public string Sender { get; set; }
        public string Content { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
