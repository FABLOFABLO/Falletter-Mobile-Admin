class StudentSummary {
  final int id;
  final String schoolNumber;
  final String name;
  final String? profileImage;
  final String gender;
  final int warningCount;

  const StudentSummary({
    required this.id,
    required this.schoolNumber,
    required this.name,
    this.profileImage,
    required this.gender,
    required this.warningCount,
});

  factory StudentSummary.fromJson(Map<String, dynamic> json) {
    return StudentSummary(
      id:(json ['id'] as num).toInt(),
      schoolNumber: (json ['school_number'] ?? '') as String,
      name: (json ['name'] ?? '') as String,
      profileImage: (json ['profile_image']) as String?,
      gender: (json ['gender'] ?? '') as String,
      warningCount: (json ['warning_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class SuspendItem {
  final int id;
  final String type;
  final int days;
  final String reason;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  const SuspendItem({
    required this.id,
    required this.type,
    required this.days,
    required this.reason,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
});

  factory SuspendItem.fromJson(Map<String, dynamic> json) {
    DateTime parse(String? v) => v == null ? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.parse(v);
    return SuspendItem(
      id: (json ['id'] as num).toInt(),
      type: (json ['type'] ?? '') as String,
      days: (json ['days'] as num?)?.toInt() ?? 0,
      reason: (json ['reason'] ?? '') as String,
      startDate: parse(json ['start_date'] as String?),
      endDate: parse(json ['end_date'] as String?),
      createdAt: parse(json ['created_at'] as String?),
    );
  }
}

class StudentDetail {
  final int id;
  final String schoolNumber;
  final String name;
  final String? profileImage;
  final String gender;
  final int warningCount;
  final List<SuspendItem> suspends;

  const StudentDetail({
    required this.id,
    required this.schoolNumber,
    required this.name,
    required this.profileImage,
    required this.gender,
    required this.warningCount,
    required this.suspends,
  });

  factory StudentDetail.fromJson(Map<String, dynamic> json) {
    final suspendsJson = (json['suspends'] as List?) ?? const [];
    return StudentDetail(
      id: (json['id'] as num).toInt(),
      schoolNumber: (json['school_number'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      profileImage: json['profile_image'] as String?,
      gender: (json['gender'] ?? '') as String,
      warningCount: (json['warning_count'] as num?)?.toInt() ?? 0,
      suspends: suspendsJson
          .whereType<Map<String, dynamic>>()
          .map(SuspendItem.fromJson)
          .toList(),
    );
  }
}

class PageResponse<T> {
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;
  final List<T> content;

  const PageResponse({
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
    required this.content,
  });

  factory PageResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    final list = (json['content'] as List?) ?? const [];
    return PageResponse(
      totalElements: (json['total_elements'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 0,
      number: (json['number'] as num?)?.toInt() ?? 0,
      content: list.whereType<Map<String, dynamic>>().map(fromJsonT).toList(),
    );
  }
}