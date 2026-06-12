using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Course
{
    public class CourseDetailDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string InstructorName { get; set; }
        public List<ModuleDto> Modules { get; set; }
    }
}
