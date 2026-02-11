import 'package:falletter_mobile_admin/core/util/date_format.dart';
import 'package:falletter_mobile_admin/presentation/community/provider/community_marks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter_mobile_admin/core/network/dio.dart';
import 'package:falletter_mobile_admin/core/network/community_api.dart';

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

final communityApiProvider = Provider<CommunityApi>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return CommunityApi(dio);
});

final communityPostsProvider =
FutureProvider.autoDispose<List<PostUi>>((ref) async {
  final api = ref.watch(communityApiProvider);
  final marks = ref.watch(communityMarksProvider);
  final raw = await api.fetchPostsRaw();

  return raw.map((json) {
    final author = (json['author'] as Map).cast<String, dynamic>();
    final postId = (json['id'] as int).toString();
    final mark = marks.postMarks[postId];

    final cc = json['comment_count'];
    final commentCount = cc is int ? cc : (cc is num ? cc.toInt() : 0);

    return PostUi(
      id: postId,
      title: json['title'] as String,
      preview: json['content'] as String,
      author: author['name'] as String,
      authorUserId: author['user_id'] as int,
      timeText: DateFormatter.mmdd(DateTime.parse(json['created_at'] as String)),
      commentCount: commentCount,
      deletedByAdmin: json['is_deleted'] as bool,
      warned: mark?.warned ?? false,
      banned: mark?.banned ?? false,
    );
  }).toList();
});

/// GET /community/posts/{post-id}
final communityPostDetailProvider = FutureProvider.autoDispose
    .family<PostDetailUi, String>((ref, postId) async {
      final api = ref.watch(communityApiProvider);
      final marks = ref.watch(communityMarksProvider);
      final json = await api.fetchPostDetailRaw(postId);

      final author = (json['author'] as Map).cast<String, dynamic>();
      final postMark = marks.postMarks[postId];

      final post = PostUi(
        id: (json['id'] as int).toString(),
        title: json['title'] as String,
        preview: json['content'] as String,
        author: author['name'] as String,
        authorUserId: author['user_id'] as int,
        timeText: DateFormatter.mmdd(
          DateTime.parse(json['created_at'] as String),
        ),
        commentCount: (json['comment'] as List?)?.length ?? 0,
        deletedByAdmin: json['is_deleted'] as bool,
        warned: postMark?.warned ?? false,
        banned: postMark?.banned ?? false,
      );

      final commentsRaw = (json['comment'] as List?) ?? [];
      final comments = commentsRaw.map((c) {
        final cm = (c as Map).cast<String, dynamic>();
        final user = (cm['user'] as Map).cast<String, dynamic>();

        final commentId = (cm['comment_id'] as int).toString();
        final key = '$postId:$commentId';
        final cMark = marks.commentMarks[key];

        return CommentUi(
          id: commentId,
          postId: postId,
          authorUserId: user['user_id'] as int,
          author: user['name'] as String,
          content: cm['comment'] as String,
          timeText: DateFormatter.mmdd(
            DateTime.parse(cm['created_at'] as String),
          ),
          deletedByAdmin: cMark?.deletedByAdmin ?? false,
          warned: cMark?.warned ?? false,
          banned: cMark?.banned ?? false,
        );
      }).toList();

      return PostDetailUi(post: post, comments: comments);
    });
