using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class Submission
    {
        public int Id { get; set; }

        public int AssignmentId { get; set; }

        public Assignment Assignment { get; set; }

        public string StudentId { get; set; }

        public string FileUrl { get; set; }

        public double Grade { get; set; }
    }
}
