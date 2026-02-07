import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/card/detail_card.dart';
import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

enum NoticeMoreAction { delete }

class NoticeDetailView extends StatefulWidget {
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
  State<NoticeDetailView> createState() => _NoticeDetailViewState();
}

class _NoticeDetailViewState extends State<NoticeDetailView> {
  bool _isDeleted = false;

  void _openDeleteModal() {
    showDialog(
      context: context,
      builder: (_) => DefaultModal(
        model: DefaultModalUiModel.delete(),
        onConfirmDelete: () {
          setState(() => _isDeleted = true);
          widget.onDelete?.call();
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

    return Scaffold(
      backgroundColor: FalletterColor.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(showBack: true),
            DetailCard(
              writer: widget.writer,
              timeText: widget.timeText,
              title: widget.title,
              content: widget.content,
              menuItems: menuItems,
              onMenuSelected: (value) {
                if (value == NoticeMoreAction.delete) {
                  _openDeleteModal();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
