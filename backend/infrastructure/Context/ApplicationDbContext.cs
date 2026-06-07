using CampusConnect.Domain.Entities;
using CampusConnect.Infrastructure.Context;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<Course> Courses { get; set; }
    public DbSet<Enrollment> Enrollments { get; set; }
    public DbSet<Module> Modules { get; set; }
    public DbSet<Lesson> Lessons { get; set; }
    public DbSet<EducationalContent> EducationalContents { get; set; }
    public DbSet<Assignment> Assignments { get; set; }
    public DbSet<Submission> Submissions { get; set; }
    public DbSet<Quiz> Quizzes { get; set; }
    public DbSet<Question> Questions { get; set; }
    public DbSet<QuestionOption> QuestionOptions { get; set; }
    public DbSet<QuizAttempt> QuizAttempts { get; set; }
    public DbSet<Discussion> Discussions { get; set; }
    public DbSet<Post> Posts { get; set; }
    public DbSet<Comment> Comments { get; set; }
    public DbSet<Notification> Notifications { get; set; }
    public DbSet<AttendanceSession> AttendanceSessions { get; set; }
    public DbSet<AttendanceRecord> AttendanceRecords { get; set; }
    public DbSet<ChatSession> ChatSessions { get; set; }
    public DbSet<ChatMessage> ChatMessages { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Enrollment ↔ Course
        modelBuilder.Entity<Enrollment>()
            .HasOne(e => e.Course)
            .WithMany(c => c.Enrollments)
            .HasForeignKey(e => e.CourseId)
            .OnDelete(DeleteBehavior.Cascade);

        // Course ↔ Instructor (ApplicationUser)
        modelBuilder.Entity<Course>()
            .HasOne<ApplicationUser>()
            .WithMany(u => u.AssignedCourses)
            .HasForeignKey(c => c.InstructorId)
            .OnDelete(DeleteBehavior.Restrict);

        // Module ↔ Course
        modelBuilder.Entity<Module>()
            .HasOne(m => m.Course)
            .WithMany(c => c.Modules)
            .HasForeignKey(m => m.CourseId);

        // Lesson ↔ Module
        modelBuilder.Entity<Lesson>()
            .HasOne(l => l.Module)
            .WithMany(m => m.Lessons)
            .HasForeignKey(l => l.ModuleId);

        // Content ↔ Lesson
        modelBuilder.Entity<EducationalContent>()
            .HasOne(ec => ec.Lesson)
            .WithMany(l => l.Contents)
            .HasForeignKey(ec => ec.LessonId);

        // Assignment ↔ Course
        modelBuilder.Entity<Assignment>()
            .HasOne(a => a.Course)
            .WithMany(c => c.Assignments)
            .HasForeignKey(a => a.CourseId);

        // Submission ↔ Assignment
        modelBuilder.Entity<Submission>()
            .HasOne(s => s.Assignment)
            .WithMany(a => a.Submissions)
            .HasForeignKey(s => s.AssignmentId);

        // Quiz ↔ Course
        modelBuilder.Entity<Quiz>()
            .HasOne(q => q.Course)
            .WithMany(c => c.Quizzes)
            .HasForeignKey(q => q.CourseId);

        // Question ↔ Quiz
        modelBuilder.Entity<Question>()
            .HasOne(q => q.Quiz)
            .WithMany(qz => qz.Questions)
            .HasForeignKey(q => q.QuizId);

        // QuestionOption ↔ Question
        modelBuilder.Entity<QuestionOption>()
            .HasOne(o => o.Question)
            .WithMany(q => q.Options)
            .HasForeignKey(o => o.QuestionId);

        // Post ↔ Discussion
        modelBuilder.Entity<Post>()
            .HasOne(p => p.Discussion)   // ← binds to Post.Discussion nav property
            .WithMany(d => d.Posts)
            .HasForeignKey(p => p.DiscussionId);

        // Comment ↔ Post
        modelBuilder.Entity<Comment>()
            .HasOne(c => c.Post)         // ← binds to Comment.Post nav property
            .WithMany(p => p.Comments)
            .HasForeignKey(c => c.PostId);

        // QuizAttempt ↔ Quiz
        modelBuilder.Entity<QuizAttempt>()
            .HasOne<Quiz>()
            .WithMany()
            .HasForeignKey(q => q.QuizId);

        // AttendanceSession ↔ Course
        modelBuilder.Entity<AttendanceSession>()
            .HasOne(s => s.Course)
            .WithMany(c => c.AttendanceSessions)
            .HasForeignKey(s => s.CourseId);

        // AttendanceRecord ↔ AttendanceSession
        modelBuilder.Entity<AttendanceRecord>()
            .HasOne(r => r.Session)
            .WithMany(s => s.Records)
            .HasForeignKey(r => r.AttendanceSessionId);

        // AttendanceRecord ↔ Student (ApplicationUser)
        modelBuilder.Entity<AttendanceRecord>()
            .HasOne<ApplicationUser>()
            .WithMany()
            .HasForeignKey(r => r.StudentId);

        // Prevent duplicate attendance for same student in same session
        modelBuilder.Entity<AttendanceRecord>()
            .HasIndex(r => new { r.AttendanceSessionId, r.StudentId })
            .IsUnique();

        // Prevent duplicate attendance from same device in same session (optional but good)
        modelBuilder.Entity<AttendanceRecord>()
            .HasIndex(r => new { r.AttendanceSessionId, r.DeviceId })
            .IsUnique();

        // Prevent duplicate enrollment
        modelBuilder.Entity<Enrollment>()
            .HasIndex(e => new { e.StudentId, e.CourseId })
            .IsUnique();
    }
}
