using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CampusConnect.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class SeedMoreData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Seed Assignments for June
            migrationBuilder.Sql("INSERT INTO Assignments (Title, Description, DueDate, CourseId) VALUES ('Project Proposal', 'Submit your initial project proposal for feedback.', '2026-06-10', 1)");
            migrationBuilder.Sql("INSERT INTO Assignments (Title, Description, DueDate, CourseId) VALUES ('Midterm Assignment', 'Comprehensive assignment covering modules 1-3.', '2026-06-25', 1)");

            // Seed Quizzes for June
            migrationBuilder.Sql("INSERT INTO Quizzes (Title, Description, DueDate, CourseId) VALUES ('Module 4 Quiz', 'Quiz on advanced API design patterns.', '2026-06-15', 1)");
            
            // Seed Questions for the new quiz
            migrationBuilder.Sql("INSERT INTO Questions (QuizId, [Text]) VALUES ((SELECT TOP 1 Id FROM Quizzes WHERE Title = 'Module 4 Quiz'), 'What is HATEOAS?')");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'What is HATEOAS?'), 'A REST constraint', 1)");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'What is HATEOAS?'), 'A database type', 0)");

            // Seed Notifications
            migrationBuilder.Sql("INSERT INTO Notifications (Title, Message, CreatedAt, IsRead, IsAnnouncement, UserId) VALUES ('Welcome', 'Welcome to CampusConnect!', GETDATE(), 0, 0, '5b7c2067-5894-4848-b86e-9c29bd745e7d')");
            migrationBuilder.Sql("INSERT INTO Notifications (Title, Message, CreatedAt, IsRead, IsAnnouncement) VALUES ('Holiday Notice', 'The campus will be closed on June 30th.', GETDATE(), 0, 1)");

            // Seed Forum Posts for the existing Discussion
            // Assuming Discussion ID 1 exists from previous seed
            migrationBuilder.Sql("IF EXISTS (SELECT 1 FROM Discussions WHERE Id = 1) BEGIN " +
                                 "INSERT INTO Posts (DiscussionId, UserId, Content) VALUES (1, '5b7c2067-5894-4848-b86e-9c29bd745e7d', 'I have a question about the final project.'); " +
                                 "INSERT INTO Comments (PostId, UserId, Content) VALUES ((SELECT TOP 1 Id FROM Posts ORDER BY Id DESC), '33D5D51A-9F35-4C2E-946B-7C43E0D4B66D', 'Please check the syllabus for details.'); " +
                                 "END");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DELETE FROM QuestionOptions WHERE QuestionId IN (SELECT Id FROM Questions WHERE QuizId IN (SELECT Id FROM Quizzes WHERE Title = 'Module 4 Quiz'))");
            migrationBuilder.Sql("DELETE FROM Questions WHERE QuizId IN (SELECT Id FROM Quizzes WHERE Title = 'Module 4 Quiz')");
            migrationBuilder.Sql("DELETE FROM Quizzes WHERE Title = 'Module 4 Quiz'");
            migrationBuilder.Sql("DELETE FROM Assignments WHERE Title IN ('Project Proposal', 'Midterm Assignment')");
            migrationBuilder.Sql("DELETE FROM Notifications WHERE Title IN ('Welcome', 'Holiday Notice')");
            migrationBuilder.Sql("DELETE FROM Comments WHERE Content = 'Please check the syllabus for details.'");
            migrationBuilder.Sql("DELETE FROM Posts WHERE Content = 'I have a question about the final project.'");
        }
    }
}
