import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/feature/inquiry/presentation/provider/inquiry_provider.dart';
import 'package:falletter_mobile_admin/feature/inquiry/presentation/view/admin_card_view.dart';
import 'package:falletter_mobile_admin/feature/inquiry/presentation/widget/admin_contact_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FalletterInquiryView extends ConsumerWidget {
  const FalletterInquiryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admins = ref.watch(inquiryAdminsProvider);

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
                  Text('회원가입 문의', style: FalletterTextStyle.title2),
                  const SizedBox(height: 42),
                  ...admins.map(
                    (admin) => Padding(
                      padding: const EdgeInsets.only(bottom: 35),
                      child: AdminContactTile(
                        name: admin.name,
                        role: admin.role,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AdminCardView(admin: admin),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            CustomElevatedButton(
              child: Text('어드민 등록하기'),
              onPressed: () => context.push('/register'),
            ),
          ],
        ),
      ),
    );
  }
}
