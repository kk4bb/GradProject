import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final int id;
  final String authorName;
  final String content;
  final String? authorAvatarUrl;

  const CommentEntity({required this.id, required this.authorName, required this.content, this.authorAvatarUrl});

  @override
  List<Object?> get props => [id, authorName, content, authorAvatarUrl];
}

class PostEntity extends Equatable {
  final int id;
  final String authorName;
  final String? authorAvatarUrl;
  final String content;
  final int commentCount;
  final bool isCorrect;
  final int votes;
  final String? approvedByRole;
  final DateTime? createdAt;
  final List<CommentEntity> comments;

  const PostEntity({
    required this.id,
    required this.authorName,
    this.authorAvatarUrl,
    required this.content,
    required this.commentCount,
    this.isCorrect = false,
    this.votes = 0,
    this.approvedByRole,
    this.createdAt,
    required this.comments,
  });

  PostEntity copyWith({bool? isCorrect, int? votes, String? approvedByRole}) => PostEntity(
        id: id,
        authorName: authorName,
        authorAvatarUrl: authorAvatarUrl,
        content: content,
        commentCount: commentCount,
        isCorrect: isCorrect ?? this.isCorrect,
        votes: votes ?? this.votes,
        approvedByRole: approvedByRole ?? this.approvedByRole,
        createdAt: createdAt,
        comments: comments,
      );

  @override
  List<Object?> get props => [id, authorName, authorAvatarUrl, content, commentCount, isCorrect, votes, approvedByRole, createdAt, comments];
}

class DiscussionEntity extends Equatable {
  final int id;
  final String title;
  final int postCount;
  final String status; // OPEN | CLOSED | RESOLVED
  final DateTime? createdAt;
  final String? authorName;
  final String? authorAvatarUrl;
  final String? content;

  const DiscussionEntity({
    required this.id,
    required this.title,
    required this.postCount,
    this.status = 'OPEN',
    this.createdAt,
    this.authorName,
    this.authorAvatarUrl,
    this.content,
  });

  @override
  List<Object?> get props => [id, title, postCount, status, createdAt, authorName, authorAvatarUrl, content];
}
