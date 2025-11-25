using Microsoft.AspNetCore.Mvc;
using LMS.Api.Data;

namespace LMS.Api.Controllers;

[ApiController]
[Route("test")]
public class TestController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public TestController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet("users-count")]
    public IActionResult GetUserCount()
    {
        var count = _context.Users.Count();
        return Ok(new { count });
    }
}

