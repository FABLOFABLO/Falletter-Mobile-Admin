import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class AdminCard extends StatelessWidget {
  final String name;
  final String role;

  const AdminCard({
    super.key,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(name, style: FalletterTextStyle.title1),
        const SizedBox(width: 24),
        Text(role, style: FalletterTextStyle.body1),
      ],
    );
  }
}

class AdminSubTitle extends StatelessWidget {
  final String text;

  const AdminSubTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: FalletterTextStyle.body1);
  }
}

class AdminContactRow extends StatelessWidget {
  final String label;
  final String value;

  const AdminContactRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(label, style: FalletterTextStyle.button),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: FalletterTextStyle.button.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
