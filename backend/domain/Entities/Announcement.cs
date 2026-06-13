using System;
using CampusConnect.Domain.Enums;

namespace CampusConnect.Domain.Entities
{
    public class Announcement
    {
        public int Id { get; set; }
        public int CourseId { get; set; }
        public string AuthorId { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public string? TargetSection { get; set; }
        public NotificationPriority Priority { get; set; }
        public bool IsPinned { get; set; } = false;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Navigation properties
        public Course Course { get; set; }
        // Author navigation property can be added if needed, usually ApplicationUser
    }
}
