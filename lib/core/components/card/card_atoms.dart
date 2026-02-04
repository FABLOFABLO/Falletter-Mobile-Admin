import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final double size;

  const Profile({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(radius: 100, backgroundColor: FalletterColor.gray800);
  }
}

class BadgeChip extends StatelessWidget {
  final String text;
  final Color badgeColor;

  const BadgeChip({super.key, required this.text, required this.badgeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Text(
        text,
        style: FalletterTextStyle.body4.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
