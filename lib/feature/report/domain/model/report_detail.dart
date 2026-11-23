enum ReportType {
  community(contentLabel: '신고 글'),
  letter(contentLabel: '레터 내용');

  const ReportType({required this.contentLabel});

  final String contentLabel;
}

enum ReportStatus {
  pending(resultMessage: null),
  rejected(resultMessage: '반려된 요청입니다'),
  completed(resultMessage: '처리된 요청입니다');

  const ReportStatus({required this.resultMessage});

  final String? resultMessage;
}

class ReportDetail {
  final int id;
  final ReportType type;
  final ReportStatus status;
  final String reporter;
  final String target;

  final List<String> contentMeta;
  final String content;
  final String reason;

  const ReportDetail({
    required this.id,
    required this.type,
    required this.status,
    required this.reporter,
    required this.target,
    required this.contentMeta,
    required this.content,
    required this.reason,
  });

  ReportDetail copyWith({ReportStatus? status}) {
    return ReportDetail(
      id: id,
      type: type,
      status: status ?? this.status,
      reporter: reporter,
      target: target,
      contentMeta: contentMeta,
      content: content,
      reason: reason,
    );
  }
}
