using System;
using System.Collections.Generic;

namespace CampusConnect.Application.Dtos.Forum
{
    public class PostDto
    {
        public int Id { get; set; }
        public string AuthorName { get; set; }
        public string? AuthorAvatarUrl { get; set; }
        public string Content { get; set; }
        public int CommentCount { get; set; }
        public bool IsCorrect { get; set; }
        public int Votes { get; set; }
        public string ApprovedByRole { get; set; }
        public string CreatedAt { get; set; }
        public List<CommentDto> Comments { get; set; }
    }
}
