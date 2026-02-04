import 'package:falletter_mobile_admin/core/components/bottom_navigation_bar/bottom_nav_bar_item.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _icons = [
    Symbols.mail,
    Symbols.forum,
    Symbols.group,
    Symbols.campaign,
  ];

  static const _labels = ["레터", "커뮤니티", "학생 목록", "공지"];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: FalletterColor.background,
        border: Border(
          top: BorderSide(color: FalletterColor.gray600, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...List.generate(_icons.length, (index) {
                final isSelected = currentIndex == index;

                return BottomNavBarItem(
                  icon: _icons[index],
                  label: _labels[index],
                  isSelected: isSelected,
                  onTap: () => onTap(index),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}