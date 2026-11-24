import 'package:falletter_mobile_admin/feature/report/domain/model/report_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: API 연동 시 서버에서 받은 신고 목록 상태로 대체
final reportStatusesProvider = StateProvider<Map<int, ReportStatus>>(
  (ref) => {for (final id in dummyReportIds) id: _dummyReportStatusOf(id)},
);

final reportDetailProvider = StateNotifierProvider.autoDispose
    .family<ReportDetailNotifier, ReportDetail, int>((ref, reportId) {
      final status =
          ref.read(reportStatusesProvider)[reportId] ?? ReportStatus.pending;
      return ReportDetailNotifier(
        ref,
        _dummyReport(reportId).copyWith(status: status),
      );
    });

class ReportDetailNotifier extends StateNotifier<ReportDetail> {
  ReportDetailNotifier(this._ref, super.state);

  final Ref _ref;

  // TODO: API 연동 시 서버 요청 후 상태 갱신
  void reject() => _updateStatus(ReportStatus.rejected);

  void complete() => _updateStatus(ReportStatus.completed);

  void _updateStatus(ReportStatus status) {
    state = state.copyWith(status: status);
    _ref
        .read(reportStatusesProvider.notifier)
        .update((statuses) => {...statuses, state.id: status});
  }
}

// TODO: API 스펙 확정 후 제거
const dummyReportIds = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

// TODO: API 스펙 확정 후 제거
ReportType dummyReportTypeOf(int id) =>
    id.isEven ? ReportType.community : ReportType.letter;

// TODO: API 스펙 확정 후 제거
ReportStatus _dummyReportStatusOf(int id) {
  if (id < 6) return ReportStatus.pending;
  if (id < 8) return ReportStatus.rejected;
  return ReportStatus.completed;
}

// TODO: API 스펙 확정 후 제거
ReportDetail _dummyReport(int id) {
  if (dummyReportTypeOf(id) == ReportType.community) {
    return ReportDetail(
      id: id,
      type: ReportType.community,
      status: ReportStatus.pending,
      reporter: '1401 김수인',
      target: '2100 이지아',
      contentMeta: const ['2100 이지아', '28분전'],
      content: '1교시 체육이 국어로 변경됩니다~',
      reason: '1교시 변경 안됐잖아요 ㅡㅡ 국어인줄알고 도서관갔는데 현태쌤한테 한 소리 들었습니다. 책임지세요.',
    );
  }
  return ReportDetail(
    id: id,
    type: ReportType.letter,
    status: ReportStatus.pending,
    reporter: '1401 김수인',
    target: '2100 이지아',
    contentMeta: const ['3월 14일 도착'],
    content:
        'Lorem ipsum mi fringilla massa at purus fermentum lectus rhoncus lectus rhoncus nunc sit nam ut et nunc lectus elit elit urna leo placerat quis elit ipsum sed amet nec nunc in viverra leo vitae odio habitant quis sed auctor.',
    reason: '영어가 너무 많아서 뭐라 하는지 모르겠네요',
  );
}
