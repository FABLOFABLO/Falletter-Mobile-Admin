import 'package:falletter_mobile_admin/core/network/admin_user_api.dart';
import 'package:falletter_mobile_admin/core/network/report_api.dart';
import 'package:falletter_mobile_admin/core/util/date_format.dart';
import 'package:falletter_mobile_admin/feature/report/domain/model/report_detail.dart';

class ReportRepository {
  final ReportApi api;
  final AdminUserApi userApi;

  ReportRepository({required this.api, required this.userApi});

  Future<List<ReportDetail>> fetchReports({ReportStatus? status}) async {

    final raw = await api.fetchReportsRaw(status: status?.apiValue);

    // 신고 응답에는 사용자 ID만 있어서, 화면 표시용 "학번 이름"을 따로 조회한다.
    final userIds = <int>{
      for (final json in raw) ...[
        (json['reporterId'] as num).toInt(),
        (json['reportedId'] as num).toInt(),
      ],
    };
    final names = await _fetchUserLabels(userIds);

    final reports = raw.map((json) {
      final reporterId = (json['reporterId'] as num).toInt();
      final targetId = (json['reportedId'] as num).toInt();
      final type = ReportType.fromApi(json['contentType'] as String?);
      final contentCreatedAt = DateTime.parse(
        json['contentCreatedAt'] as String,
      );
      final target = names[targetId] ?? '$targetId';
      final checkedAt = json['checkedAt'] as String?;

      return ReportDetail(
        id: (json['id'] as num).toInt(),
        type: type,
        status: ReportStatus.fromApi(json['status'] as String?),
        reporterId: reporterId,
        targetId: targetId,
        contentId: (json['contentId'] as num).toInt(),
        reporter: names[reporterId] ?? '$reporterId',
        target: target,
        contentMeta: switch (type) {
          ReportType.community => [
            target,
            DateFormatter.relative(contentCreatedAt),
          ],
          ReportType.letter => ['${DateFormatter.md(contentCreatedAt)} 도착'],
        },
        content: (json['content'] ?? '') as String,
        reason: (json['reason'] ?? '') as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        contentCreatedAt: contentCreatedAt,
        checkedAt: checkedAt == null ? null : DateTime.parse(checkedAt),
      );
    }).toList();

    reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reports;
  }

  Future<void> updateStatus({
    required int reportId,
    required ReportStatus status,
  }) {
    return api.updateReportStatus(reportId: reportId, status: status.apiValue);
  }

  Future<Map<int, String>> _fetchUserLabels(Set<int> userIds) async {
    final entries = await Future.wait(
      userIds.map((id) async {
        try {
          final json = await userApi.fetchStudentDetailRaw(id);
          final schoolNumber = (json['schoolNumber'] ?? '') as String;
          final name = (json['name'] ?? '') as String;
          return MapEntry(id, '$schoolNumber $name'.trim());
        } catch (_) {
          return null;
        }
      }),
    );
    return Map.fromEntries(entries.whereType<MapEntry<int, String>>());
  }
}
