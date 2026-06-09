using CampusConnect.Application.Dtos.Calendar;
using CampusConnect.Application.Interfaces;
using CampusConnect.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Services
{
    public class CalendarService : ICalendarService
    {
        private readonly ApplicationDbContext _context;

        public CalendarService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<CalendarEventDto>> GetCalendarEventsAsync(string userId, DateTime startDate, DateTime endDate)
        {
            // Get all course IDs this user is associated with (enrolled as student OR primary instructor)
            var enrolledCourseIds = await _context.Enrollments
                .Where(e => e.StudentId == userId)
                .Select(e => e.CourseId)
                .ToListAsync();

            var instructingCourseIds = await _context.Courses
                .Where(c => c.InstructorId == userId)
                .Select(c => c.Id)
                .ToListAsync();

            var allCourseIds = enrolledCourseIds.Union(instructingCourseIds).Distinct().ToList();

            // Fetch Assignments due between startDate and endDate
            var assignmentEvents = await _context.Assignments
                .Include(a => a.Course)
                .Where(a => allCourseIds.Contains(a.CourseId)
                         && a.DueDate >= startDate
                         && a.DueDate <= endDate)
                .Select(a => new CalendarEventDto
                {
                    Id = a.Id,
                    Title = a.Title,
                    Description = a.Description ?? string.Empty,
                    EventDate = a.DueDate,
                    EventType = "Assignment",
                    CourseId = a.CourseId,
                    CourseTitle = a.Course.Title ?? string.Empty
                })
                .ToListAsync();

            // Fetch Quizzes for the user's courses
            // Quiz entity has no date field — return all quizzes for user's courses as calendar awareness items
            var quizEvents = await _context.Quizzes
                .Include(q => q.Course)
                .Where(q => allCourseIds.Contains(q.CourseId))
                .Select(q => new CalendarEventDto
                {
                    Id = q.Id,
                    Title = q.Title,
                    Description = string.Empty,
                    EventDate = q.StartDate, // Use the actual Quiz StartDate
                    EventType = "Quiz",
                    CourseId = q.CourseId,
                    CourseTitle = q.Course.Title ?? string.Empty
                })
                .ToListAsync();

            // Combine, order by date, and return
            var allEvents = assignmentEvents
                .Concat(quizEvents)
                .OrderBy(e => e.EventDate)
                .ToList();

            return allEvents;
        }
    }
}
