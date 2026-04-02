using CampusConnect.Application.Dtos.Forum;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IForumService
    {
        Task<List<DiscussionDto>> GetDiscussionsByCourseAsync(int courseId, string userId);
        Task<List<PostDto>> GetPostsByDiscussionAsync(int discussionId, string userId);
        Task<int> CreatePostAsync(int discussionId, PostCreateDto post, string userId);
        Task<int> CreateCommentAsync(int postId, CommentCreateDto comment, string userId);
        Task<int> CreateDiscussionAsync(int courseId, string title, string userId);
    }
}
