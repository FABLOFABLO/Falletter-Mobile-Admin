class Notice {
  final int id;
  final String title;
  final String? content;
  final String authorName;
  final DateTime createdAt;

  const Notice({
    required this.id,
    required this.title,
    required this.authorName,
    required this.createdAt,
    this.content,
  });

  factory Notice.fromListJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      authorName: (json['author_name'] as String?) ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      content: null,
    );
  }

  factory Notice.fromDetailJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      content: (json['content'] as String?) ?? '',
      authorName: (json['author_name'] as String?) ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  String get preview {
    final t = (content ?? '').trim();
    if (t.isEmpty) return '';
    return t.length > 40 ? '${t.substring(0, 40)}...' : t;
  }

  String get teacherText {
    final name = authorName.trim();
    return '$name 선생님';
  }

  String timeText() {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }
}