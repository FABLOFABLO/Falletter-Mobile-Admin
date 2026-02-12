import 'package:falletter_mobile_admin/feature/community/presentation/domain/model/community_marks_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final communityMarksProvider =
StateNotifierProvider<CommunityMarksNotifier, CommunityMarksState>(
      (ref) => CommunityMarksNotifier(),
);

class CommunityMarksNotifier extends StateNotifier<CommunityMarksState> {
  CommunityMarksNotifier() : super(const CommunityMarksState());

  void markPostWarned(String postId, bool value) {
    final next = Map<String, PostMark>.from(state.postMarks);
    final prev = next[postId] ?? const PostMark();
    next[postId] = prev.copyWith(warned: value);
    state = state.copyWith(postMarks: next);
  }

  void markPostBanned(String postId, bool value) {
    final next = Map<String, PostMark>.from(state.postMarks);
    final prev = next[postId] ?? const PostMark();
    next[postId] = prev.copyWith(banned: value);
    state = state.copyWith(postMarks: next);
  }

  void markCommentWarned(String postId, String commentId, bool value) {
    final key = '$postId:$commentId';
    final next = Map<String, CommentMark>.from(state.commentMarks);
    final prev = next[key] ?? const CommentMark();
    next[key] = prev.copyWith(warned: value);
    state = state.copyWith(commentMarks: next);
  }

  void markCommentBanned(String postId, String commentId, bool value) {
    final key = '$postId:$commentId';
    final next = Map<String, CommentMark>.from(state.commentMarks);
    final prev = next[key] ?? const CommentMark();
    next[key] = prev.copyWith(banned: value);
    state = state.copyWith(commentMarks: next);
  }

  void markCommentDeletedByAdmin(String postId, String commentId, bool value) {
    final key = '$postId:$commentId';
    final next = Map<String, CommentMark>.from(state.commentMarks);
    final prev = next[key] ?? const CommentMark();
    next[key] = prev.copyWith(deletedByAdmin: value);
    state = state.copyWith(commentMarks: next);
  }
}