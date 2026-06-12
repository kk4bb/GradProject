using System;

namespace CampusConnect.Application.Dtos.Assignment
{
    public class AssignmentCreateDto
    {
        public int CourseId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime DueDate { get; set; }
        public double Points { get; set; }
    }
}
