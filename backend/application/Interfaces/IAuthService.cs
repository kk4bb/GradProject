using CampusConnect.Application.Dtos.Auth;

namespace CampusConnect.Application.Interfaces
{
    public interface IAuthService
    {
       Task<AuthResponseDto> RegisterAsync(RegisterDto dto);
       Task<AuthResponseDto> LoginAsync(LoginDto dto);
    }
}
