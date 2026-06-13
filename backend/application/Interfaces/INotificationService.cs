using System.Collections.Generic;
using System.Threading.Tasks;
using CampusConnect.Application.Dtos.Notification;

namespace CampusConnect.Application.Interfaces
{
    public interface INotificationService
    {
        Task<IEnumerable<NotificationDto>> GetUserNotificationsAsync(string userId);
        Task<bool> MarkAsReadAsync(int notificationId);
        Task<bool> MarkAllAsReadAsync(string userId);
        Task<NotificationDto> CreateNotificationAsync(NotificationCreateDto dto);
        Task<bool> DeleteNotificationAsync(int notificationId, string userId);
    }
}
