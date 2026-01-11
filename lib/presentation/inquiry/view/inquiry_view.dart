import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class FalletterInquiryView extends StatelessWidget {
  const FalletterInquiryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [CustomAppBar(showBack: true, showLogout: false)],
        ),
      ),
    );
  }
}
