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
        public List<CourseStudentDto> Students { get; set; } = new List<CourseStudentDto>();
    }

    public class CourseStudentDto
    {
        public string Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string? ProfilePictureUrl { get; set; }
    }
}
