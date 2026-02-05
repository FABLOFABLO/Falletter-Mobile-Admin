import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class MoreActionItem<T> {
  final T value;
  final String text;
  final TextStyle? style;
  final bool showDivider;

  const MoreActionItem({
    required this.value,
    required this.text,
    this.style,
    this.showDivider = true,
  });
}

class MoreAction {
  static List<PopupMenuEntry<T>> buildItems<T>(List<MoreActionItem<T>> items) {
    return items.map((item) {
      final isLast = items.last == item;
      return PopupMenuItem<T>(
        value: item.value,
        height: 44,
        padding: EdgeInsets.zero,
        child: Center(
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Text(
                      item.text,
                      style: item.style ?? FalletterTextStyle.body3,
                    ),
                  ),
                ),
                if (!isLast && item.showDivider)
                  Container(height: 0.5, color: FalletterColor.gray500),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}