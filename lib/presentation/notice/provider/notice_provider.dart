import 'package:flutter_riverpod/flutter_riverpod.dart';

class Notice {
  final String id;
  final String title;
  final String content;
  final String teacher;
  final DateTime createdAt;

  const Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.teacher,
    required this.createdAt,
  });

  String get preview {
    final t = content.trim();
    if (t.isEmpty) return '';
    return t.length > 40 ? '${t.substring(0, 40)}...' : t;
  }

  String get timeText {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }
}

class NoticeState {
  final List<Notice> notices;

  const NoticeState({this.notices = const []});

  NoticeState copyWith({List<Notice>? notices}) {
    return NoticeState(notices: notices ?? this.notices);
  }
}

class NoticeNotifier extends StateNotifier<NoticeState> {
  NoticeNotifier() : super(const NoticeState()) {
    _seed();
  }

  void _seed() {
    if (state.notices.isNotEmpty) return;
    final now = DateTime.now();
    state = state.copyWith(
      notices: [],
    );
  }

  Notice addNotice({
    required String title,
    required String content,
    required String teacher,
  }) {
    final now = DateTime.now();
    final notice = Notice(
      id: now.microsecondsSinceEpoch.toString(),
      title: title.trim(),
      content: content.trim(),
      teacher: teacher.trim(),
      createdAt: now,
    );
    state = state.copyWith(notices: [notice, ...state.notices]);
    return notice;
  }

  Notice? findById(String id) {
    for (final n in state.notices) {
      if (n.id == id) return n;
    }
    return null;
  }

  void deleteById(String id) {
    state = state.copyWith(
      notices: state.notices.where((n) => n.id != id).toList(),
    );
  }

  void setNotices(List<Notice> notices) {
    state = state.copyWith(notices: notices);
  }

  void deleteNotice(Notice notice) {
    deleteById(notice.id);
  }
}

final noticeProvider = StateNotifierProvider<NoticeNotifier, NoticeState>((
  ref,
) {
  return NoticeNotifier();
});
