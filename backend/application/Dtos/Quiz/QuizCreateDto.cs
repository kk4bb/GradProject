using System;
using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Quiz
{
    public class QuizCreateDto
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime DueDate { get; set; }
    }
}
