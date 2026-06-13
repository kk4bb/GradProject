using System;
using CampusConnect.Domain.Enums;

namespace CampusConnect.Application.Dtos.Announcement
{
    public class AnnouncementDto
    {
        public int Id { get; set; }
        public int CourseId { get; set; }
        public string AuthorId { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public string? TargetSection { get; set; }
        public NotificationPriority Priority { get; set; }
        public bool IsPinned { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
