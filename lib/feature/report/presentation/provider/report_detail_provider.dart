import 'package:falletter_mobile_admin/core/network/dio.dart';
import 'package:falletter_mobile_admin/core/network/report_api.dart';
import 'package:falletter_mobile_admin/feature/report/data/repository/report_repository.dart';
import 'package:falletter_mobile_admin/feature/report/domain/model/report_detail.dart';
import 'package:falletter_mobile_admin/feature/students/presentation/provider/students_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportApiProvider = Provider<ReportApi>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return ReportApi(dio);
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(
    api: ref.watch(reportApiProvider),
    userApi: ref.watch(adminUserApiProvider),
  );
});

/// 처리 상태별 신고 목록
final reportListProvider = FutureProvider.autoDispose
    .family<List<ReportDetail>, ReportStatus>((ref, status) {
      return ref.watch(reportRepositoryProvider).fetchReports(status: status);
    });

/// 신고 상세. 목록에서 받은 [ReportDetail]을 초기 상태로 사용한다.
final reportDetailProvider = StateNotifierProvider.autoDispose
    .family<ReportDetailNotifier, ReportDetail, ReportDetail>(
      (ref, report) => ReportDetailNotifier(ref, report),
    );

class ReportDetailNotifier extends StateNotifier<ReportDetail> {
  ReportDetailNotifier(this._ref, super.state);

  final Ref _ref;
  bool _isUpdating = false;

  Future<void> reject() => _updateStatus(ReportStatus.rejected);

  Future<void> complete() => _updateStatus(ReportStatus.completed);

  Future<void> _updateStatus(ReportStatus status) async {
    if (_isUpdating) return;
    _isUpdating = true;
    try {
      await _ref
          .read(reportRepositoryProvider)
          .updateStatus(reportId: state.id, status: status);
      _ref.invalidate(reportListProvider);
      if (!mounted) return;
      state = state.copyWith(status: status, checkedAt: DateTime.now());
    } finally {
      _isUpdating = false;
    }
  }
}
