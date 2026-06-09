// api/Controllers/SeedController.cs
// ⚠️ DEV-ONLY — Remove before going to production!

using CampusConnect.Domain.Entities;
using CampusConnect.Infrastructure.Context;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[ApiController]
[Route("api/[controller]")]
public class SeedController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly RoleManager<IdentityRole> _roleManager;
    private readonly ApplicationDbContext _db;

    public SeedController(
        UserManager<ApplicationUser> userManager,
        RoleManager<IdentityRole> roleManager,
        ApplicationDbContext db)
    {
        _userManager = userManager;
        _roleManager = roleManager;
        _db = db;
    }

    /// <summary>
    /// POST /api/seed — Seeds roles, users, courses, and enrollments.
    /// Safe to call multiple times (idempotent).
    /// </summary>
    [HttpPost]
    public async Task<IActionResult> Seed()
    {
        var log = new List<string>();
        try
        {
            // ── 1. Roles ──────────────────────────────────────────────────────
            string[] roles = ["Student", "Instructor", "TA"];
            foreach (var role in roles)
            {
                if (!await _roleManager.RoleExistsAsync(role))
                {
                    await _roleManager.CreateAsync(new IdentityRole(role));
                    log.Add($"Role created: {role}");
                }
                else
                {
                    log.Add($"Role exists: {role}");
                }
            }

            // ── 2. Users ──────────────────────────────────────────────────────
            var prof = await EnsureUser(log, "prof@bnu.edu", "TF2", "Doctor", "Engineering", "Instructor", "Password123!");
            var ta = await EnsureUser(log, "ta@bnu.edu", "Youssef", "Hatem", "Engineering", "TA", "Password123!");
            var student = await EnsureUser(log, "student@bnu.edu", "Jimmy", "Hopkins", "Engineering", "Student", "Password123!");

            // ── 3. Courses ────────────────────────────────────────────────────
            var godotCourse = await EnsureCourse(log, "Game Development With Godot", "Learn to build games with Godot engine.", prof.Id);
            await EnsureEnrollment(log, student.Id, godotCourse.Id, godotCourse.Title);

            // ── 4. Assignments ────────────────────────────────────────────────
            await EnsureAssignment(log, "Godot Basics Assignment", "Create a simple character controller.", DateTime.UtcNow.AddDays(12), godotCourse.Id);
            await EnsureAssignment(log, "Godot Advanced Assignment", "Implement a platformer level.", DateTime.UtcNow.AddDays(50), godotCourse.Id);

            // ── 5. Quizzes & Questions ────────────────────────────────────────
            var q1 = await EnsureQuiz(log, "Godot Basics Quiz", godotCourse.Id);
            await EnsureQuestion(log, "What is GDScript most similar to?", q1.Id);
            await EnsureQuestion(log, "What is the root node?", q1.Id);

            var q2 = await EnsureQuiz(log, "Godot Advanced Quiz", godotCourse.Id);
            await EnsureQuestion(log, "Which signal is emitted when a node enters the tree?", q2.Id);
            await EnsureQuestion(log, "Explain the life cycle of a node?", q2.Id);

            // ── 6. Discussions ────────────────────────────────────────────────
            await EnsureDiscussion(log, "Godot Scene System Discussion", godotCourse.Id);
            await EnsureDiscussion(log, "GDScript Performance Tips", godotCourse.Id);

            return Ok(new
            {
                message = "Seed completed successfully!",
                log
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { error = ex.Message, inner = ex.InnerException?.Message, log, stack = ex.StackTrace });
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private async Task<ApplicationUser> EnsureUser(
        List<string> log,
        string email, string firstName, string lastName,
        string faculty, string role,
        string password = "qweasd",
        int? academicYear = null, int? creditHours = null)
    {
        var existing = await _userManager.FindByEmailAsync(email);
        if (existing != null)
        {
            // Update name if it's not what we want
            if (existing.FirstName != firstName || existing.LastName != lastName) {
                existing.FirstName = firstName;
                existing.LastName = lastName;
                await _userManager.UpdateAsync(existing);
                log.Add($"User updated: {email}");
            } else {
                log.Add($"User exists: {email}");
            }
            return existing;
        }

        var user = new ApplicationUser
        {
            Email          = email,
            UserName       = $"{firstName}{lastName}",
            FirstName      = firstName,
            LastName       = lastName,
            Faculty        = faculty,
            AcademicYear   = academicYear,
            CreditHours    = creditHours,
            EmailConfirmed = true,
        };


        var result = await _userManager.CreateAsync(user, password);
        if (!result.Succeeded)
        {
            var errors = string.Join(", ", result.Errors.Select(e => e.Description));
            throw new Exception($"Failed to create user '{email}': {errors}");
        }

        await _userManager.AddToRoleAsync(user, role);
        log.Add($"User created [{role}]: {email}");
        return user;
    }

    private async Task<Course> EnsureCourse(List<string> log, string title, string description, string instructorId)
    {
        var existing = await _db.Courses.FirstOrDefaultAsync(c => c.Title == title);
        if (existing != null) return existing;
        var course = new Course { Title = title, Description = description, InstructorId = instructorId };
        _db.Courses.Add(course);
        await _db.SaveChangesAsync();
        log.Add($"Course created: {title}");
        return course;
    }

    private async Task EnsureEnrollment(List<string> log, string studentId, int courseId, string courseTitle)
    {
        var exists = await _db.Enrollments.AnyAsync(e => e.StudentId == studentId && e.CourseId == courseId);
        if (exists) return;
        _db.Enrollments.Add(new Enrollment { StudentId = studentId, CourseId = courseId });
        await _db.SaveChangesAsync();
        log.Add($"Enrolled student in {courseTitle}");
    }

    private async Task<Assignment> EnsureAssignment(List<string> log, string title, string desc, DateTime dueDate, int courseId)
    {
        var assignment = new Assignment { Title = title, Description = desc, DueDate = dueDate, CourseId = courseId };
        _db.Assignments.Add(assignment);
        await _db.SaveChangesAsync();
        log.Add($"Assignment created: {title}");
        return assignment;
    }

    private async Task<Quiz> EnsureQuiz(List<string> log, string title, int courseId)
    {
        var quiz = new Quiz { Title = title, CourseId = courseId };
        _db.Quizzes.Add(quiz);
        await _db.SaveChangesAsync();
        log.Add($"Quiz created: {title}");
        return quiz;
    }

    private async Task EnsureQuestion(List<string> log, string text, int quizId)
    {
        _db.Questions.Add(new Question { Text = text, QuizId = quizId });
        await _db.SaveChangesAsync();
        log.Add($"Question created: {text}");
    }

    private async Task EnsureDiscussion(List<string> log, string title, int courseId)
    {
        _db.Discussions.Add(new Discussion { Title = title, Content = "Default content", CourseId = courseId });
        await _db.SaveChangesAsync();
        log.Add($"Discussion created: {title}");
    }

}
