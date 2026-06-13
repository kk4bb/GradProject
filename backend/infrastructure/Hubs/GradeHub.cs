using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Hubs
{
    public class GradeHub : Hub
    {
        public async Task JoinCourseGroup(string courseId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"Course_{courseId}_Grades");
        }

        public async Task LeaveCourseGroup(string courseId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"Course_{courseId}_Grades");
        }
    }
}
