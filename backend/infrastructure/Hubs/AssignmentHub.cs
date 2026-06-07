using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Hubs
{
    public class AssignmentHub : Hub
    {
        public async Task JoinCourseGroup(string courseId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, courseId);
        }

        public async Task LeaveCourseGroup(string courseId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, courseId);
        }
    }
}
