using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class Post
    {
        public int Id { get; set; }

        public int DiscussionId { get; set; }

        public string UserId { get; set; }

        public string Content { get; set; }

        public ICollection<Comment> Comments { get; set; }
    }
}
