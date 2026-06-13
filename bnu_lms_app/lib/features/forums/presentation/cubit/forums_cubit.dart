import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/remote/forums_remote_data_source.dart';
import '../../domain/entities/forum_entities.dart';
import '../../../../shared/services/signalr_service.dart';
import 'dart:async';
import 'forums_state.dart';

class ForumsCubit extends Cubit<ForumsState> {
  final ForumsRemoteDataSource _dataSource;
  final SignalRService _signalRService;
  final Map<int, int> _userVotes = {};
  
  StreamSubscription? _newDiscussionSub;
  StreamSubscription? _newPostSub;
  StreamSubscription? _voteUpdateSub;
  StreamSubscription? _correctAnswerSub;

  ForumsCubit(this._dataSource, this._signalRService) : super(const ForumsInitial());

  // ─── SignalR ─────────────────────────────────────────────────────────────

  Future<void> initSignalR() async {
    // Rely on SignalRService which is authenticated and shared.
    // The streams are broadcast, so we can just listen.
    
    _newDiscussionSub?.cancel();
    _newDiscussionSub = _signalRService.newDiscussionStream.listen((data) {
      try {
        final newDiscussion = DiscussionEntity(
          id: data['id'] as int,
          title: data['title'] as String,
          postCount: data['postCount'] as int? ?? 0,
          status: data['status'] as String? ?? 'OPEN',
          createdAt: DateTime.tryParse(data['createdAt'] as String? ?? '')?.toLocal(),
          authorName: data['authorName'] as String? ?? 'Unknown',
          authorAvatarUrl: data['authorAvatarUrl'] as String?,
          content: data['content'] as String?,
        );

        final updatedDiscussions = List<DiscussionEntity>.from([newDiscussion, ...state.discussions]);
        if (state is DiscussionsLoaded) {
          emit(DiscussionsLoaded(updatedDiscussions, timestamp: DateTime.now().millisecondsSinceEpoch));
        } else if (state is PostsLoaded) {
          final current = state as PostsLoaded;
          emit(PostsLoaded(
            discussions: updatedDiscussions,
            discussionId: current.discussionId,
            discussionTitle: current.discussionTitle,
            posts: List<PostEntity>.from(current.posts),
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ));
        }
      } catch (e) {
        
      }
    });

    _newPostSub?.cancel();
    _newPostSub = _signalRService.newPostStream.listen((data) {
      try {
        final discussionId = data['discussionId'] as int?;
        
        final newPost = PostEntity(
          id: data['id'] as int,
          authorName: data['authorName'] as String? ?? 'Unknown',
          authorAvatarUrl: data['authorAvatarUrl'] as String?,
          content: data['content'] as String,
          commentCount: data['commentCount'] as int? ?? 0,
          isCorrect: data['isCorrect'] as bool? ?? false,
          votes: data['votes'] as int? ?? 0,
          createdAt: DateTime.tryParse(data['createdAt'] as String? ?? '')?.toLocal(),
          approvedByRole: data['approvedByRole'] as String?,
          comments: const [],
        );

        final updatedDiscussions = List<DiscussionEntity>.from(state.discussions.map((d) {
          return d.id == discussionId ? DiscussionEntity(
            id: d.id, title: d.title, postCount: d.postCount + 1, status: d.status,
            createdAt: d.createdAt, authorName: d.authorName, authorAvatarUrl: d.authorAvatarUrl, content: d.content
          ) : d;
        }));

        if (state is PostsLoaded) {
          final current = state as PostsLoaded;
          if (current.discussionId == discussionId) {
            final newPosts = List<PostEntity>.from(current.posts)..add(newPost);
            emit(PostsLoaded(
              discussions: updatedDiscussions,
              discussionId: current.discussionId,
              discussionTitle: current.discussionTitle,
              posts: newPosts,
              timestamp: DateTime.now().millisecondsSinceEpoch,
            ));
            return;
          }
        }
        
        if (state is DiscussionsLoaded) {
          emit(DiscussionsLoaded(updatedDiscussions, timestamp: DateTime.now().millisecondsSinceEpoch));
        }
      } catch (e) {
        
      }
    });

    _voteUpdateSub?.cancel();
    _voteUpdateSub = _signalRService.voteUpdateStream.listen((data) {
      try {
        final postId = data['id'] as int;
        final votes  = data['votes'] as int;

        if (state is PostsLoaded) {
          final current = state as PostsLoaded;
          final newPosts = List<PostEntity>.from(
            current.posts.map((p) => p.id == postId ? p.copyWith(votes: votes) : p)
          );
          emit(PostsLoaded(
            discussions: List<DiscussionEntity>.from(state.discussions),
            discussionId: current.discussionId,
            discussionTitle: current.discussionTitle,
            posts: newPosts,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ));
        }
      } catch (e) {
        
      }
    });

    _correctAnswerSub?.cancel();
    _correctAnswerSub = _signalRService.correctAnswerStream.listen((data) {
      try {
        final postId        = data['id'] as int;
        final isCorrect     = data['isCorrect'] as bool? ?? true;
        final approvedByRole = data['approvedByRole'] as String?;

        if (state is PostsLoaded) {
          final current  = state as PostsLoaded;
          final newPosts = List<PostEntity>.from(
            current.posts.map((p) => p.id == postId
                ? p.copyWith(isCorrect: isCorrect, approvedByRole: approvedByRole)
                : p)
          );
          emit(PostsLoaded(
            discussions: List<DiscussionEntity>.from(state.discussions),
            discussionId: current.discussionId,
            discussionTitle: current.discussionTitle,
            posts: newPosts,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ));
        }
      } catch (e) {
        
      }
    });
  }

  Future<void> closeSignalR() async {
    await _newDiscussionSub?.cancel();
    await _newPostSub?.cancel();
    await _voteUpdateSub?.cancel();
    await _correctAnswerSub?.cancel();
  }

  @override
  Future<void> close() {
    closeSignalR();
    return super.close();
  }

  // ─── Discussions ─────────────────────────────────────────────────────────

  Future<void> loadDiscussions(int courseId) async {
    // ضفنا السطر ده عشان نتأكد إننا دخلنا الجروب الصح فوراً
    await _signalRService.joinCourse(courseId);

    emit(ForumsLoading(discussions: state.discussions));
    try {
      final discussions = await _dataSource.getDiscussions(courseId);
      emit(DiscussionsLoaded(discussions, timestamp: DateTime.now().millisecondsSinceEpoch));
    } catch (e) {
      emit(ForumsError(e.toString(), discussions: state.discussions));
    }
  }

  Future<void> loadPosts(int discussionId, String discussionTitle) async {
    // مفيش تغيير كبير هنا، بس اتأكد إنك باعت الـ courseId لو متاح
    emit(ForumsLoading(discussions: state.discussions));
    try {
      final posts = await _dataSource.getPosts(discussionId);
      emit(PostsLoaded(
        discussions: state.discussions,
        discussionId: discussionId,
        discussionTitle: discussionTitle,
        posts: posts,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    } catch (e) {
      emit(ForumsError(e.toString(), discussions: state.discussions));
    }
  }

  Future<void> createDiscussion(int courseId, String title, [String description = '']) async {
    final current = state;
    emit(ForumsActionLoading(discussions: state.discussions));
    try {
      await _dataSource.createDiscussion(courseId, title, description);
      await loadDiscussions(courseId);
    } catch (e) {
      if (current is DiscussionsLoaded) {
        emit(DiscussionsLoaded(current.discussions, timestamp: DateTime.now().millisecondsSinceEpoch));
      }
      emit(ForumsError(e.toString(), discussions: state.discussions));
    }
  }

  Future<void> updateDiscussionStatus(int discussionId, String status, int courseId) async {
    final current = state;
    emit(ForumsActionLoading(discussions: state.discussions));
    try {
      await _dataSource.updateDiscussionStatus(discussionId, status);
      await loadDiscussions(courseId);
    } catch (e) {
      if (current is DiscussionsLoaded) emit(current);
      emit(ForumsError(e.toString(), discussions: state.discussions));
    }
  }

  // ─── Posts ────────────────────────────────────────────────────────────────



  Future<void> createPost(int discussionId, String discussionTitle, String content) async {
    final current = state;
    emit(ForumsActionLoading(discussions: state.discussions));
    try {
      await _dataSource.createPost(discussionId, content);
      await loadPosts(discussionId, discussionTitle);
    } catch (e) {
      if (current is PostsLoaded) {
        emit(PostsLoaded(
          discussions: current.discussions,
          discussionId: current.discussionId,
          discussionTitle: current.discussionTitle,
          posts: current.posts,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));
      }
      emit(ForumsError(e.toString(), discussions: state.discussions));
    }
  }

  Future<void> createComment(
      int postId, int discussionId, String discussionTitle, String content) async {
    final current = state;
    emit(ForumsActionLoading(discussions: state.discussions));
    try {
      await _dataSource.createComment(postId, content);
      await loadPosts(discussionId, discussionTitle);
    } catch (e) {
      if (current is PostsLoaded) {
        emit(PostsLoaded(
          discussions: current.discussions,
          discussionId: current.discussionId,
          discussionTitle: current.discussionTitle,
          posts: current.posts,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));
      }
      emit(ForumsError(e.toString(), discussions: state.discussions));
    }
  }

  Future<void> markAsCorrect(
      int postId, int discussionId, String discussionTitle) async {
    // Optimistic update — flip the flag locally so UI responds instantly
    if (state is PostsLoaded) {
      final current = state as PostsLoaded;
      final updatedPosts = current.posts.map((p) {
        return p.id == postId ? p.copyWith(isCorrect: !p.isCorrect) : p;
      }).toList();
      emit(PostsLoaded(
        discussions: state.discussions,
        discussionId: current.discussionId,
        discussionTitle: current.discussionTitle,
        posts: updatedPosts,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }

    try {
      await _dataSource.markPostAsCorrect(postId);
      // Let SignalR handle the final confirmed state broadcast
    } catch (e) {
      // Rollback optimistic update on failure
      await loadPosts(discussionId, discussionTitle);
      emit(ForumsError(e.toString(), discussions: state.discussions));
    }
  }

  Future<void> votePost(
      int postId, bool isUpvote, int discussionId, String discussionTitle) async {
    final currentVote = _userVotes[postId] ?? 0;
    final int newVote = isUpvote ? 1 : -1;
    int voteDiff = 0;

    // Toggle logic: If user clicks the same vote again, it resets (undos).
    if (currentVote == newVote) {
      voteDiff = -newVote; // undo
      _userVotes.remove(postId);
    } else {
      voteDiff = newVote - currentVote;
      _userVotes[postId] = newVote;
    }

    if (state is PostsLoaded) {
      final current = state as PostsLoaded;
      final updatedPosts = current.posts.map((p) {
        if (p.id == postId) {
          final newCount = (p.votes + voteDiff).clamp(0, 999999);
          return p.copyWith(votes: newCount);
        }
        return p;
      }).toList();
      emit(PostsLoaded(
        discussions: state.discussions,
        discussionId: current.discussionId,
        discussionTitle: current.discussionTitle,
        posts: updatedPosts,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }

    try {
      await _dataSource.votePost(postId, isUpvote);
    } catch (e) {
      // Rollback on failure
      if (currentVote == 0) _userVotes.remove(postId);
      else _userVotes[postId] = currentVote;
      await loadPosts(discussionId, discussionTitle);
      emit(ForumsError(e.toString(), discussions: state.discussions));
    }
  }
}
