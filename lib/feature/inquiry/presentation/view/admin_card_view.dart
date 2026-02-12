import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/feature/inquiry/presentation/provider/inquiry_provider.dart';
import 'package:falletter_mobile_admin/feature/inquiry/presentation/widget/admin_card.dart';
import 'package:flutter/material.dart';

class AdminCardView extends StatelessWidget {
  final AdminContact admin;

  const AdminCardView({
    super.key,
    required this.admin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(showBack: true, showLogout: false),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminCard(
                    name: admin.name,
                    role: admin.role,
                  ),
                  const SizedBox(height: 8),
                  AdminSubTitle(text: admin.description),
                  const SizedBox(height: 20),
                  AdminContactRow(
                    label: 'Mobile',
                    value: admin.mobile,
                  ),
                  const SizedBox(height: 12),
                  AdminContactRow(
                    label: 'Email',
                    value: admin.email,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
