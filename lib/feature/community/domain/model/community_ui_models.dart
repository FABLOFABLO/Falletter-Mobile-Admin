class PostUi {
  final String id;
  final int authorUserId;
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
    required this.authorUserId,
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
      authorUserId: authorUserId,
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
  final int authorUserId;
  final String author;
  final String timeText;
  final String content;
  final bool deletedByAdmin;
  final bool warned;
  final bool banned;

  const CommentUi({
    required this.id,
    required this.postId,
    required this.authorUserId,
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
      authorUserId: authorUserId,
      author: author,
      timeText: timeText,
      content: content,
      deletedByAdmin: deletedByAdmin ?? this.deletedByAdmin,
      warned: warned ?? this.warned,
      banned: banned ?? this.banned,
    );
  }
}

class PostDetailUi {
  final PostUi post;
  final List<CommentUi> comments;

  const PostDetailUi({required this.post, required this.comments});
}
