import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/card/base_card_list.dart';
import 'package:falletter_mobile_admin/core/components/card/card_atoms.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

enum PostMenuAction { warn, ban, delete }

class CommunityPostItem extends StatelessWidget {
  final String title;
  final String preview;
  final String author;
  final String timeText;
  final int commentCount;
  final bool badge;
  final VoidCallback? onTap;
  final void Function(PostMenuAction action)? onMenu;

  const CommunityPostItem({
    super.key,
    required this.title,
    required this.preview,
    required this.author,
    required this.timeText,
    required this.commentCount,
    this.badge = false,
    this.onTap,
    this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final metaStyle = FalletterTextStyle.body4.copyWith(
      color: FalletterColor.gray600,
    );
    final menuStyle = FalletterTextStyle.body3;

    return BaseCardList(
      onTap: onTap,
      title: Row(
        children: [
          Text(title, style: FalletterTextStyle.title3.copyWith(fontSize: 16)),
          const SizedBox(width: 8),
          if (badge)
            const BadgeChip(
              text: '관리자에 의해 삭제되었습니다',
              badgeColor: FalletterColor.red,
            ),
        ],
      ),
      body: Text(
        preview,
        style: metaStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      footer: Row(
        children: [
          Text(author, style: metaStyle),
          const SizedBox(width: 8),
          Text(timeText, style: metaStyle),
          const SizedBox(width: 8),
          Text('댓글 $commentCount개', style: FalletterTextStyle.body4),
        ],
      ),
      menuItems: MoreAction.buildItems<PostMenuAction>([
        MoreActionItem(value: PostMenuAction.warn, text: '경고'),
        MoreActionItem(value: PostMenuAction.ban, text: '정지'),
        MoreActionItem(
          value: PostMenuAction.delete,
          text: '삭제',
          style: menuStyle.copyWith(color: FalletterColor.red),
          showDivider: false,
        ),
      ]),
      onMenuSelected: (v) => onMenu?.call(v as PostMenuAction),
    );
  }
}
