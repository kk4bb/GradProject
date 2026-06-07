using System;
using System.Collections.Generic;

namespace CampusConnect.Domain.Entities
{
    public class Post
    {
        public int Id { get; set; }

        public int DiscussionId { get; set; }

        public Discussion Discussion { get; set; }

        public string UserId { get; set; }

        public string Content { get; set; }

        /// <summary>Set by Doctor/TA to mark this post as the accepted answer.</summary>
        public bool IsCorrect { get; set; } = false;

        /// <summary>Net upvotes on this post.</summary>
        public int Votes { get; set; } = 0;

        public string ApprovedByRole { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public ICollection<Comment> Comments { get; set; }
    }
}
