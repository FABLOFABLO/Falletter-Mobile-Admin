import 'package:falletter_mobile_admin/core/components/text_form_field/text_form_field.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class BanReasonBox extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;

  const BanReasonBox({
    super.key,
    required this.hint,
    required this.controller,
    required this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FalletterColor.gray200,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: CustomTextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: 15,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: FalletterTextStyle.body3.copyWith(
            color: FalletterColor.gray400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        style: FalletterTextStyle.body3.copyWith(color: FalletterColor.black),
      ),
    );
  }
}
