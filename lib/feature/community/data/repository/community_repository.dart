import 'package:falletter_mobile_admin/core/util/date_format.dart';
import 'package:falletter_mobile_admin/core/network/community_api.dart';
import 'package:falletter_mobile_admin/feature/community/domain/model/community_marks_models.dart';
import 'package:falletter_mobile_admin/feature/community/domain/model/community_ui_models.dart';

class CommunityRepository {
  final CommunityApi api;

  CommunityRepository({required this.api});

  Future<List<PostUi>> fetchPosts({required CommunityMarksState marks}) async {
    final raw = await api.fetchPostsRaw();

    return raw.map((json) {
      final author = (json['author'] as Map).cast<String, dynamic>();
      final postId = (json['id'] as int).toString();
      final mark = marks.postMarks[postId];

      final cc = json['commentCount'];
      final commentCount = cc is int ? cc : (cc is num ? cc.toInt() : 0);

      return PostUi(
        id: postId,
        title: json['title'] as String,
        preview: json['content'] as String,
        author: author['name'] as String,
        authorUserId: author['userId'] as int,
        timeText: DateFormatter.mmdd(
          DateTime.parse(json['createdAt'] as String),
        ),
        commentCount: commentCount,
        deletedByAdmin: json['isDeleted'] as bool,
        warned: mark?.warned ?? false,
        banned: mark?.banned ?? false,
      );
    }).toList();
  }

  Future<PostDetailUi> fetchPostDetail({
    required String postId,
    required CommunityMarksState marks,
  }) async {
    final json = await api.fetchPostDetailRaw(postId);

    final author = (json['author'] as Map).cast<String, dynamic>();
    final postMark = marks.postMarks[postId];

    final post = PostUi(
      id: (json['id'] as int).toString(),
      title: json['title'] as String,
      preview: json['content'] as String,
      author: author['name'] as String,
      authorUserId: author['userId'] as int,
      timeText: DateFormatter.mmdd(DateTime.parse(json['createdAt'] as String)),
      commentCount: (json['comment'] as List?)?.length ?? 0,
      deletedByAdmin: json['isDeleted'] as bool,
      warned: postMark?.warned ?? false,
      banned: postMark?.banned ?? false,
    );

    final commentsRaw = (json['comment'] as List?) ?? [];
    final comments = commentsRaw.map((c) {
      final cm = (c as Map).cast<String, dynamic>();
      final user = (cm['user'] as Map).cast<String, dynamic>();

      final commentId = (cm['commentId'] as int).toString();
      final key = '$postId:$commentId';
      final cMark = marks.commentMarks[key];

      return CommentUi(
        id: commentId,
        postId: postId,
        authorUserId: user['userId'] as int,
        author: user['name'] as String,
        content: cm['comment'] as String,
        timeText: DateFormatter.mmdd(DateTime.parse(cm['createdAt'] as String)),
        deletedByAdmin: cMark?.deletedByAdmin ?? false,
        warned: cMark?.warned ?? false,
        banned: cMark?.banned ?? false,
      );
    }).toList();

    return PostDetailUi(post: post, comments: comments);
  }
}
