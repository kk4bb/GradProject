using CampusConnect.Domain.Entities;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface INotificationService
    {
        Task<IEnumerable<Notification>> GetUserNotificationsAsync(string userId);
        Task MarkAsReadAsync(int notificationId, string userId);
        Task MarkAllAsReadAsync(string userId);
        Task NotifyStudentsInCourseAsync(int courseId, string title, string message);
    }
}
