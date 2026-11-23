import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/feature/report/domain/model/report_detail.dart';
import 'package:flutter/material.dart';

class ReportDecisionButton extends StatelessWidget {
  final ReportStatus status;
  final VoidCallback onReject;
  final VoidCallback onComplete;

  const ReportDecisionButton({
    super.key,
    required this.status,
    required this.onReject,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final resultMessage = status.resultMessage;

    if (resultMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            resultMessage,
            style: FalletterTextStyle.body2.copyWith(
              height: 20 / 14,
              color: FalletterColor.gray200,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            textColor: FalletterColor.red,
            backgroundColor: FalletterColor.background,
            border: const BorderSide(color: FalletterColor.red),
            onPressed: onReject,
            child: const Text('반려'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: CustomElevatedButton(
            textColor: FalletterColor.middleWhite,
            backgroundColor: FalletterColor.black,
            onPressed: onComplete,
            child: const Text('처리 완료'),
          ),
        ),
      ],
    );
  }
}
