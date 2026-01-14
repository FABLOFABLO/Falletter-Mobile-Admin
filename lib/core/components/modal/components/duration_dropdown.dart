import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class DurationDropdown extends StatelessWidget {
  final int value;
  final List<int> items;
  final ValueChanged<int> onChanged;

  const DurationDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = 44;

        return PopupMenuButton<int>(
          onSelected: onChanged,
          offset: const Offset(0, 36),
          color: FalletterColor.white,
          constraints: BoxConstraints(minWidth: width, maxWidth: width),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: FalletterColor.gray800, width: 1),
          ),
          itemBuilder: (_) {
            return items.map((day) {
              final isSelected = day == value;
              return PopupMenuItem<int>(
                value: day,
                height: height,
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Container(
                    alignment: Alignment.center,
                    color: isSelected
                        ? FalletterColor.gray100
                        : FalletterColor.white,
                    child: Text('$day일', style: FalletterTextStyle.body3),
                  ),
                ),
              );
            }).toList();
          },
          child: Container(
            width: width,
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      '$value일',
                      style: FalletterTextStyle.body1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Symbols.keyboard_arrow_down,
                  color: FalletterColor.gray800,
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}