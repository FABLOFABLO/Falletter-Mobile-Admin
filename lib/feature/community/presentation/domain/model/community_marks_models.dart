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
