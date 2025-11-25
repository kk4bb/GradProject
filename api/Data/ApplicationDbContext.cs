using Microsoft.EntityFrameworkCore;
using LMS.Api.Models.Entities;

namespace LMS.Api.Data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users { get; set; }
}

