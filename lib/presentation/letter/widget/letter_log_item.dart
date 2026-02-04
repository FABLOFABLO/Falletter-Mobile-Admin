import 'package:falletter_mobile_admin/core/components/card/base_card_list.dart';
import 'package:falletter_mobile_admin/core/components/card/card_atoms.dart';
import 'package:falletter_mobile_admin/core/components/modal/letter_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/letter_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class LetterLogItem extends StatelessWidget {
  final String dateText;
  final String fromTo;
  final String content;

  const LetterLogItem({
    super.key,
    required this.dateText,
    required this.fromTo,
    required this.content,
  });

  void _openModal(BuildContext context) {
    final parts = fromTo.split('→');
    final from = parts.isNotEmpty ? parts.first.trim() : '';
    final to = parts.length > 1 ? parts.last.trim() : '';

    final model = LetterModalUiModel.fromTo(
      from: from,
      to: to,
      content: content,
      dateText: dateText,
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return LetterModal(
          model: model,
          onClose: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BaseCardList(
      onTap: () => _openModal(context),
      title: Row(
        children: [
          Text(
            dateText,
            style: FalletterTextStyle.body4.copyWith(
              color: FalletterColor.gray600,
            ),
          ),
          const SizedBox(width: 8),
          BadgeChip(text: '레터 관리', badgeColor: FalletterColor.red),
        ],
      ),
      body: Text(fromTo, style: FalletterTextStyle.subTitle2),
    );
  }
}
