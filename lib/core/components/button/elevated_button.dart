import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final Widget child;
  final TextStyle? textStyle;

  const CustomElevatedButton({
    super.key,
    this.width = 350,
    this.height = 52,
    this.onPressed,
    this.textColor,
    this.backgroundColor,
    required this.child,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    final Color bgColor =
        backgroundColor ??
        (isEnabled ? FalletterColor.black : FalletterColor.gray500);
    final Color fgColor = textColor ?? FalletterColor.white;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: DefaultTextStyle(
          style: (textStyle ?? FalletterTextStyle.button).copyWith(
            color: fgColor,
          ),
          child: child,
        ),
      ),
    );
  }
}
