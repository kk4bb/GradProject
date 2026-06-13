using CampusConnect.Application.Dtos.Forum;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface IForumService
    {
        Task<List<DiscussionDto>> GetDiscussionsByCourseAsync(int courseId, string userId, string role);
        Task<List<PostDto>> GetPostsByDiscussionAsync(int discussionId, string userId, string role);
        Task<int> CreatePostAsync(int discussionId, PostCreateDto post, string userId, string role, string authorName, string? authorAvatarUrl);
        Task<int> CreateCommentAsync(int postId, CommentCreateDto comment, string userId, string role);
        Task<int> CreateDiscussionAsync(int courseId, CreateDiscussionDto dto, string userId, string authorName, string? authorAvatarUrl);
        Task MarkPostAsCorrectAsync(int postId, string userId, string role);
        Task VotePostAsync(int postId, bool isUpvote, string userId);
        Task UpdateDiscussionStatusAsync(int discussionId, string status, string userId);
    }
}
