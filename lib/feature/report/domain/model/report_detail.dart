enum ReportType {
  community(apiValue: 'COMMUNITY', contentLabel: '신고 글'),
  letter(apiValue: 'LETTER', contentLabel: '레터 내용');

  const ReportType({required this.apiValue, required this.contentLabel});

  final String apiValue;
  final String contentLabel;

  static ReportType fromApi(String? value) => ReportType.values.firstWhere(
    (e) => e.apiValue == value,
    orElse: () => ReportType.community,
  );
}

enum ReportStatus {
  pending(apiValue: 'PENDING', resultMessage: null),
  rejected(apiValue: 'REJECTED', resultMessage: '반려된 요청입니다'),
  completed(apiValue: 'COMPLETED', resultMessage: '처리된 요청입니다');

  const ReportStatus({required this.apiValue, required this.resultMessage});

  final String apiValue;
  final String? resultMessage;

  static ReportStatus fromApi(String? value) => ReportStatus.values.firstWhere(
    (e) => e.apiValue == value,
    orElse: () => ReportStatus.pending,
  );
}

class ReportDetail {
  final int id;
  final ReportType type;
  final ReportStatus status;

  final int reporterId;
  final int targetId;
  final int contentId;

  /// 화면 표시용 "학번 이름" (조회 실패 시 ID)
  final String reporter;
  final String target;

  final List<String> contentMeta;
  final String content;
  final String reason;

  final DateTime createdAt;
  final DateTime contentCreatedAt;
  final DateTime? checkedAt;

  const ReportDetail({
    required this.id,
    required this.type,
    required this.status,
    required this.reporterId,
    required this.targetId,
    required this.contentId,
    required this.reporter,
    required this.target,
    required this.contentMeta,
    required this.content,
    required this.reason,
    required this.createdAt,
    required this.contentCreatedAt,
    this.checkedAt,
  });

  ReportDetail copyWith({ReportStatus? status, DateTime? checkedAt}) {
    return ReportDetail(
      id: id,
      type: type,
      status: status ?? this.status,
      reporterId: reporterId,
      targetId: targetId,
      contentId: contentId,
      reporter: reporter,
      target: target,
      contentMeta: contentMeta,
      content: content,
      reason: reason,
      createdAt: createdAt,
      contentCreatedAt: contentCreatedAt,
      checkedAt: checkedAt ?? this.checkedAt,
    );
  }
}
