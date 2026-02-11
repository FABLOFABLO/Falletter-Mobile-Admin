import 'package:falletter_mobile_admin/core/components/card/base_card_list.dart';
import 'package:falletter_mobile_admin/core/components/card/card_atoms.dart';
import 'package:falletter_mobile_admin/core/components/modal/letter_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/letter_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/presentation/letter/provider/letter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LetterLogItem extends ConsumerWidget {
  final int letterId;
  final String dateText;
  final String fromTo;

  const LetterLogItem({
    super.key,
    required this.letterId,
    required this.dateText,
    required this.fromTo,
  });

  Future<void> _openModal(BuildContext context, WidgetRef ref) async {
    try {
      final detail = await ref.read(
        unpassedLetterDetailProvider(letterId).future,
      );

      final parts = fromTo.split('→');
      final from = parts.isNotEmpty ? parts.first.trim() : '';
      final to = parts.length > 1 ? parts.last.trim() : '';

      final model = LetterModalUiModel.fromTo(
        from: from,
        to: to,
        content: detail.content,
        dateText: dateText,
      );

      if (!context.mounted) return;

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
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('상세 조회 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseCardList(
      onTap: () => _openModal(context, ref),
      title: Row(
        children: [
          Text(
            dateText,
            style: FalletterTextStyle.body4.copyWith(
              color: FalletterColor.gray600,
            ),
          ),
          const SizedBox(width: 8),
          BadgeChip(text: '검사 반려', badgeColor: FalletterColor.red),
        ],
      ),
      body: Text(fromTo, style: FalletterTextStyle.subTitle2),
    );
  }
}
