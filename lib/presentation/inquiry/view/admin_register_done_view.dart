import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class AdminRegisterDoneView extends StatelessWidget {
  final VoidCallback onBackToSplash;

  const AdminRegisterDoneView({
    super.key,
    required this.onBackToSplash,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppBar(showBack: true, showLogout: false),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 42),
                  Text('어드민이 신청되었습니다', style: FalletterTextStyle.title2),
                  const SizedBox(height: 8),
                  Text(
                    '어드민 요청을 대기중입니다',
                    style: FalletterTextStyle.body2.copyWith(
                      color: FalletterColor.gray800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: CustomElevatedButton(
            onPressed: onBackToSplash,
            child: const Text('돌아가기'),
          ),
        ),
      ],
    );
  }
}