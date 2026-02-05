import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/card/base_card_list.dart';
import 'package:falletter_mobile_admin/core/components/card/card_atoms.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

enum CommentMenuAction { warn, ban, delete }

class CommentItem extends StatelessWidget {
  final String author;
  final String timeText;
  final String content;
  final bool badge;
  final void Function(CommentMenuAction action)? onMenu;

  const CommentItem({
    super.key,
    required this.author,
    required this.timeText,
    required this.content,
    this.badge = false,
    this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final metaStyle = FalletterTextStyle.body4.copyWith(
      color: FalletterColor.gray600,
    );
    final menuStyle = FalletterTextStyle.body3;

    return BaseCardList(
      title: Row(
        children: [
          Text(author, style: metaStyle),
          const SizedBox(width: 8),
          Text(timeText, style: metaStyle),
          const SizedBox(width: 8),
          if (badge)
            const BadgeChip(
              text: '관리자에 의해 삭제되었습니다',
              badgeColor: FalletterColor.red,
            ),
        ],
      ),
      body: Text(
        content,
        style: FalletterTextStyle.body3.copyWith(color: FalletterColor.black),
      ),
      menuItems: MoreAction.buildItems<CommentMenuAction>([
        MoreActionItem(value: CommentMenuAction.warn, text: '경고'),
        MoreActionItem(value: CommentMenuAction.ban, text: '정지'),
        MoreActionItem(
          value: CommentMenuAction.delete,
          text: '삭제',
          style: menuStyle.copyWith(color: FalletterColor.red),
          showDivider: false,
        ),
      ]),
      onMenuSelected: (v) => onMenu?.call(v as CommentMenuAction),
    );
  }
}
