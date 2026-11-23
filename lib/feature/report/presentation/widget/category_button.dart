import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

enum ReportCategory {
  all('전체'),
  community('커뮤니티'),
  letter('레터');

  const ReportCategory(this.label);
  final String label;
}

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        children: [
          for (var i = 0; i < labels.length; i++)
            _FilterChipItem(
              label: labels[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  const _FilterChipItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: selected ? FalletterColor.black : FalletterColor.middleWhite,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: FalletterTextStyle.body3.copyWith(
            fontWeight: FontWeight.w600,
            height: 20 / 12,
            color: selected ? FalletterColor.white : FalletterColor.gray200,
          ),
        ),
      ),
    );
  }
}
