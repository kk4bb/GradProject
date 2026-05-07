using CampusConnect.Application.Dtos.Attendance;
using CampusConnect.Domain.Entities;
using CampusConnect.Infrastructure.Context;
using CampusConnect.Infrastructure.Services;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;

namespace CampusConnect.Tests.App
{
    public class AttendanceServiceTests
    {
        private ApplicationDbContext GetDbContext()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;
            return new ApplicationDbContext(options);
        }

        [Fact]
        public async Task CreateSessionAsync_ValidRequest_CreatesSession()
        {
            // Arrange
            var context = GetDbContext();
            var instructorId = "instructor-1";
            var course = new Course { Id = 1, InstructorId = instructorId, Title = "CS101", Description = "Test" };
            context.Courses.Add(course);
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);
            var request = new CreateAttendanceSessionRequest
            {
                CourseId = 1,
                SessionTitle = "Morning Lecture",
                DurationMinutes = 60,
                Latitude = 30.0,
                Longitude = 31.0
            };

            // Act
            var response = await service.CreateSessionAsync(request, instructorId);

            // Assert
            response.Should().NotBeNull();
            response.SessionTitle.Should().Be("Morning Lecture");
            response.QRCodeToken.Should().NotBeNullOrEmpty();
            context.AttendanceSessions.Count().Should().Be(1);
        }

        [Fact]
        public async Task CreateSessionAsync_NotInstructor_ThrowsUnauthorized()
        {
            // Arrange
            var context = GetDbContext();
            var instructorId = "instructor-1";
            var course = new Course { Id = 1, InstructorId = instructorId, Title = "CS101", Description = "Test" };
            context.Courses.Add(course);
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);
            var request = new CreateAttendanceSessionRequest { CourseId = 1 };

            // Act & Assert
            await Assert.ThrowsAsync<UnauthorizedAccessException>(() => 
                service.CreateSessionAsync(request, "wrong-instructor"));
        }

        [Fact]
        public async Task CreateSessionAsync_TA_Enrolled_Succeeds()
        {
            // Arrange
            var context = GetDbContext();
            var taId = "ta-1";
            var courseId = 1;
            
            var course = new Course { Id = courseId, InstructorId = "instructor-1", Title = "CS101", Description = "Test" };
            context.Courses.Add(course);
            
            // Add TA role
            var taRole = new IdentityRole { Id = "role-ta", Name = "TA", NormalizedName = "TA" };
            context.Roles.Add(taRole);
            context.UserRoles.Add(new IdentityUserRole<string> { UserId = taId, RoleId = "role-ta" });
            
            // Enroll TA
            context.Enrollments.Add(new Enrollment { StudentId = taId, CourseId = courseId });
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);
            var request = new CreateAttendanceSessionRequest
            {
                CourseId = courseId,
                SessionTitle = "TA Session",
                DurationMinutes = 30
            };

            // Act
            var response = await service.CreateSessionAsync(request, taId);

            // Assert
            response.Should().NotBeNull();
            response.SessionTitle.Should().Be("TA Session");
        }

        [Fact]
        public async Task MarkAttendanceAsync_ValidRequest_MarksAttendance()
        {
            // Arrange
            var context = GetDbContext();
            var studentId = "student-1";
            var courseId = 1;
            
            context.Courses.Add(new Course { Id = courseId, InstructorId = "inst-1", Title = "CS101", Description = "Test" });
            context.Enrollments.Add(new Enrollment { CourseId = courseId, StudentId = studentId });
            
            var session = new AttendanceSession
            {
                Id = 1,
                CourseId = courseId,
                SessionTitle = "Morning Lecture",
                InstructorId = "inst-1",
                QRCodeToken = "valid-token",
                ExpiresAt = DateTime.UtcNow.AddMinutes(10),
                Latitude = 30.0,
                Longitude = 31.0
            };
            context.AttendanceSessions.Add(session);
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);
            var request = new MarkAttendanceRequest
            {
                QRCodeToken = "valid-token",
                Latitude = 30.0001, // Very close
                Longitude = 31.0001,
                DeviceId = "device-1"
            };

            // Act
            var result = await service.MarkAttendanceAsync(request, studentId);

            // Assert
            result.Should().BeTrue();
            context.AttendanceRecords.Count().Should().Be(1);
            context.AttendanceRecords.First().StudentId.Should().Be(studentId);
        }

        [Fact]
        public async Task MarkAttendanceAsync_InvalidToken_ThrowsException()
        {
            // Arrange
            var context = GetDbContext();
            var service = new AttendanceService(context);
            var request = new MarkAttendanceRequest { QRCodeToken = "invalid-token" };

            // Act & Assert
            var ex = await Assert.ThrowsAsync<Exception>(() => service.MarkAttendanceAsync(request, "student-1"));
            ex.Message.Should().Be("Invalid QR code.");
        }

        [Fact]
        public async Task MarkAttendanceAsync_ExpiredSession_ThrowsException()
        {
            // Arrange
            var context = GetDbContext();
            var session = new AttendanceSession
            {
                CourseId = 1,
                SessionTitle = "Test Session",
                InstructorId = "inst-1",
                QRCodeToken = "expired-token",
                ExpiresAt = DateTime.UtcNow.AddMinutes(-10)
            };
            context.AttendanceSessions.Add(session);
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);
            var request = new MarkAttendanceRequest { QRCodeToken = "expired-token" };

            // Act & Assert
            var ex = await Assert.ThrowsAsync<Exception>(() => service.MarkAttendanceAsync(request, "student-1"));
            ex.Message.Should().Be("Attendance session has expired.");
        }

        [Fact]
        public async Task MarkAttendanceAsync_NotEnrolled_ThrowsUnauthorized()
        {
            // Arrange
            var context = GetDbContext();
            var session = new AttendanceSession
            {
                CourseId = 1,
                SessionTitle = "Test Session",
                InstructorId = "inst-1",
                QRCodeToken = "token",
                ExpiresAt = DateTime.UtcNow.AddMinutes(10)
            };
            context.AttendanceSessions.Add(session);
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);
            var request = new MarkAttendanceRequest { QRCodeToken = "token" };

            // Act & Assert
            await Assert.ThrowsAsync<UnauthorizedAccessException>(() => service.MarkAttendanceAsync(request, "not-enrolled-student"));
        }

        [Fact]
        public async Task MarkAttendanceAsync_TooFar_ThrowsException()
        {
            // Arrange
            var context = GetDbContext();
            var studentId = "student-1";
            var courseId = 1;
            
            context.Enrollments.Add(new Enrollment { CourseId = courseId, StudentId = studentId });
            var session = new AttendanceSession
            {
                CourseId = courseId,
                SessionTitle = "Morning Lecture",
                InstructorId = "inst-1",
                QRCodeToken = "token",
                ExpiresAt = DateTime.UtcNow.AddMinutes(10),
                Latitude = 30.0,
                Longitude = 31.0
            };
            context.AttendanceSessions.Add(session);
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);
            var request = new MarkAttendanceRequest
            {
                QRCodeToken = "token",
                Latitude = 32.0, // Far away
                Longitude = 33.0,
                DeviceId = "device-1"
            };

            // Act & Assert
            var ex = await Assert.ThrowsAsync<Exception>(() => service.MarkAttendanceAsync(request, studentId));
            ex.Message.Should().Be("You are too far from the classroom.");
        }

        [Fact]
        public async Task MarkAttendanceAsync_MissingLocation_ThrowsException()
        {
            // Arrange
            var context = GetDbContext();
            var studentId = "student-1";
            var courseId = 1;
            
            context.Enrollments.Add(new Enrollment { CourseId = courseId, StudentId = studentId });
            var session = new AttendanceSession
            {
                CourseId = courseId,
                SessionTitle = "Morning Lecture",
                InstructorId = "inst-1",
                QRCodeToken = "token",
                ExpiresAt = DateTime.UtcNow.AddMinutes(10),
                Latitude = 30.0,
                Longitude = 31.0
            };
            context.AttendanceSessions.Add(session);
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);
            var request = new MarkAttendanceRequest
            {
                QRCodeToken = "token",
                DeviceId = "device-1"
                // Latitude and Longitude are null
            };

            // Act & Assert
            var ex = await Assert.ThrowsAsync<Exception>(() => service.MarkAttendanceAsync(request, studentId));
            ex.Message.Should().Be("Location data is required for this session.");
        }

        [Fact]
        public async Task MarkAttendanceAsync_AlreadyMarked_ThrowsException()
        {
            // Arrange
            var context = GetDbContext();
            var studentId = "student-1";
            var courseId = 1;
            
            context.Enrollments.Add(new Enrollment { CourseId = courseId, StudentId = studentId });
            var session = new AttendanceSession
            {
                Id = 1,
                CourseId = courseId,
                SessionTitle = "Morning Lecture",
                InstructorId = "inst-1",
                QRCodeToken = "token",
                ExpiresAt = DateTime.UtcNow.AddMinutes(10)
            };
            context.AttendanceSessions.Add(session);
            context.AttendanceRecords.Add(new AttendanceRecord { AttendanceSessionId = 1, StudentId = studentId, DeviceId = "device-1" });
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);
            var request = new MarkAttendanceRequest { QRCodeToken = "token", DeviceId = "device-1" };

            // Act & Assert
            var ex = await Assert.ThrowsAsync<Exception>(() => service.MarkAttendanceAsync(request, studentId));
            ex.Message.Should().Be("You have already marked your attendance for this session.");
        }

        [Fact]
        public async Task MarkAttendanceAsync_DeviceAlreadyUsed_ThrowsException()
        {
            // Arrange
            var context = GetDbContext();
            var studentId = "student-2";
            var courseId = 1;
            var deviceId = "same-device";
            
            context.Enrollments.Add(new Enrollment { CourseId = courseId, StudentId = studentId });
            var session = new AttendanceSession
            {
                Id = 1,
                CourseId = courseId,
                SessionTitle = "Morning Lecture",
                InstructorId = "inst-1",
                QRCodeToken = "token",
                ExpiresAt = DateTime.UtcNow.AddMinutes(10)
            };
            context.AttendanceSessions.Add(session);
            context.AttendanceRecords.Add(new AttendanceRecord { AttendanceSessionId = 1, StudentId = "student-1", DeviceId = deviceId });
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);
            var request = new MarkAttendanceRequest { QRCodeToken = "token", DeviceId = deviceId };

            // Act & Assert
            var ex = await Assert.ThrowsAsync<Exception>(() => service.MarkAttendanceAsync(request, studentId));
            ex.Message.Should().Be("This device has already been used to mark attendance for another student.");
        }

        [Fact]
        public async Task GetCourseAttendanceAsync_ValidRequest_ReturnsReport()
        {
            // Arrange
            var context = GetDbContext();
            var instructorId = "instructor-1";
            var studentId = "student-1";
            var courseId = 1;

            context.Courses.Add(new Course { Id = courseId, InstructorId = instructorId, Title = "CS101", Description = "Test" });
            context.Enrollments.Add(new Enrollment { CourseId = courseId, StudentId = studentId });
            context.Users.Add(new ApplicationUser { Id = studentId, FirstName = "John", LastName = "Doe", Faculty = "Engineering" });
            
            var session = new AttendanceSession
            {
                Id = 1,
                CourseId = courseId,
                SessionTitle = "Lecture 1",
                InstructorId = instructorId,
                QRCodeToken = "t1",
                CreatedAt = DateTime.UtcNow
            };
            context.AttendanceSessions.Add(session);
            context.AttendanceRecords.Add(new AttendanceRecord { AttendanceSessionId = 1, StudentId = studentId, DeviceId = "d1" });
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);

            // Act
            var report = await service.GetCourseAttendanceAsync(courseId, instructorId);

            // Assert
            report.Should().NotBeEmpty();
            report.First().SessionTitle.Should().Be("Lecture 1");
            report.First().AttendanceRecords.Should().HaveCount(1);
            report.First().AttendanceRecords.First().IsPresent.Should().BeTrue();
            report.First().AttendanceRecords.First().StudentName.Should().Be("John Doe");
        }

        [Fact]
        public async Task GetStudentAttendanceAsync_ValidRequest_ReturnsRecords()
        {
            // Arrange
            var context = GetDbContext();
            var studentId = "student-1";
            var courseId = 1;

            context.Courses.Add(new Course { Id = courseId, InstructorId = "inst-1", Title = "CS101", Description = "Test" });
            var session = new AttendanceSession
            {
                Id = 1,
                CourseId = courseId,
                SessionTitle = "Lecture 1",
                InstructorId = "inst-1",
                QRCodeToken = "t1",
                CreatedAt = DateTime.UtcNow
            };
            context.AttendanceSessions.Add(session);
            context.AttendanceRecords.Add(new AttendanceRecord { AttendanceSessionId = 1, StudentId = studentId, DeviceId = "d1" });
            await context.SaveChangesAsync();

            var service = new AttendanceService(context);

            // Act
            var records = await service.GetStudentAttendanceAsync(courseId, studentId);

            // Assert
            records.Should().NotBeEmpty();
            records.First().IsPresent.Should().BeTrue();
        }
    }
}
