using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Dashboard
{
    public class StudentDashboardDto
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public List<EnrolledCourseDto> EnrolledCourses { get; set; }
        public List<QuizAttemptDto> QuizAttempts { get; set; }
        public List<SubmissionDto> Submissions { get; set; }
    }

    public class EnrolledCourseDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string InstructorName { get; set; }
    }

    public class QuizAttemptDto
    {
        public int Id { get; set; }
        public string QuizTitle { get; set; }
        public double Score { get; set; }
    }

    public class SubmissionDto
    {
        public int Id { get; set; }
        public string AssignmentTitle { get; set; }
        public double Grade { get; set; }
    }
}
