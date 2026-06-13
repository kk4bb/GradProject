using CampusConnect.Domain.Enums;

namespace CampusConnect.Application.Dtos.Notification
{
    public class NotificationCreateDto
    {
        public string UserId { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
        public NotificationType Type { get; set; }
        public string? ReferenceId { get; set; }
    }
}
