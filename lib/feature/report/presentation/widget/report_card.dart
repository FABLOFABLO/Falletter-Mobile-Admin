import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ReportCard extends StatelessWidget {
  final String studentInfo;
  final String? time;
  final bool showArrow;
  final VoidCallback? onPressed;

  const ReportCard({
    super.key,
    required this.studentInfo,
    this.time,
    this.showArrow = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasTime = time != null;

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: hasTime ? 12 : 16,
        ),
        decoration: BoxDecoration(
          color: FalletterColor.middleWhite,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasTime) ...[
              Text(
                '신고일: $time',
                style: FalletterTextStyle.body4.copyWith(
                  height: 2,
                  color: FalletterColor.gray850,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC3C3C3),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    studentInfo,
                    style: FalletterTextStyle.subTitle2.copyWith(
                      height: 20 / 16,
                    ),
                  ),
                ),
                if (showArrow)
                  const Icon(
                    Symbols.chevron_right,
                    size: 24,
                    color: FalletterColor.gray200,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
