using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Hubs
{
    public class NotificationHub : Hub
    {
        // Students join their own personal group to receive private notifications
        public async Task JoinPersonalGroup(string userId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"User_{userId}");
        }

        // Global group for important university announcements
        public async Task JoinAnnouncementsGroup()
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, "Announcements");
        }
    }
}
