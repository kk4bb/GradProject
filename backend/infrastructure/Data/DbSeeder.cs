using System;
using System.Linq;
using System.Threading.Tasks;
using CampusConnect.Domain.Entities;
using CampusConnect.Infrastructure.Context;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;

namespace CampusConnect.Infrastructure.Data
{
    public static class DbSeeder
    {
        public static async Task SeedAsync(IServiceProvider serviceProvider)
        {
            var userManager = serviceProvider.GetRequiredService<UserManager<ApplicationUser>>();
            var roleManager = serviceProvider.GetRequiredService<RoleManager<IdentityRole>>();
            var context = serviceProvider.GetRequiredService<ApplicationDbContext>();

            // 1. Check Database (Return if already seeded)
            if (userManager.Users.Any())
            {
                return;
            }

            // 2. Seed Roles
            var roles = new[] { "Instructor", "TA", "Student", "Admin" };
            foreach (var role in roles)
            {
                if (!await roleManager.RoleExistsAsync(role))
                {
                    await roleManager.CreateAsync(new IdentityRole(role));
                }
            }

            // 3. Seed Users
            var doctor = new ApplicationUser
            {
                UserName = "dr.mohamed@campusconnect.edu",
                Email = "dr.mohamed@campusconnect.edu",
                FirstName = "Mohamed",
                LastName = "Ahmed",
                Faculty = "Computer Science",
                EmailConfirmed = true
            };
            await userManager.CreateAsync(doctor, "Password123!");
            await userManager.AddToRoleAsync(doctor, "Instructor");

            var ta = new ApplicationUser
            {
                UserName = "ta.mazen@campusconnect.edu",
                Email = "ta.mazen@campusconnect.edu",
                FirstName = "Mazen",
                LastName = "Tamer",
                Faculty = "Computer Science",
                EmailConfirmed = true
            };
            await userManager.CreateAsync(ta, "Password123!");
            await userManager.AddToRoleAsync(ta, "TA");

            var student = new ApplicationUser
            {
                UserName = "sara.ali@campusconnect.edu",
                Email = "sara.ali@campusconnect.edu",
                FirstName = "Sara",
                LastName = "Ali",
                Faculty = "Computer Science",
                EmailConfirmed = true
            };
            await userManager.CreateAsync(student, "Password123!");
            await userManager.AddToRoleAsync(student, "Student");

            // 4. Seed Course
            var course = new Course
            {
                Title = "Advanced Software Engineering",
                Description = "A comprehensive course on software design patterns, architecture, and agile methodologies.",
                InstructorId = doctor.Id
            };
            context.Courses.Add(course);
            await context.SaveChangesAsync();

            // 5. Seed Enrollment
            var enrollment = new Enrollment
            {
                CourseId = course.Id,
                StudentId = student.Id
            };
            context.Enrollments.Add(enrollment);
            await context.SaveChangesAsync();

            // 6. Seed Content (Module, Lesson, EducationalContent)
            var module = new Module
            {
                CourseId = course.Id,
                Title = "Module 1: Introduction"
            };
            context.Modules.Add(module);
            await context.SaveChangesAsync();

            var lesson = new Lesson
            {
                ModuleId = module.Id,
                Title = "Lesson 1: System Design"
            };
            context.Lessons.Add(lesson);
            await context.SaveChangesAsync();

            var pdfContent = new EducationalContent
            {
                LessonId = lesson.Id,
                ContentType = "PDF",
                FileUrl = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
            };
            var videoContent = new EducationalContent
            {
                LessonId = lesson.Id,
                ContentType = "Video",
                FileUrl = "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"
            };
            context.EducationalContents.AddRange(pdfContent, videoContent);
            await context.SaveChangesAsync();

            // 7. Seed Quiz
            var quiz = new Quiz
            {
                CourseId = course.Id,
                Title = "System Design Fundamentals Quiz"
            };
            context.Quizzes.Add(quiz);
            await context.SaveChangesAsync();

            var mcqQuestion = new Question
            {
                QuizId = quiz.Id,
                Text = "Which pattern restricts the instantiation of a class to one object?"
            };
            context.Questions.Add(mcqQuestion);
            await context.SaveChangesAsync();

            context.QuestionOptions.AddRange(
                new QuestionOption { QuestionId = mcqQuestion.Id, Text = "Factory", IsCorrect = false },
                new QuestionOption { QuestionId = mcqQuestion.Id, Text = "Singleton", IsCorrect = true },
                new QuestionOption { QuestionId = mcqQuestion.Id, Text = "Observer", IsCorrect = false },
                new QuestionOption { QuestionId = mcqQuestion.Id, Text = "Decorator", IsCorrect = false }
            );

            var essayQuestion = new Question
            {
                QuizId = quiz.Id,
                Text = "Explain the differences between Monolithic and Microservices architectures."
            };
            context.Questions.Add(essayQuestion);

            var imageQuestion = new Question
            {
                QuizId = quiz.Id,
                Text = "Identify the design pattern illustrated in the diagram below."
            };
            context.Questions.Add(imageQuestion);
            await context.SaveChangesAsync();

            context.QuestionOptions.AddRange(
                new QuestionOption { QuestionId = imageQuestion.Id, Text = "Singleton", IsCorrect = true },
                new QuestionOption { QuestionId = imageQuestion.Id, Text = "Factory Method", IsCorrect = false }
            );
            await context.SaveChangesAsync();

            // 8. Seed Assignment & Submission
            var assignment = new Assignment
            {
                CourseId = course.Id,
                Title = "Project Phase 1: Architecture Document",
                Description = "Submit a PDF of your proposed system architecture.",
                DueDate = DateTime.UtcNow.AddDays(7),
                Points = 100
            };
            context.Assignments.Add(assignment);
            await context.SaveChangesAsync();

            var submission = new Submission
            {
                AssignmentId = assignment.Id,
                StudentId = student.Id,
                FileUrl = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
                Comment = "Here is my architecture document.",
                Grade = 95,
                Feedback = "Excellent work, Sara! Very detailed."
            };
            context.Submissions.Add(submission);
            await context.SaveChangesAsync();

            // 9. Seed Forums
            var discussion = new Discussion
            {
                CourseId = course.Id,
                Title = "General Q&A",
                Content = "Ask questions regarding the course material here.",
                CreatedAt = DateTime.UtcNow,
                Status = "OPEN"
            };
            context.Discussions.Add(discussion);
            await context.SaveChangesAsync();

            var post = new Post
            {
                DiscussionId = discussion.Id,
                UserId = doctor.Id,
                Content = "Welcome to the course! Feel free to ask any questions here.",
                CreatedAt = DateTime.UtcNow
            };
            context.Posts.Add(post);
            await context.SaveChangesAsync();

            var studentComment = new Comment
            {
                PostId = post.Id,
                UserId = student.Id,
                Content = "Do we have homework for the first week?"
            };
            context.Comments.Add(studentComment);
            await context.SaveChangesAsync();

            var taComment = new Comment
            {
                PostId = post.Id,
                UserId = ta.Id,
                Content = "Yes, check the assignment section. Phase 1 is due next week."
            };
            context.Comments.Add(taComment);
            await context.SaveChangesAsync();

            // 10. Seed Attendance
            var attendanceSession = new AttendanceSession
            {
                CourseId = course.Id,
                SessionTitle = "Lecture 1 Attendance",
                QRCodeToken = "dummy-qr-code-12345",
                CreatedAt = DateTime.UtcNow,
                ExpiresAt = DateTime.UtcNow.AddHours(2),
                InstructorId = doctor.Id
            };
            context.AttendanceSessions.Add(attendanceSession);
            await context.SaveChangesAsync();

            var attendanceRecord = new AttendanceRecord
            {
                AttendanceSessionId = attendanceSession.Id,
                StudentId = student.Id,
                DeviceId = "sara-iphone-123",
                ScannedAt = DateTime.UtcNow
            };
            context.AttendanceRecords.Add(attendanceRecord);
            await context.SaveChangesAsync();

            // 11. Seed AI Chat
            var chatSession = new ChatSession
            {
                StudentId = student.Id,
                Title = "Understanding System Design",
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };
            context.ChatSessions.Add(chatSession);
            await context.SaveChangesAsync();

            context.ChatMessages.AddRange(
                new ChatMessage
                {
                    SessionId = chatSession.Id,
                    Sender = "User",
                    Content = "What is the difference between monolithic and microservices?",
                    CreatedAt = DateTime.UtcNow.AddMinutes(-2)
                },
                new ChatMessage
                {
                    SessionId = chatSession.Id,
                    Sender = "AI",
                    Content = "Great question! A monolithic architecture implies all components are tightly coupled in a single codebase and deployed as a single unit. Microservices, on the other hand, split the application into small, independent services that communicate over a network. Which one do you think is easier to scale?",
                    CreatedAt = DateTime.UtcNow.AddMinutes(-1)
                }
            );
            await context.SaveChangesAsync();
        }
    }
}
