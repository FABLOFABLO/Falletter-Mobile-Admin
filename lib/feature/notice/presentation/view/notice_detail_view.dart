import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/card/detail_card.dart';
import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/feature/notice/presentation/provider/notice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NoticeMoreAction { delete }

class NoticeDetailView extends ConsumerStatefulWidget {
  final int noticeId;

  const NoticeDetailView({super.key, required this.noticeId});

  @override
  ConsumerState<NoticeDetailView> createState() => _NoticeDetailViewState();
}

class _NoticeDetailViewState extends ConsumerState<NoticeDetailView> {
  bool _isDeleted = false;

  void _openDeleteModal() {
    showDialog(
      context: context,
      builder: (_) => DefaultModal(
        model: DefaultModalUiModel.delete(),
        onConfirmDelete: () async {
          setState(() => _isDeleted = true);
          await ref.read(noticeProvider.notifier).deleteNotice(widget.noticeId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleted) {
      return Scaffold(
        backgroundColor: FalletterColor.background,
        body: SafeArea(
          child: Column(
            children: const [
              CustomAppBar(showBack: true),
              Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      );
    }

    final menuItems = MoreAction.buildItems<NoticeMoreAction>([
      MoreActionItem<NoticeMoreAction>(
        value: NoticeMoreAction.delete,
        text: '삭제',
        style: FalletterTextStyle.body3.copyWith(color: FalletterColor.red),
      ),
    ]);

    return FutureBuilder(
      future: ref
          .read(noticeProvider.notifier)
          .fetchNoticeDetail(widget.noticeId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FalletterColor.background,
            body: SafeArea(
              child: Column(
                children: const [
                  CustomAppBar(showBack: true),
                  Expanded(child: Center(child: CircularProgressIndicator())),
                ],
              ),
            ),
          );
        }

        final notice = snapshot.data!;

        return Scaffold(
          backgroundColor: FalletterColor.background,
          body: SafeArea(
            child: Column(
              children: [
                const CustomAppBar(showBack: true),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: DetailCard(
                      writer: notice.teacherText,
                      timeText: notice.timeText(),
                      title: notice.title,
                      content: (notice.content ?? ''),
                      menuItems: menuItems,
                      onMenuSelected: (value) {
                        if (value == NoticeMoreAction.delete) {
                          _openDeleteModal();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
