using System;

namespace CampusConnect.Domain.Entities
{
    public class ChatMessage
    {
        public int Id { get; set; }
        public int SessionId { get; set; }
        public ChatSession Session { get; set; }
        /// <summary>"User" or "AI"</summary>
        public string Sender { get; set; }
        public string Content { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
