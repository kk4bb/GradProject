using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class Course
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public string InstructorId { get; set; }

        public ICollection<Module> Modules { get; set; }

        public ICollection<Enrollment> Enrollments { get; set; }

        public ICollection<Assignment> Assignments { get; set; }

        public ICollection<Quiz> Quizzes { get; set; }

        public ICollection<AttendanceSession> AttendanceSessions { get; set; }
    }
}
