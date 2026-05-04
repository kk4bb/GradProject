using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CampusConnect.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class SeedDummyQuiz : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("INSERT INTO Quizzes (Title, CourseId, Description, DueDate) VALUES ('General Knowledge Quiz', 1, 'A simple quiz to test the system', '2026-12-31')");
            
            // Assuming the quiz ID is 1 (since it's the first one, or we use a subquery)
            migrationBuilder.Sql("INSERT INTO Questions (QuizId, [Text]) VALUES ((SELECT TOP 1 Id FROM Quizzes WHERE Title = 'General Knowledge Quiz'), 'What is the capital of France?')");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'What is the capital of France?'), 'Paris', 1)");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'What is the capital of France?'), 'London', 0)");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'What is the capital of France?'), 'Berlin', 0)");

            migrationBuilder.Sql("INSERT INTO Questions (QuizId, [Text]) VALUES ((SELECT TOP 1 Id FROM Quizzes WHERE Title = 'General Knowledge Quiz'), 'Which planet is known as the Red Planet?')");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'Which planet is known as the Red Planet?'), 'Mars', 1)");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'Which planet is known as the Red Planet?'), 'Jupiter', 0)");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'Which planet is known as the Red Planet?'), 'Venus', 0)");

            migrationBuilder.Sql("INSERT INTO Questions (QuizId, [Text]) VALUES ((SELECT TOP 1 Id FROM Quizzes WHERE Title = 'General Knowledge Quiz'), 'What is 2 + 2?')");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'What is 2 + 2?'), '3', 0)");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'What is 2 + 2?'), '4', 1)");
            migrationBuilder.Sql("INSERT INTO QuestionOptions (QuestionId, [Text], IsCorrect) VALUES ((SELECT TOP 1 Id FROM Questions WHERE [Text] = 'What is 2 + 2?'), '5', 0)");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DELETE FROM QuestionOptions WHERE QuestionId IN (SELECT Id FROM Questions WHERE QuizId IN (SELECT Id FROM Quizzes WHERE Title = 'General Knowledge Quiz'))");
            migrationBuilder.Sql("DELETE FROM Questions WHERE QuizId IN (SELECT Id FROM Quizzes WHERE Title = 'General Knowledge Quiz')");
            migrationBuilder.Sql("DELETE FROM Quizzes WHERE Title = 'General Knowledge Quiz'");
        }
    }
}
