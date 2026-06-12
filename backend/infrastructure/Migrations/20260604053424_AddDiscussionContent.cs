using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CampusConnect.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddDiscussionContent : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Content",
                table: "Discussions",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Content",
                table: "Discussions");
        }
    }
}
