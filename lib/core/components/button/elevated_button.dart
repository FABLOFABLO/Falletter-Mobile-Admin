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
  final BorderSide? border;

  const CustomElevatedButton({
    super.key,
    this.width = 350,
    this.height = 52,
    this.onPressed,
    this.textColor,
    this.backgroundColor,
    required this.child,
    this.textStyle,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final enabledBg = backgroundColor ?? FalletterColor.black;
    final disabledBg = FalletterColor.gray500;

    final enabledFg = textColor ?? FalletterColor.white;
    final disabledFg = (textColor ?? FalletterColor.white);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return disabledBg;
            return enabledBg;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return disabledFg;
            return enabledFg;
          }),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),

          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: border ?? BorderSide.none,
            ),
          ),
          elevation: WidgetStateProperty.all(0),
        ),
        child: DefaultTextStyle(
          style: (textStyle ?? FalletterTextStyle.button).copyWith(
            color: onPressed == null ? disabledFg : enabledFg,
          ),
          child: child,
        ),
      ),
    );
  }
}
