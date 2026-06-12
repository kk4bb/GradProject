using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class EducationalContent
    {
        public int Id { get; set; }

        public int LessonId { get; set; }

        public Lesson Lesson { get; set; }

        public string ContentType { get; set; }

        public string FileUrl { get; set; }
    }
}
