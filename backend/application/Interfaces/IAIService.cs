using CampusConnect.Application.Dtos.AI;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IAIService
    {
        Task<List<ChatSessionDto>> GetUserSessionsAsync(string userId);
        Task<List<ChatMessageDto>> GetSessionMessagesAsync(int sessionId, string userId);
        Task<string> SendMessageAsync(string userId, SendMessageRequest request);
        Task DeleteSessionAsync(int sessionId, string userId);
    }
}
