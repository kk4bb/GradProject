using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class Quiz
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public int CourseId { get; set; }

        public Course Course { get; set; }

        public bool AreGradesPublished { get; set; } = false;
        public bool IsAutoGraded { get; set; } = true;
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int DurationMinutes { get; set; }

        public ICollection<Question> Questions { get; set; }
    }
}
