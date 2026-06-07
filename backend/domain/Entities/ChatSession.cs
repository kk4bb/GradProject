using System;
using System.Collections.Generic;

namespace CampusConnect.Domain.Entities
{
    public class ChatSession
    {
        public int Id { get; set; }
        public string StudentId { get; set; }
        public int? CourseId { get; set; }
        public Course? Course { get; set; }
        public string Title { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public ICollection<ChatMessage> Messages { get; set; }
    }
}
