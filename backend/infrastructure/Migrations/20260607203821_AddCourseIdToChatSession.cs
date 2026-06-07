using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CampusConnect.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddCourseIdToChatSession : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "CourseId",
                table: "ChatSessions",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_ChatSessions_CourseId",
                table: "ChatSessions",
                column: "CourseId");

            migrationBuilder.AddForeignKey(
                name: "FK_ChatSessions_Courses_CourseId",
                table: "ChatSessions",
                column: "CourseId",
                principalTable: "Courses",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ChatSessions_Courses_CourseId",
                table: "ChatSessions");

            migrationBuilder.DropIndex(
                name: "IX_ChatSessions_CourseId",
                table: "ChatSessions");

            migrationBuilder.DropColumn(
                name: "CourseId",
                table: "ChatSessions");
        }
    }
}
