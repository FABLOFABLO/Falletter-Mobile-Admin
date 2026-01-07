import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:flutter/material.dart';

InputBorder _border(Set<WidgetState> states) {
  Color? color = FalletterColor.middleWhite;

  if (states.contains(WidgetState.focused)) {
    color = FalletterColor.black;
  }

  if (states.contains(WidgetState.error)) {
    color = FalletterColor.red;
  }

  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(width: 1, color: color),
  );
}

InputDecorationTheme inputDecorationTheme = const InputDecorationTheme(
  labelStyle: TextStyle(color: FalletterColor.black),
  helperMaxLines: null,
  hintStyle: TextStyle(color: FalletterColor.gray800),
  errorMaxLines: null,
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  filled: true,
  fillColor: FalletterColor.black,
  border: WidgetStateInputBorder.resolveWith(_border),
);

TextSelectionThemeData textSelectionTheme = const TextSelectionThemeData(
  cursorColor: FalletterColor.black,
  selectionColor: FalletterColor.black,
);
