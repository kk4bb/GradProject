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

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Enrollment ↔ Course
        modelBuilder.Entity<Enrollment>()
            .HasOne(e => e.Course)
            .WithMany(c => c.Enrollments)
            .HasForeignKey(e => e.CourseId)
            .OnDelete(DeleteBehavior.Cascade);

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
            .HasOne<Discussion>()
            .WithMany(d => d.Posts)
            .HasForeignKey(p => p.DiscussionId);

        // Comment ↔ Post
        modelBuilder.Entity<Comment>()
            .HasOne<Post>()
            .WithMany(p => p.Comments)
            .HasForeignKey(c => c.PostId);

        // QuizAttempt ↔ Quiz
        modelBuilder.Entity<QuizAttempt>()
            .HasOne<Quiz>()
            .WithMany()
            .HasForeignKey(q => q.QuizId);

        // Prevent duplicate enrollment
        modelBuilder.Entity<Enrollment>()
            .HasIndex(e => new { e.StudentId, e.CourseId })
            .IsUnique();
    }
}