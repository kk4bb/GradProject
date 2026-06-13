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

            // 🎓 2. Users 🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓
            var ahmed = await EnsureUser(log,
                "ahmed@bnu.edu.eg", "Ahmed", "Mahmoud",
                "Faculty of Computer Science", "Instructor");

            var tariq = await EnsureUser(log,
                "tariq@bnu.edu.eg", "Tariq", "Hassan",
                "Faculty of Computer Science", "Instructor");

            var mazen = await EnsureUser(log,
                "mazen@bnu.edu.eg", "Mazen", "Tamer",
                "Faculty of Computer Science", "TA");

            var seif = await EnsureUser(log,
                "seif@bnu.edu.eg", "Seif", "Essam",
                "Faculty of Computer Science", "Student",
                academicYear: 4, creditHours: 120);

            var fayez = await EnsureUser(log,
                "fayez@bnu.edu.eg", "Ahmed", "Fayez",
                "Faculty of Computer Science", "Student",
                academicYear: 4, creditHours: 120);

            // 🎓 3. Courses 🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓
            var ase = await EnsureCourse(log,
                "Advanced Software Engineering",
                "Advanced topics in software engineering, architecture, and design patterns.",
                ahmed.Id);

            var dbSys = await EnsureCourse(log,
                "Database Systems & Architecture",
                "In-depth database systems architecture and implementation.",
                ahmed.Id);

            var dip = await EnsureCourse(log,
                "Digital Image Processing",
                "Fundamentals of image processing and computer vision algorithms.",
                tariq.Id);

            var dc = await EnsureCourse(log,
                "Data Compression",
                "Lossless and lossy data compression algorithms.",
                tariq.Id);

            // 🎓 4. Assign TA 🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓
            await EnsureEnrollment(log, mazen.Id, ase.Id, ase.Title);
            
            // 🎓 5. Enroll Students 🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓🎓
            var students = new[] { seif, fayez };
            foreach (var student in students)
            {
                await EnsureEnrollment(log, student.Id, ase.Id, ase.Title);
                await EnsureEnrollment(log, student.Id, dbSys.Id, dbSys.Title);
            }

            return Ok(new
            {
                message = "Seed completed successfully!",
                log,
                credentials = new[]
                {
                    new { role = "Instructor", email = "ahmed@bnu.edu.eg", password = "Password123!" },
                    new { role = "Instructor", email = "tariq@bnu.edu.eg", password = "Password123!" },
                    new { role = "TA",         email = "mazen@bnu.edu.eg", password = "Password123!" },
                    new { role = "Student",    email = "seif@bnu.edu.eg",  password = "Password123!" },
                    new { role = "Student",    email = "fayez@bnu.edu.eg", password = "Password123!" },
                },
                courses = new[]
                {
                    new { id = ase.Id, title = ase.Title },
                    new { id = dbSys.Id, title = dbSys.Title },
                    new { id = dip.Id, title = dip.Title },
                    new { id = dc.Id, title = dc.Title },
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
