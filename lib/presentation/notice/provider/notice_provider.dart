import 'package:falletter_mobile_admin/presentation/notice/model/notice_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter_mobile_admin/core/network/dio.dart';
import 'package:falletter_mobile_admin/core/network/notice_api.dart';

final noticeApiProvider = Provider<NoticeApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return NoticeApi(dioClient.dio);
});

class NoticeState {
  final List<Notice> notices;
  final bool isLoading;
  final String? errorMessage;

  const NoticeState({
    this.notices = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  NoticeState copyWith({
    List<Notice>? notices,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NoticeState(
      notices: notices ?? this.notices,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class NoticeNotifier extends StateNotifier<NoticeState> {
  final Ref _ref;
  NoticeNotifier(this._ref) : super(const NoticeState()) {
    fetchNotices();
  }

  Future<void> fetchNotices() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final api = _ref.read(noticeApiProvider);
      final rawList = await api.fetchNoticesRaw();
      final listItems = rawList.map(Notice.fromListJson).toList();
      final filled = await Future.wait(
        listItems.map((n) async {
          try {
            final rawDetail = await api.fetchNoticeDetailRaw(n.id);
            final detail = Notice.fromDetailJson(rawDetail);

            return Notice(
              id: n.id,
              title: n.title,
              authorName: n.authorName,
              createdAt: n.createdAt,
              content: detail.content,
            );
          } catch (_) {
            return n;
          }
        }),
      );

      state = state.copyWith(notices: filled, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '$e');
    }
  }

  Future<Notice> fetchNoticeDetail(int id) async {
    final raw = await _ref.read(noticeApiProvider).fetchNoticeDetailRaw(id);
    final detail = Notice.fromDetailJson(raw);

    final fromList = state.notices.where((n) => n.id == id).toList();
    if (detail.authorName.trim().isEmpty && fromList.isNotEmpty) {
      return Notice(
        id: detail.id,
        title: detail.title,
        content: detail.content,
        authorName: fromList.first.authorName,
        createdAt: detail.createdAt,
      );
    }
    return detail;
  }

  Future<void> createNotice({
    required String title,
    required String content,
  }) async {
    await _ref.read(noticeApiProvider).createNotice(
      title: title.trim(),
      content: content.trim(),
    );

    await fetchNotices();
  }

  Future<void> deleteNotice(int id) async {
    await _ref.read(noticeApiProvider).deleteNotice(id);
    await fetchNotices();
  }
}

final noticeProvider = StateNotifierProvider<NoticeNotifier, NoticeState>((ref) {
  return NoticeNotifier(ref);
});