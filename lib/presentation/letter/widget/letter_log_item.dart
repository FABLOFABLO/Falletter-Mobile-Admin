import 'package:falletter_mobile_admin/core/components/card/base_card_list.dart';
import 'package:falletter_mobile_admin/core/components/card/card_atoms.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class LetterLogItem extends StatelessWidget {
  final String dateText;
  final String fromTo;
  final VoidCallback? onTap;

  const LetterLogItem({
    super.key,
    required this.dateText,
    required this.fromTo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCardList(
      onTap: onTap,
      title: Row(
        children: [
          Text(
            dateText,
            style: FalletterTextStyle.body4.copyWith(
              color: FalletterColor.gray600,
            ),
          ),
          const SizedBox(width: 8),
          BadgeChip(text: '레터 관리', badgeColor: FalletterColor.red),
        ],
      ),
      body: Text(fromTo, style: FalletterTextStyle.subTitle2),
    );
  }
}
