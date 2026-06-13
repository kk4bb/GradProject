using System.ComponentModel.DataAnnotations;
using CampusConnect.Domain.Enums;

namespace CampusConnect.Application.Dtos.Announcement
{
    public class AnnouncementCreateDto
    {
        [Required]
        public int CourseId { get; set; }

        [Required]
        public string Title { get; set; }

        [Required]
        public string Content { get; set; }

        public string? TargetSection { get; set; }

        public NotificationPriority Priority { get; set; } = NotificationPriority.Normal;

        public bool IsPinned { get; set; } = false;
    }
}
