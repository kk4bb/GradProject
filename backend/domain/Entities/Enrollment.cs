using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class Enrollment
    {
        public int Id { get; set; }

        public string StudentId { get; set; }

        public int CourseId { get; set; }

        /// <summary>Optional section label, e.g. "Section 1", "TA", etc.</summary>
        public string? Section { get; set; }

        public Course Course { get; set; }
    }
}
