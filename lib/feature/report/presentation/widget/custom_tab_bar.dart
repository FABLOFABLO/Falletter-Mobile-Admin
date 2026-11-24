import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;

  const CustomTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final labelStyle = FalletterTextStyle.body2.copyWith(fontSize: 16);

    return TabBar(
      controller: controller,
      labelColor: FalletterColor.black,
      unselectedLabelColor: FalletterColor.gray200,
      labelStyle: labelStyle,
      unselectedLabelStyle: labelStyle,
      labelPadding: EdgeInsets.zero,
      indicatorColor: FalletterColor.black,
      indicatorWeight: 1,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerHeight: 0,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      tabs: const [
        Tab(height: 38, text: '대기중'),
        Tab(height: 38, text: '반려'),
        Tab(height: 38, text: '처리완료'),
      ],
    );
  }
}
