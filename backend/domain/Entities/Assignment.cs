using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class Assignment
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public DateTime DueDate { get; set; }
        public double Points { get; set; }
        public string? FileUrl { get; set; }

        public int CourseId { get; set; }

        public Course Course { get; set; }

        public ICollection<Submission> Submissions { get; set; }
    }
}
