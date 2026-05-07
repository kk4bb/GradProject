using CampusConnect.Application.Dtos.Course;
using CampusConnect.Application.Dtos.Student;
using CampusConnect.Application.Interfaces;
using CampusConnect.Domain.Entities;
using CampusConnect.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Services
{
    public class CourseService : ICourseService
    {
        private readonly ApplicationDbContext _context;

        public CourseService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<CourseSummaryDto>> GetAllEnrolledCoursesAsync(string studentId)
        {
            return await _context.Enrollments
                .Where(e => e.StudentId == studentId)
                .Select(e => new CourseSummaryDto
                {
                    Id = e.Course.Id,
                    Title = e.Course.Title,
                    Description = e.Course.Description,
                    InstructorName = _context.Users
                        .Where(u => u.Id == e.Course.InstructorId)
                        .Select(u => $"{u.FirstName} {u.LastName}")
                        .FirstOrDefault() ?? "Unknown"
                })
                .ToListAsync();
        }

        public async Task<CourseDetailDto> GetCourseDetailsAsync(int courseId, string userId)
        {
            // Permission Check: Must be enrolled student OR the instructor
            var isEnrolled = await _context.Enrollments
                .AnyAsync(e => e.CourseId == courseId && e.StudentId == userId);

            var course = await _context.Courses
                .FirstOrDefaultAsync(c => c.Id == courseId);

            if (course == null) return null;

            var isInstructor = course.InstructorId == userId;

            if (!isEnrolled && !isInstructor)
            {
                throw new UnauthorizedAccessException("You do not have access to this course.");
            }

            var instructor = await _context.Users
                .FirstOrDefaultAsync(u => u.Id == course.InstructorId);

            return new CourseDetailDto
            {
                Id = course.Id,
                Title = course.Title,
                Description = course.Description,
                InstructorName = instructor != null ? $"{instructor.FirstName} {instructor.LastName}" : "Unknown",
                Modules = await _context.Modules
                    .Where(m => m.CourseId == courseId)
                    .Select(m => new ModuleDto
                    {
                        Id = m.Id,
                        Title = m.Title,
                        Lessons = _context.Lessons
                            .Where(l => l.ModuleId == m.Id)
                            .Select(l => new LessonDto
                            {
                                Id = l.Id,
                                Title = l.Title,
                                Contents = _context.EducationalContents
                                    .Where(ec => ec.LessonId == l.Id)
                                    .Select(ec => new EducationalContentDto
                                    {
                                        Id = ec.Id,
                                        ContentType = ec.ContentType,
                                        FileUrl = ec.FileUrl
                                    }).ToList()
                            }).ToList()
                    }).ToListAsync()
            };
        }

        public async Task<List<CourseSummaryDto>> GetAssignedCoursesAsync(string instructorId)
        {
            // Check if user is TA
            var isTA = await _context.UserRoles
                .Join(_context.Roles, ur => ur.RoleId, r => r.Id, (ur, r) => new { ur.UserId, r.Name })
                .AnyAsync(x => x.UserId == instructorId && x.Name == "TA");

            if (isTA)
            {
                // For TAs, assigned courses are those they are enrolled in
                return await _context.Enrollments
                    .Where(e => e.StudentId == instructorId)
                    .Select(e => new CourseSummaryDto
                    {
                        Id = e.Course.Id,
                        Title = e.Course.Title,
                        Description = e.Course.Description,
                        InstructorName = _context.Users
                            .Where(u => u.Id == e.Course.InstructorId)
                            .Select(u => $"{u.FirstName} {u.LastName}")
                            .FirstOrDefault() ?? "Unknown"
                    })
                    .ToListAsync();
            }

            return await _context.Courses
                .Where(c => c.InstructorId == instructorId)
                .Select(c => new CourseSummaryDto
                {
                    Id = c.Id,
                    Title = c.Title,
                    Description = c.Description,
                    InstructorName = _context.Users
                        .Where(u => u.Id == c.InstructorId)
                        .Select(u => $"{u.FirstName} {u.LastName}")
                        .FirstOrDefault() ?? "Unknown"
                })
                .ToListAsync();
        }

        public async Task<List<StudentProfileDto>> GetEnrolledStudentsAsync(int courseId, string instructorId)
        {
            if (!await IsAuthorizedToManageCourseAsync(instructorId, courseId))
                throw new UnauthorizedAccessException("Not authorized to view this course's students.");

            return await _context.Enrollments
                .Where(e => e.CourseId == courseId)
                .Select(e => _context.Users
                    .Where(u => u.Id == e.StudentId)
                    .Select(u => new StudentProfileDto
                    {
                        Id = u.Id,
                        FirstName = u.FirstName,
                        LastName = u.LastName,
                        Email = u.Email,
                        Faculty = u.Faculty,
                        AcademicYear = 1, // Default or fetch if stored
                        CreditHours = 0,
                        EnrolledCoursesCount = 0
                    }).FirstOrDefault())
                .ToListAsync();
        }

        public async Task<int> CreateModuleAsync(int courseId, string title, string userId)
        {
            if (!await IsAuthorizedToManageCourseAsync(userId, courseId))
                throw new UnauthorizedAccessException("Not authorized to modify this course.");

            var module = new Module { CourseId = courseId, Title = title };
            _context.Modules.Add(module);
            await _context.SaveChangesAsync();
            return module.Id;
        }

        public async Task<int> AddLessonAsync(int moduleId, string title, string userId)
        {
            var module = await _context.Modules
                .Include(m => m.Course)
                .FirstOrDefaultAsync(m => m.Id == moduleId);

            if (module == null || !await IsAuthorizedToManageCourseAsync(userId, module.CourseId))
                throw new UnauthorizedAccessException("Not authorized to modify this course.");

            var lesson = new Lesson { ModuleId = moduleId, Title = title };
            _context.Lessons.Add(lesson);
            await _context.SaveChangesAsync();
            return lesson.Id;
        }

        public async Task<int> AddContentToLessonAsync(int lessonId, string type, string url, string userId)
        {
            var lesson = await _context.Lessons
                .Include(l => l.Module)
                .ThenInclude(m => m.Course)
                .FirstOrDefaultAsync(l => l.Id == lessonId);

            if (lesson == null || !await IsAuthorizedToManageCourseAsync(userId, lesson.Module.CourseId))
                throw new UnauthorizedAccessException("Not authorized to modify this course.");

            var content = new EducationalContent 
            { 
                LessonId = lessonId, 
                ContentType = type, 
                FileUrl = url 
            };
            _context.EducationalContents.Add(content);
            await _context.SaveChangesAsync();
            return content.Id;
        }

        private async Task<bool> IsAuthorizedToManageCourseAsync(string userId, int courseId)
        {
            var course = await _context.Courses.FindAsync(courseId);
            if (course == null) return false;

            if (course.InstructorId == userId) return true;

            // Check if user has TA role and is enrolled in the course
            var isTA = await _context.UserRoles
                .Join(_context.Roles, ur => ur.RoleId, r => r.Id, (ur, r) => new { ur.UserId, r.Name })
                .AnyAsync(x => x.UserId == userId && x.Name == "TA");

            var isEnrolled = await _context.Enrollments.AnyAsync(e => e.CourseId == courseId && e.StudentId == userId);

            return isTA && isEnrolled;
        }
    }
}
