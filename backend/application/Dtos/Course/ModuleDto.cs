using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Course
{
    public class ModuleDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public List<LessonDto> Lessons { get; set; }
    }
}
