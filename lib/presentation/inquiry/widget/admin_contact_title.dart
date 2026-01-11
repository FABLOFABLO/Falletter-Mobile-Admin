import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class AdminContactTile extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback? onTap;

  const AdminContactTile({
    super.key,
    required this.name,
    required this.role,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(name, style: FalletterTextStyle.subTitle2),
            const SizedBox(width: 8),
            Text(role, style: FalletterTextStyle.body2),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: const Icon(Symbols.arrow_forward_ios, size: 15),
        ),
      ],
    );
  }
}