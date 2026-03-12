using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class Discussion
    {
        public int Id { get; set; }

        public int CourseId { get; set; }

        public string Title { get; set; }

        public ICollection<Post> Posts { get; set; }
    }
}
