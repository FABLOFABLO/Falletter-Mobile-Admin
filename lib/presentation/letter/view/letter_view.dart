import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/presentation/letter/widget/letter_log_item.dart';
import 'package:flutter/material.dart';

class FalletterLetterView extends StatelessWidget {
  const FalletterLetterView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      8,
      (i) => _LetterLog(
        dateText: '12월 15일',
        fromTo: '3301 강해민 → 1401 김수인',
        content:
            'Lorem ipsum mi fringilla massa at purus fermentum lectus rhoncus lectus rhoncus nunc sit nam ut et nunc lectus elit elit urna leo placerat quis elit ipsum sed amet nec nunc in viverra leo vitae odio habitant quis sed auctor.',
      ),
    );

    return Scaffold(
      backgroundColor: FalletterColor.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(showBack: false, showLogout: true),

            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return LetterLogItem(
                    dateText: item.dateText,
                    fromTo: item.fromTo,
                    content: item.content,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LetterLog {
  final String dateText;
  final String fromTo;
  final String content;

  const _LetterLog({
    required this.dateText,
    required this.fromTo,
    required this.content,
  });
}
