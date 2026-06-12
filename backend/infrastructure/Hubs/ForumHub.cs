using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace CampusConnect.Infrastructure.Hubs
{
    public class ForumHub : Hub
    {
        // الدالة دي هي اللي بتخلي الموبايل يدخل جروب اللايف!
        public async Task JoinCourseGroup(string courseId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, courseId);
        }

        // الدالة دي بتخرجه لما بيقفل الشاشة
        public async Task LeaveCourseGroup(string courseId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, courseId);
        }
    }
}