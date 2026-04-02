using System;

namespace CampusConnect.Application.Dtos.Assignment
{
    public class AssignmentCreateDto
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime DueDate { get; set; }
    }
}
