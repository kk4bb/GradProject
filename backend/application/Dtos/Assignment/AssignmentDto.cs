using System;

namespace CampusConnect.Application.Dtos.Assignment
{
    public class AssignmentDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime DueDate { get; set; }
        public bool IsSubmitted { get; set; }
    }
}
