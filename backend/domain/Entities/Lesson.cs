using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class Lesson
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public int ModuleId { get; set; }

        public Module Module { get; set; }

        public ICollection<EducationalContent> Contents { get; set; }
    }
}
