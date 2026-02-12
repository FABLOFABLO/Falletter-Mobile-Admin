import 'package:falletter_mobile_admin/core/components/card/base_card_list.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class NoticeItem extends StatelessWidget {
  final String title;
  final String preview;
  final String teacher;
  final String timeText;
  final VoidCallback? onTap;

  const NoticeItem({
    super.key,
    required this.title,
    required this.preview,
    required this.teacher,
    required this.timeText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = FalletterTextStyle.body4.copyWith(
      color: FalletterColor.gray600,
    );

    return BaseCardList(
      onTap: onTap,
      title: Text(title, style: FalletterTextStyle.subTitle2),
      body: Text(
        preview,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      footer: Row(
        children: [
          Text(teacher, style: style),
          const SizedBox(width: 8),
          Text(timeText, style: style),
        ],
      ),
      trailing: const SizedBox.shrink(),
    );
  }
}
