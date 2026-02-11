class LetterUnpassed {
  final int id;
  final bool isPassed;
  final int receptionId;
  final int senderId;
  final DateTime createdAt;

  const LetterUnpassed({
    required this.id,
    required this.isPassed,
    required this.receptionId,
    required this.senderId,
    required this.createdAt,
  });

  factory LetterUnpassed.fromJson(Map<String, dynamic> json) {
    return LetterUnpassed(
      id: json['id'] as int,
      isPassed: json['is_passed'] as bool,
      receptionId: json['reception_id'] as int,
      senderId: json['sender_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class LetterUnpassedDetail {
  final int id;
  final String content;
  final bool isPassed;
  final int receptionId;
  final int senderId;
  final DateTime createdAt;

  const LetterUnpassedDetail({
    required this.id,
    required this.content,
    required this.isPassed,
    required this.receptionId,
    required this.senderId,
    required this.createdAt,
  });

  factory LetterUnpassedDetail.fromJson(Map<String, dynamic> json) {
    return LetterUnpassedDetail(
      id: json['id'] as int,
      content: (json['content'] as String?) ?? '',
      isPassed: json['is_passed'] as bool,
      receptionId: json['reception_id'] as int,
      senderId: json['sender_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
