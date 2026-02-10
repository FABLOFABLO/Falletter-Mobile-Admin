import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostMark {
  final bool warned;
  final bool banned;

  const PostMark({this.warned = false, this.banned = false});

  PostMark copyWith({bool? warned, bool? banned}) =>
      PostMark(warned: warned ?? this.warned, banned: banned ?? this.banned);
}

class CommentMark {
  final bool warned;
  final bool banned;
  final bool deletedByAdmin;

  const CommentMark({
    this.warned = false,
    this.banned = false,
    this.deletedByAdmin = false,
  });

  CommentMark copyWith({bool? warned, bool? banned, bool? deletedByAdmin}) =>
      CommentMark(
        warned: warned ?? this.warned,
        banned: banned ?? this.banned,
        deletedByAdmin: deletedByAdmin ?? this.deletedByAdmin,
      );
}

class CommunityMarksState {
  final Map<String, PostMark> postMarks;
  final Map<String, CommentMark> commentMarks;

  const CommunityMarksState({
    this.postMarks = const {},
    this.commentMarks = const {},
  });

  CommunityMarksState copyWith({
    Map<String, PostMark>? postMarks,
    Map<String, CommentMark>? commentMarks,
  }) {
    return CommunityMarksState(
      postMarks: postMarks ?? this.postMarks,
      commentMarks: commentMarks ?? this.commentMarks,
    );
  }
}

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
