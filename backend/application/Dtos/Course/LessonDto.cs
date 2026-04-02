using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Course
{
    public class LessonDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public List<EducationalContentDto> Contents { get; set; }
    }
}
