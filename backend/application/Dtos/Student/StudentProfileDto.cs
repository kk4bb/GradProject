namespace CampusConnect.Application.Dtos.Student
{
    public class StudentProfileDto
    {
        public string Id { get; set; } // The User ID
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Faculty { get; set; }
        public int AcademicYear { get; set; }
        public int CreditHours { get; set; }
        public int EnrolledCoursesCount { get; set; }
    }
}
