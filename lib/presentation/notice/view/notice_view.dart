import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/presentation/notice/provider/notice_provider.dart';
import 'package:falletter_mobile_admin/presentation/notice/widget/notice_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FalletterNoticeView extends ConsumerWidget {
  const FalletterNoticeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notices = ref.watch(noticeProvider).notices;

    return Scaffold(
      backgroundColor: FalletterColor.background,
      body: SafeArea(
        child: ListView.builder(
          itemCount: notices.length,
          itemBuilder: (context, index) {
            final item = notices[index];
            return NoticeItem(
              title: item.title,
              preview: item.preview,
              teacher: item.teacher,
              timeText: item.timeText,
              onTap: () {
                context.push(RouterPath.noticeDetail, extra: item);
              },
            );
          },
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
