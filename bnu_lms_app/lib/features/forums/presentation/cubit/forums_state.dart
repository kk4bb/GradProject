import 'package:equatable/equatable.dart';
import '../../domain/entities/forum_entities.dart';

abstract class ForumsState extends Equatable {
  final List<DiscussionEntity> discussions;
  const ForumsState({this.discussions = const []});
  @override
  List<Object?> get props => [discussions];
}

class ForumsInitial extends ForumsState {
  const ForumsInitial() : super();
}

class ForumsLoading extends ForumsState {
  const ForumsLoading({super.discussions});
}

/// Discussions feed (list of topics) loaded
class DiscussionsLoaded extends ForumsState {
  final int timestamp;
  const DiscussionsLoaded(List<DiscussionEntity> discussions, {this.timestamp = 0})
      : super(discussions: discussions);
  @override
  List<Object?> get props => [discussions, timestamp];
}

/// Posts inside a specific discussion loaded
class PostsLoaded extends ForumsState {
  final int discussionId;
  final String discussionTitle;
  final List<PostEntity> posts;
  final int timestamp;

  const PostsLoaded({
    required super.discussions,
    required this.discussionId,
    required this.discussionTitle,
    required this.posts,
    this.timestamp = 0,
  });

  @override
  List<Object?> get props => [discussions, discussionId, discussionTitle, posts, timestamp];
}

class ForumsActionLoading extends ForumsState {
  const ForumsActionLoading({super.discussions});
}

class ForumsActionSuccess extends ForumsState {
  final String message;
  const ForumsActionSuccess(this.message, {super.discussions});
  @override
  List<Object?> get props => [discussions, message];
}

class ForumsError extends ForumsState {
  final String message;
  const ForumsError(this.message, {super.discussions});
  @override
  List<Object?> get props => [discussions, message];
}
