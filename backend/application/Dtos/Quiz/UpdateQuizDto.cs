namespace CampusConnect.Application.Dtos.Quiz
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public class UpdateQuizDto
    {
        [Required]
        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        [Required]
        public DateTime StartDate { get; set; }

        [Required]
        public DateTime EndDate { get; set; }

        [Required]
        public int DurationMinutes { get; set; }

        public bool IsAutoGraded { get; set; }
    }
}
