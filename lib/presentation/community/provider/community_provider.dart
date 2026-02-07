import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostUi {
  final String id;
  final String title;
  final String preview;
  final String author;
  final String timeText;
  final int commentCount;
  final bool deletedByAdmin;
  final bool warned;
  final bool banned;

  const PostUi({
    required this.id,
    required this.title,
    required this.preview,
    required this.author,
    required this.timeText,
    required this.commentCount,
    this.deletedByAdmin = false,
    this.warned = false,
    this.banned = false,
  });

  PostUi copyWith({bool? deletedByAdmin, bool? warned, bool? banned}) {
    return PostUi(
      id: id,
      title: title,
      preview: preview,
      author: author,
      timeText: timeText,
      commentCount: commentCount,
      deletedByAdmin: deletedByAdmin ?? this.deletedByAdmin,
      warned: warned ?? this.warned,
      banned: banned ?? this.banned,
    );
  }
}

class CommentUi {
  final String id;
  final String postId;
  final String author;
  final String timeText;
  final String content;
  final bool deletedByAdmin;
  final bool warned;
  final bool banned;

  const CommentUi({
    required this.id,
    required this.postId,
    required this.author,
    required this.timeText,
    required this.content,
    this.deletedByAdmin = false,
    this.warned = false,
    this.banned = false,
  });

  CommentUi copyWith({bool? deletedByAdmin, bool? warned, bool? banned}) {
    return CommentUi(
      id: id,
      postId: postId,
      author: author,
      timeText: timeText,
      content: content,
      deletedByAdmin: deletedByAdmin ?? this.deletedByAdmin,
      warned: warned ?? this.warned,
      banned: banned ?? this.banned,
    );
  }
}

class CommunityState {
  final List<PostUi> posts;
  final Map<String, List<CommentUi>> comments;

  const CommunityState({required this.posts, required this.comments});

  CommunityState copyWith({
    List<PostUi>? posts,
    Map<String, List<CommentUi>>? comments,
  }) {
    return CommunityState(
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
    );
  }
}

class CommunityNotifier extends StateNotifier<CommunityState> {
  CommunityNotifier() : super(CommunityState(posts: [], comments: {})) {
    _initializePosts();
  }

  void _initializePosts() {
    final posts = List.generate(
      8,
      (i) => PostUi(
        id: 'post_$i',
        title: 'Title $i',
        preview: 'Text content...',
        author: '1411 이승현',
        timeText: '45분전',
        commentCount: 10,
      ),
    );

    final comments = <String, List<CommentUi>>{};
    for (var post in posts) {
      comments[post.id] = List.generate(
        10,
        (i) => CommentUi(
          id: 'comment_${post.id}_$i',
          postId: post.id,
          author: '댓글 작성자 $i',
          timeText: '10분전',
          content: '댓글 내용입니다.',
        ),
      );
    }

    state = CommunityState(posts: posts, comments: comments);
  }

  void updatePost(
    String postId, {
    bool? deletedByAdmin,
    bool? warned,
    bool? banned,
  }) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          deletedByAdmin: deletedByAdmin,
          warned: warned,
          banned: banned,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

  void updateComment(
    String postId,
    String commentId, {
    bool? deletedByAdmin,
    bool? warned,
    bool? banned,
  }) {
    final postComments = state.comments[postId];
    if (postComments == null) return;

    final updatedComments = postComments.map((comment) {
      if (comment.id == commentId) {
        return comment.copyWith(
          deletedByAdmin: deletedByAdmin,
          warned: warned,
          banned: banned,
        );
      }
      return comment;
    }).toList();

    final newCommentsMap = Map<String, List<CommentUi>>.from(state.comments);
    newCommentsMap[postId] = updatedComments;

    state = state.copyWith(comments: newCommentsMap);
  }

  List<CommentUi> getComments(String postId) {
    return state.comments[postId] ?? [];
  }

  PostUi? getPost(String postId) {
    try {
      return state.posts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }
}

final communityProvider =
    StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
      return CommunityNotifier();
    });
