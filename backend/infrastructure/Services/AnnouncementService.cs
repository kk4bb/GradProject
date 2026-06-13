using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CampusConnect.Application.Dtos.Announcement;
using CampusConnect.Application.Interfaces;
using CampusConnect.Domain.Entities;
using CampusConnect.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.SignalR;
using CampusConnect.Infrastructure.Hubs;
using CampusConnect.Domain.Enums;

namespace CampusConnect.Infrastructure.Services
{
    public class AnnouncementService : IAnnouncementService
    {
        private readonly ApplicationDbContext _context;
        private readonly IHubContext<NotificationHub> _hubContext;

        public AnnouncementService(ApplicationDbContext context, IHubContext<NotificationHub> hubContext)
        {
            _context = context;
            _hubContext = hubContext;
        }

        public async Task<AnnouncementDto> CreateAnnouncementAsync(string authorId, AnnouncementCreateDto dto)
        {
            var announcement = new Announcement
            {
                CourseId = dto.CourseId,
                AuthorId = authorId,
                Title = dto.Title,
                Content = dto.Content,
                TargetSection = dto.TargetSection,
                Priority = dto.Priority,
                IsPinned = dto.IsPinned,
                CreatedAt = DateTime.UtcNow
            };

            _context.Announcements.Add(announcement);
            await _context.SaveChangesAsync();

            var targetUserIds = await GetTargetUserIdsAsync(dto.CourseId, dto.TargetSection);


            var notifications = targetUserIds.Select(userId => new Notification
            {
                UserId = userId,
                Title = dto.Title,
                Message = dto.Content,
                Type = NotificationType.Announcement,
                ReferenceId = announcement.Id.ToString(),
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            }).ToList();

            if (notifications.Any())
            {
                _context.Notifications.AddRange(notifications);
                await _context.SaveChangesAsync();
            }

            var announcementDto = new AnnouncementDto
            {
                Id = announcement.Id,
                CourseId = announcement.CourseId,
                AuthorId = announcement.AuthorId,
                Title = announcement.Title,
                Content = announcement.Content,
                TargetSection = announcement.TargetSection,
                Priority = announcement.Priority,
                IsPinned = announcement.IsPinned,
                CreatedAt = announcement.CreatedAt
            };

            // Broadcast to each target user's personal SignalR group
            foreach (var userId in targetUserIds)
            {
                await _hubContext.Clients.Group($"User_{userId}")
                    .SendAsync("ReceiveNotification", announcementDto);
            }

            return announcementDto;
        }

        public async Task<IEnumerable<AnnouncementDto>> GetCourseAnnouncementsAsync(int courseId)
        {
            return await _context.Announcements
                .Where(a => a.CourseId == courseId)
                .OrderByDescending(a => a.IsPinned)
                .ThenByDescending(a => a.CreatedAt)
                .Select(a => new AnnouncementDto
                {
                    Id = a.Id,
                    CourseId = a.CourseId,
                    AuthorId = a.AuthorId,
                    Title = a.Title,
                    Content = a.Content,
                    TargetSection = a.TargetSection,
                    Priority = a.Priority,
                    IsPinned = a.IsPinned,
                    CreatedAt = a.CreatedAt
                })
                .ToListAsync();
        }

        public async Task<IEnumerable<AnnouncementDto>> GetManageCourseAnnouncementsAsync(int courseId, string authorId)
        {
            return await _context.Announcements
                .Where(a => a.CourseId == courseId && a.AuthorId == authorId)
                .OrderByDescending(a => a.CreatedAt)
                .Select(a => new AnnouncementDto
                {
                    Id = a.Id,
                    CourseId = a.CourseId,
                    AuthorId = a.AuthorId,
                    Title = a.Title,
                    Content = a.Content,
                    TargetSection = a.TargetSection,
                    Priority = a.Priority,
                    IsPinned = a.IsPinned,
                    CreatedAt = a.CreatedAt
                })
                .ToListAsync();
        }

        public async Task<AnnouncementDto> UpdateAnnouncementAsync(int id, string authorId, AnnouncementUpdateDto dto)
        {
            var announcement = await _context.Announcements.FindAsync(id);
            if (announcement == null) return null;

            // Update properties
            announcement.Title = dto.Title;
            announcement.Content = dto.Content;
            announcement.TargetSection = dto.TargetSection;
            announcement.Priority = dto.Priority;
            announcement.IsPinned = dto.IsPinned;

            // Find existing notifications
            var existingNotifications = await _context.Notifications
                .Where(n => n.Type == NotificationType.Announcement && n.ReferenceId == id.ToString())
                .ToListAsync();

            // Calculate new target user ids
            var newTargetUserIds = await GetTargetUserIdsAsync(announcement.CourseId, dto.TargetSection);

            var existingUserIds = existingNotifications.Select(n => n.UserId).ToList();

            // Remove notifications for users who are no longer targeted
            var toRemove = existingNotifications.Where(n => !newTargetUserIds.Contains(n.UserId)).ToList();
            if (toRemove.Any())
            {
                _context.Notifications.RemoveRange(toRemove);
                foreach (var n in toRemove)
                {
                    // Broadcast delete so it disappears from their feed
                    await _hubContext.Clients.Group($"User_{n.UserId}").SendAsync("AnnouncementDeleted", id);
                }
            }

            // Add notifications for newly targeted users
            var toAddUserIds = newTargetUserIds.Except(existingUserIds).ToList();
            var newNotifications = toAddUserIds.Select(userId => new Notification
            {
                UserId = userId,
                Title = dto.Title,
                Message = dto.Content,
                Type = NotificationType.Announcement,
                ReferenceId = announcement.Id.ToString(),
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            }).ToList();

            if (newNotifications.Any())
            {
                _context.Notifications.AddRange(newNotifications);
            }

            // Update remaining existing notifications
            var toUpdate = existingNotifications.Where(n => newTargetUserIds.Contains(n.UserId)).ToList();
            foreach (var n in toUpdate)
            {
                n.Title = dto.Title;
                n.Message = dto.Content;
                n.IsRead = false; // Optionally mark unread again
            }

            await _context.SaveChangesAsync();

            var announcementDto = new AnnouncementDto
            {
                Id = announcement.Id,
                CourseId = announcement.CourseId,
                AuthorId = announcement.AuthorId,
                Title = announcement.Title,
                Content = announcement.Content,
                TargetSection = announcement.TargetSection,
                Priority = announcement.Priority,
                IsPinned = announcement.IsPinned,
                CreatedAt = announcement.CreatedAt
            };

            // Broadcast update
            foreach (var userId in newTargetUserIds)
            {
                // If it's a completely new user, we could send ReceiveNotification instead, 
                // but AnnouncementUpdated with the full DTO works if the frontend handles it well.
                await _hubContext.Clients.Group($"User_{userId}").SendAsync("AnnouncementUpdated", announcementDto);
            }

            return announcementDto;
        }

        public async Task<bool> DeleteAnnouncementAsync(int id, string authorId)
        {
            var announcement = await _context.Announcements.FindAsync(id);
            if (announcement == null) return false;

            var existingNotifications = await _context.Notifications
                .Where(n => n.Type == NotificationType.Announcement && n.ReferenceId == id.ToString())
                .ToListAsync();

            if (existingNotifications.Any())
            {
                _context.Notifications.RemoveRange(existingNotifications);
            }

            _context.Announcements.Remove(announcement);
            await _context.SaveChangesAsync();

            // Broadcast delete
            var userIds = existingNotifications.Select(n => n.UserId).ToList();
            foreach (var userId in userIds)
            {
                await _hubContext.Clients.Group($"User_{userId}").SendAsync("AnnouncementDeleted", id);
            }

            return true;
        }

        private async Task<List<string>> GetTargetUserIdsAsync(int courseId, string targetSection)
        {
            if (!string.IsNullOrWhiteSpace(targetSection) &&
                (targetSection.Equals("Instructor", StringComparison.OrdinalIgnoreCase) || 
                 targetSection.Equals("Doctor", StringComparison.OrdinalIgnoreCase)))
            {
                var course = await _context.Courses.FindAsync(courseId);
                if (course != null && !string.IsNullOrEmpty(course.InstructorId))
                {
                    return new List<string> { course.InstructorId };
                }
                return new List<string>();
            }
            else if (!string.IsNullOrWhiteSpace(targetSection) &&
                targetSection.Equals("TA", StringComparison.OrdinalIgnoreCase))
            {
                return await _context.Enrollments
                    .Where(e => e.CourseId == courseId
                             && e.Section != null
                             && e.Section.ToUpper() == "TA")
                    .Select(e => e.StudentId)
                    .ToListAsync();
            }
            else if (!string.IsNullOrWhiteSpace(targetSection))
            {
                return await _context.Enrollments
                    .Where(e => e.CourseId == courseId
                             && e.Section != null
                             && e.Section == targetSection)
                    .Select(e => e.StudentId)
                    .ToListAsync();
            }
            else
            {
                return await _context.Enrollments
                    .Where(e => e.CourseId == courseId
                             && (e.Section == null || !e.Section.ToUpper().Equals("TA")))
                    .Select(e => e.StudentId)
                    .ToListAsync();
            }
        }
    }
}
