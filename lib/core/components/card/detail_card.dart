import 'package:falletter_mobile_admin/core/components/card/base_card_list.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String writer;
  final String timeText;
  final String title;
  final String content;

  final Widget? badge;
  final Widget? footer;

  final List<PopupMenuEntry>? menuItems;
  final void Function(dynamic value)? onMenuSelected;

  const DetailCard({
    super.key,
    required this.writer,
    required this.timeText,
    required this.title,
    required this.content,
    this.badge,
    this.footer,
    this.menuItems,
    this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCardList(
      onTap: null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetaLine(
            writer: writer,
            timeText: timeText,
            badge: badge,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: FalletterTextStyle.subTitle2,
          ),
        ],
      ),
      body: Text(
        content,
        style: FalletterTextStyle.body4.copyWith(
          color: FalletterColor.gray700,
        ),
      ),
      footer: footer,
      menuItems: menuItems,
      onMenuSelected: onMenuSelected,
    );
  }
}

class _MetaLine extends StatelessWidget {
  final String writer;
  final String timeText;
  final Widget? badge;

  const _MetaLine({
    required this.writer,
    required this.timeText,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final style = FalletterTextStyle.body4.copyWith(
      color: FalletterColor.gray500,
    );
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(writer, style: style),
            const SizedBox(width: 8),
            Text(timeText, style: style),
          ],
        ),
        if (badge != null) ...[
          const SizedBox(width: 10),
          Expanded(child: Align(alignment: Alignment.centerLeft, child: badge!)),
        ],
      ],
    );
  }
}