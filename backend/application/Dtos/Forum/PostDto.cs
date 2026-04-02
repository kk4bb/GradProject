using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Forum
{
    public class PostDto
    {
        public int Id { get; set; }
        public string AuthorName { get; set; }
        public string Content { get; set; }
        public int CommentCount { get; set; }
        public List<CommentDto> Comments { get; set; }
    }
}
