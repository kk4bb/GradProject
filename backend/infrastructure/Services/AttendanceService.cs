using CampusConnect.Application.Dtos.Attendance;
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
    public class AttendanceService : IAttendanceService
    {
        private readonly ApplicationDbContext _context;
        private const double MaxDistanceMeters = 100.0; // Configurable

        public AttendanceService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<AttendanceSessionResponse> CreateSessionAsync(CreateAttendanceSessionRequest request, string instructorId)
        {
            var course = await _context.Courses.FindAsync(request.CourseId);
            if (course == null || course.InstructorId != instructorId)
            {
                throw new UnauthorizedAccessException("Not authorized to manage this course.");
            }

            var session = new AttendanceSession
            {
                CourseId = request.CourseId,
                SessionTitle = request.SessionTitle,
                QRCodeToken = Guid.NewGuid().ToString("N").Trim(), // Clean token, no whitespace
                CreatedAt = DateTime.UtcNow,
                ExpiresAt = DateTime.UtcNow.AddMinutes(request.DurationMinutes),
                Latitude = request.Latitude,
                Longitude = request.Longitude,
                InstructorId = instructorId
            };

            _context.AttendanceSessions.Add(session);
            await _context.SaveChangesAsync();

            return new AttendanceSessionResponse
            {
                SessionId = session.Id,
                SessionTitle = session.SessionTitle,
                QRCodeToken = session.QRCodeToken,
                ExpiresAt = session.ExpiresAt
            };
        }

        public async Task<bool> MarkAttendanceAsync(MarkAttendanceRequest request, string studentId)
        {
            // Trim + case-insensitive lookup to prevent any whitespace/case mismatch
            var incomingToken = (request.QRCodeToken ?? string.Empty).Trim();

            var session = await _context.AttendanceSessions
                .FirstOrDefaultAsync(s => s.QRCodeToken.Trim() == incomingToken);

            if (session == null)
            {
                throw new Exception($"Invalid QR code. No session found for token: '{incomingToken}'.");
            }

            // Use UTC for both sides
            if (DateTime.UtcNow > session.ExpiresAt.AddSeconds(10))
            {
                throw new Exception("Attendance session has expired. Please ask your instructor to refresh the QR code.");
            }

            // Check if student is enrolled in the course
            var isEnrolled = await _context.Enrollments
                .AnyAsync(e => e.CourseId == session.CourseId && e.StudentId == studentId);

            if (!isEnrolled)
            {
                throw new UnauthorizedAccessException("You are not enrolled in this course.");
            }

            // Geolocation verification
            if (session.Latitude.HasValue && session.Longitude.HasValue)
            {
                if (!request.Latitude.HasValue || !request.Longitude.HasValue)
                {
                    throw new Exception("Location data is required for this session.");
                }

                var distance = CalculateDistance(
                    session.Latitude.Value, session.Longitude.Value,
                    request.Latitude.Value, request.Longitude.Value);

                if (distance > MaxDistanceMeters)
                {
                    throw new Exception("You are too far from the classroom.");
                }
            }

            // Check if student already marked
            var existingRecord = await _context.AttendanceRecords
                .AnyAsync(r => r.AttendanceSessionId == session.Id && r.StudentId == studentId);

            if (existingRecord)
            {
                throw new Exception("You have already marked your attendance for this session.");
            }

            // Check if device ID already used
            var deviceUsed = await _context.AttendanceRecords
                .AnyAsync(r => r.AttendanceSessionId == session.Id && r.DeviceId == request.DeviceId);

            if (deviceUsed)
            {
                throw new Exception("This device has already been used to mark attendance for another student.");
            }

            var record = new AttendanceRecord
            {
                AttendanceSessionId = session.Id,
                StudentId = studentId,
                ScannedAt = DateTime.UtcNow,
                DeviceId = request.DeviceId,
                LatitudeAtScan = request.Latitude,
                LongitudeAtScan = request.Longitude
            };

            _context.AttendanceRecords.Add(record);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<IEnumerable<CourseAttendanceReportDto>> GetCourseAttendanceAsync(int courseId, string instructorId)
        {
            var course = await _context.Courses.FindAsync(courseId);
            if (course == null || course.InstructorId != instructorId)
            {
                throw new UnauthorizedAccessException("Not authorized to view this course's attendance.");
            }

            var sessions = await _context.AttendanceSessions
                .Where(s => s.CourseId == courseId)
                .Include(s => s.Records)
                .OrderByDescending(s => s.CreatedAt)
                .ToListAsync();

            var report = new List<CourseAttendanceReportDto>();

            foreach (var session in sessions)
            {
                var records = new List<AttendanceRecordDto>();
                var enrolledStudents = await _context.Enrollments
                    .Where(e => e.CourseId == courseId)
                    .Select(e => new { e.StudentId, Name = _context.Users.Where(u => u.Id == e.StudentId).Select(u => $"{u.FirstName} {u.LastName}").FirstOrDefault() })
                    .ToListAsync();

                foreach (var student in enrolledStudents)
                {
                    var record = session.Records.FirstOrDefault(r => r.StudentId == student.StudentId);
                    records.Add(new AttendanceRecordDto
                    {
                        StudentId = student.StudentId,
                        StudentName = student.Name,
                        ScannedAt = record?.ScannedAt ?? DateTime.MinValue,
                        IsPresent = record != null
                    });
                }

                report.Add(new CourseAttendanceReportDto
                {
                    SessionId = session.Id,
                    SessionTitle = session.SessionTitle,
                    CreatedAt = session.CreatedAt,
                    AttendanceRecords = records
                });
            }

            return report;
        }

        public async Task<IEnumerable<AttendanceRecordDto>> GetStudentAttendanceAsync(int courseId, string studentId)
        {
            var sessions = await _context.AttendanceSessions
                .Where(s => s.CourseId == courseId)
                .OrderByDescending(s => s.CreatedAt)
                .ToListAsync();

            var records = new List<AttendanceRecordDto>();

            foreach (var session in sessions)
            {
                var record = await _context.AttendanceRecords
                    .FirstOrDefaultAsync(r => r.AttendanceSessionId == session.Id && r.StudentId == studentId);

                records.Add(new AttendanceRecordDto
                {
                    StudentId = studentId,
                    StudentName = null, // Student already knows their name
                    ScannedAt = record?.ScannedAt ?? DateTime.MinValue,
                    IsPresent = record != null
                });
            }

            return records;
        }

        public async Task<bool> IsInstructorForCourseAsync(string instructorId, int courseId)
        {
            return await _context.Courses.AnyAsync(c => c.Id == courseId && c.InstructorId == instructorId);
        }

        public async Task<bool> RemoveAttendanceRecordAsync(int courseId, string studentId, string instructorId)
        {
            var isInstructor = await IsInstructorForCourseAsync(instructorId, courseId);
            if (!isInstructor)
            {
                throw new UnauthorizedAccessException("Not authorized to manage this course's attendance.");
            }

            // Find the most recent session for this course
            var latestSession = await _context.AttendanceSessions
                .Where(s => s.CourseId == courseId)
                .OrderByDescending(s => s.CreatedAt)
                .FirstOrDefaultAsync();

            if (latestSession == null)
            {
                throw new Exception("No attendance session found for this course.");
            }

            // Find the attendance record for the student in this session
            var record = await _context.AttendanceRecords
                .FirstOrDefaultAsync(r => r.AttendanceSessionId == latestSession.Id && r.StudentId == studentId);

            if (record != null)
            {
                _context.AttendanceRecords.Remove(record);
                await _context.SaveChangesAsync();
                return true;
            }

            return false;
        }

        private double CalculateDistance(double lat1, double lon1, double lat2, double lon2)
        {
            var R = 6371000; // Earth radius in meters
            var dLat = ToRadians(lat2 - lat1);
            var dLon = ToRadians(lon2 - lon1);
            var a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                    Math.Cos(ToRadians(lat1)) * Math.Cos(ToRadians(lat2)) *
                    Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
            var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
            return R * c;
        }

        private double ToRadians(double angle)
        {
            return Math.PI * angle / 180.0;
        }
    }
}
