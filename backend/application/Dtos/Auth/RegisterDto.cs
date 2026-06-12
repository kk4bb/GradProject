namespace CampusConnect.Application.Dtos.Auth
{
    public class RegisterDto
    {
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Faculty { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string Role { get; set; } // Student / Instructor
    }
}
