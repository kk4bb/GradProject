using CampusConnect.Application.Dtos.AiChat;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IAiChatService
    {
        Task<AiChatResponseDto> GetChatResponseAsync(AiChatRequestDto request);
    }
}
