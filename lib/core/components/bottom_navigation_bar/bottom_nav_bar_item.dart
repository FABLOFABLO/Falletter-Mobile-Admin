import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';

class BottomNavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomNavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSelected
                ? Icon(icon, color: FalletterColor.black, fill: 1)
                : Icon(icon, color: FalletterColor.gray800, fill: 1),
            const SizedBox(height: 4),
            isSelected
                ? Text(
                    label,
                    style: FalletterTextStyle.body3.copyWith(
                      color: FalletterColor.black,
                    ),
                  )
                : Text(
                    label,
                    style: FalletterTextStyle.body3.copyWith(
                      color: FalletterColor.gray800,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
