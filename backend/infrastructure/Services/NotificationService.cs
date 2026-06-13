using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CampusConnect.Application.Dtos.Notification;
using CampusConnect.Application.Interfaces;
using CampusConnect.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.SignalR;
using CampusConnect.Infrastructure.Hubs;
using CampusConnect.Domain.Entities;
using System;

namespace CampusConnect.Infrastructure.Services
{
    public class NotificationService : INotificationService
    {
        private readonly ApplicationDbContext _context;
        private readonly IHubContext<NotificationHub> _hubContext;

        public NotificationService(ApplicationDbContext context, IHubContext<NotificationHub> hubContext)
        {
            _context = context;
            _hubContext = hubContext;
        }

        public async Task<IEnumerable<NotificationDto>> GetUserNotificationsAsync(string userId)
        {
            var notifications = await _context.Notifications
                .Where(n => n.UserId == userId)
                .OrderByDescending(n => n.CreatedAt)
                .ToListAsync();

            var dtos = new List<NotificationDto>();
            foreach (var n in notifications)
            {
                var dto = new NotificationDto
                {
                    Id = n.Id,
                    Title = n.Title,
                    Message = n.Message,
                    Type = n.Type,
                    ReferenceId = n.ReferenceId,
                    IsRead = n.IsRead,
                    CreatedAt = n.CreatedAt
                };

                if (n.Type == Domain.Enums.NotificationType.Announcement && int.TryParse(n.ReferenceId, out int annId))
                {
                    var ann = await _context.Announcements.Include(a => a.Course).FirstOrDefaultAsync(a => a.Id == annId);
                    if (ann != null)
                    {
                        var instructor = await _context.Users.FindAsync(ann.AuthorId);
                        dto.SenderName = instructor != null ? $"{instructor.FirstName} {instructor.LastName}" : null;
                        dto.CourseName = ann.Course?.Title;
                    }
                }
                dtos.Add(dto);
            }
            return dtos;
        }

        public async Task<bool> MarkAsReadAsync(int notificationId)
        {
            var notification = await _context.Notifications.FindAsync(notificationId);
            if (notification == null) return false;

            notification.IsRead = true;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> MarkAllAsReadAsync(string userId)
        {
            var unreadNotifications = await _context.Notifications
                .Where(n => n.UserId == userId && !n.IsRead)
                .ToListAsync();

            if (!unreadNotifications.Any()) return true;

            foreach (var notification in unreadNotifications)
            {
                notification.IsRead = true;
            }

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<NotificationDto> CreateNotificationAsync(NotificationCreateDto dto)
        {
            var notification = new Notification
            {
                UserId = dto.UserId,
                Title = dto.Title,
                Message = dto.Message,
                Type = dto.Type,
                ReferenceId = dto.ReferenceId,
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            };

            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();

            var notificationDto = new NotificationDto
            {
                Id = notification.Id,
                Title = notification.Title,
                Message = notification.Message,
                Type = notification.Type,
                ReferenceId = notification.ReferenceId,
                IsRead = notification.IsRead,
                CreatedAt = notification.CreatedAt
            };

            // Broadcast to the specific user
            await _hubContext.Clients.Group($"User_{dto.UserId}").SendAsync("ReceiveNotification", notificationDto);

            return notificationDto;
        }

        public async Task<bool> DeleteNotificationAsync(int notificationId, string userId)
        {
            var notification = await _context.Notifications.FindAsync(notificationId);
            if (notification == null) return false;

            if (notification.UserId != userId) return false; // Security check

            _context.Notifications.Remove(notification);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
