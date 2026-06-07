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
            var doctor = await EnsureUser(log,
                "dr.smith@campusconnect.edu", "John", "Smith",
                "Faculty of Computer Science", "Instructor");

            await EnsureUser(log,
                "ta.ahmed@campusconnect.edu", "Ahmed", "Hassan",
                "Faculty of Computer Science", "TA");

            await EnsureUser(log,
                "john.doe@example.com", "John", "Doe",
                "Faculty of Computer Science", "Student",
                academicYear: 2, creditHours: 72);

            await EnsureUser(log,
                "sara.ali@example.com", "Sara", "Ali",
                "Faculty of Computer Science", "Student",
                academicYear: 2, creditHours: 68);

            // ── 3. Courses (owned by doctor) ──────────────────────────────────
            var cs101 = await EnsureCourse(log,
                "CS101 - Introduction to Programming",
                "Fundamentals of programming using Python.",
                doctor.Id);

            var ds201 = await EnsureCourse(log,
                "DS201 - Data Structures",
                "Arrays, linked lists, stacks, queues, trees, and graphs.",
                doctor.Id);

            var db301 = await EnsureCourse(log,
                "DB301 - Database Systems",
                "Relational model, SQL, normalization, and transactions.",
                doctor.Id);

            // ── 4. Enroll all students in all courses ─────────────────────────
            var students = await _userManager.GetUsersInRoleAsync("Student");
            foreach (var student in students)
            {
                await EnsureEnrollment(log, student.Id, cs101.Id, cs101.Title);
                await EnsureEnrollment(log, student.Id, ds201.Id, ds201.Title);
                await EnsureEnrollment(log, student.Id, db301.Id, db301.Title);
            }

            return Ok(new
            {
                message = "Seed completed successfully!",
                log,
                credentials = new[]
                {
                    new { role = "Instructor", email = "dr.smith@campusconnect.edu", password = "Password123!" },
                    new { role = "TA",         email = "ta.ahmed@campusconnect.edu", password = "Password123!" },
                    new { role = "Student",    email = "john.doe@example.com",       password = "Password123!" },
                    new { role = "Student",    email = "sara.ali@example.com",       password = "Password123!" },
                },
                courses = new[]
                {
                    new { id = cs101.Id, title = cs101.Title },
                    new { id = ds201.Id, title = ds201.Title },
                    new { id = db301.Id, title = db301.Title },
                }
            });
        }
        catch (Exception ex)
        {
            // Return full error details for debugging
            return StatusCode(500, new
            {
                error   = ex.Message,
                inner   = ex.InnerException?.Message,
                log,
                stack   = ex.StackTrace
            });
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private async Task<ApplicationUser> EnsureUser(
        List<string> log,
        string email, string firstName, string lastName,
        string faculty, string role,
        int? academicYear = null, int? creditHours = null)
    {
        var existing = await _userManager.FindByEmailAsync(email);
        if (existing != null)
        {
            log.Add($"User exists: {email}");
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

        var result = await _userManager.CreateAsync(user, "Password123!");
        if (!result.Succeeded)
        {
            var errors = string.Join(", ", result.Errors.Select(e => e.Description));
            throw new Exception($"Failed to create user '{email}': {errors}");
        }

        await _userManager.AddToRoleAsync(user, role);
        log.Add($"User created [{role}]: {email}");
        return user;
    }

    private async Task<Course> EnsureCourse(
        List<string> log, string title, string description, string instructorId)
    {
        var existing = await _db.Courses.FirstOrDefaultAsync(c => c.Title == title);
        if (existing != null)
        {
            log.Add($"Course exists: {title}");
            return existing;
        }

        var course = new Course
        {
            Title        = title,
            Description  = description,
            InstructorId = instructorId,
        };
        _db.Courses.Add(course);
        await _db.SaveChangesAsync();
        log.Add($"Course created (ID={course.Id}): {title}");
        return course;
    }

    private async Task EnsureEnrollment(
        List<string> log, string studentId, int courseId, string courseTitle)
    {
        var exists = await _db.Enrollments
            .AnyAsync(e => e.StudentId == studentId && e.CourseId == courseId);
        if (exists)
        {
            log.Add($"Enrollment exists: student {studentId[..8]}... → {courseTitle}");
            return;
        }

        _db.Enrollments.Add(new Enrollment { StudentId = studentId, CourseId = courseId });
        await _db.SaveChangesAsync();
        log.Add($"Enrolled: student {studentId[..8]}... → {courseTitle}");
    }
}
