using CampusConnect.Domain.Entities;
using Microsoft.AspNetCore.Identity;
using System.Collections.Generic;

namespace CampusConnect.Infrastructure.Context
{
    public class ApplicationUser : IdentityUser
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Faculty { get; set; }
        public int? AcademicYear { get; set; }
        public int? CreditHours { get; set; }

        // For Instructors
        public virtual ICollection<Course> AssignedCourses { get; set; } = new List<Course>();
    }
}
