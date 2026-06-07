using System;
using System.Collections.Generic;

namespace CampusConnect.Domain.Entities
{
    public class Discussion
    {
        public int Id { get; set; }

        public int CourseId { get; set; }

        public string Title { get; set; }
        
        public string Content { get; set; }

        /// <summary>OPEN | CLOSED | RESOLVED</summary>
        public string Status { get; set; } = "OPEN";

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public ICollection<Post> Posts { get; set; }
    }
}
