import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/card/detail_card.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

enum NoticeMoreAction { delete }

class NoticeDetailView extends StatelessWidget {
  final String writer;
  final String timeText;
  final String title;
  final String content;

  final VoidCallback? onDelete;

  const NoticeDetailView({
    super.key,
    required this.writer,
    required this.timeText,
    required this.title,
    required this.content,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = MoreAction.buildItems<NoticeMoreAction>([
      MoreActionItem<NoticeMoreAction>(
        value: NoticeMoreAction.delete,
        text: '삭제',
        style: FalletterTextStyle.body3.copyWith(color: FalletterColor.red),
        showDivider: false,
      ),
    ]);

    return Scaffold(
      backgroundColor: FalletterColor.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(showBack: true),
            DetailCard(
              writer: writer,
              timeText: timeText,
              title: title,
              content: content,
              menuItems: menuItems,
              onMenuSelected: (value) {
                if (value == NoticeMoreAction.delete) {
                  onDelete?.call();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}