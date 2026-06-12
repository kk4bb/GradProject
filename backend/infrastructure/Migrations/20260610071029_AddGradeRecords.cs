using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CampusConnect.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddGradeRecords : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "GradeRecords",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StudentId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    CourseId = table.Column<int>(type: "int", nullable: false),
                    QuizzesTotal = table.Column<double>(type: "float", nullable: false),
                    AssignmentsTotal = table.Column<double>(type: "float", nullable: false),
                    AttendanceTotal = table.Column<double>(type: "float", nullable: false),
                    ProjectGrade = table.Column<double>(type: "float", nullable: false),
                    Midterm1 = table.Column<double>(type: "float", nullable: false),
                    Midterm2 = table.Column<double>(type: "float", nullable: false),
                    FinalExam = table.Column<double>(type: "float", nullable: false),
                    IsTermWorkPublished = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GradeRecords", x => x.Id);
                    table.ForeignKey(
                        name: "FK_GradeRecords_AspNetUsers_StudentId",
                        column: x => x.StudentId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_GradeRecords_Courses_CourseId",
                        column: x => x.CourseId,
                        principalTable: "Courses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_GradeRecords_CourseId",
                table: "GradeRecords",
                column: "CourseId");

            migrationBuilder.CreateIndex(
                name: "IX_GradeRecords_StudentId_CourseId",
                table: "GradeRecords",
                columns: new[] { "StudentId", "CourseId" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "GradeRecords");
        }
    }
}
