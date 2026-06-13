using System;
using CampusConnect.Domain.Enums;

namespace CampusConnect.Application.Dtos.Notification
{
    public class NotificationDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public NotificationType Type { get; set; }
        public string? ReferenceId { get; set; }
        public bool IsRead { get; set; }
        public DateTime CreatedAt { get; set; }
        public string? SenderName { get; set; }
        public string? CourseName { get; set; }
    }
}
