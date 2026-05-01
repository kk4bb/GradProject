class Discussion {
  final int id;
  final String title;
  final int postCount;

  Discussion({
    required this.id,
    required this.title,
    required this.postCount,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      postCount: json['postCount'] ?? 0,
    );
  }
}

class Post {
  final int id;
  final String authorName;
  final String content;
  final int commentCount;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.authorName,
    required this.content,
    required this.commentCount,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      authorName: json['authorName'] ?? '',
      content: json['content'] ?? '',
      commentCount: json['commentCount'] ?? 0,
      comments: (json['comments'] as List?)
              ?.map((e) => Comment.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Comment {
  final int id;
  final String authorName;
  final String content;

  Comment({
    required this.id,
    required this.authorName,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      authorName: json['authorName'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
