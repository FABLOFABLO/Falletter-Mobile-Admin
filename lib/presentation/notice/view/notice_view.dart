import 'dart:async';

import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/presentation/notice/provider/notice_provider.dart';
import 'package:falletter_mobile_admin/presentation/notice/widget/notice_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FalletterNoticeView extends ConsumerStatefulWidget {
  const FalletterNoticeView({super.key});

  @override
  ConsumerState<FalletterNoticeView> createState() =>
      _FalletterNoticeViewState();
}

class _FalletterNoticeViewState extends ConsumerState<FalletterNoticeView> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshNotices();
    });

    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      _refreshNotices();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshNotices() async {
    try {
      await ref.read(noticeProvider.notifier).fetchNotices();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noticeProvider);

    return Scaffold(
      backgroundColor: FalletterColor.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: FalletterColor.black,
          backgroundColor: FalletterColor.middleWhite,
          strokeWidth: 2.5,
          displacement: 28,
          edgeOffset: 8,
          onRefresh: _refreshNotices,
          child: state.isLoading
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 260),
                    Center(child: CircularProgressIndicator()),
                  ],
                )
              : (state.notices.isEmpty)
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 260),
                    Center(child: Text('공지사항이 없습니다.', style: FalletterTextStyle.body2,)),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.notices.length,
                  itemBuilder: (context, index) {
                    final item = state.notices[index];
                    return NoticeItem(
                      title: item.title,
                      teacher: item.teacherText,
                      timeText: item.timeText(),
                      preview: item.preview,
                      onTap: () {
                        context.push(RouterPath.noticeDetail, extra: item.id);
                      },
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 0,
        backgroundColor: Colors.black,
        onPressed: () => context.push(RouterPath.noticeWrite),
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
}
