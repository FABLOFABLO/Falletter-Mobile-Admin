import 'package:falletter_mobile_admin/core/components/modal/ui_model/letter_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class LetterModal extends StatelessWidget {
  final LetterModalUiModel model;
  final VoidCallback? onClose;

  const LetterModal({super.key, required this.model, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final closeButtonSize = MediaQuery.of(context).size.width * 0.13;
    const divider = Divider(color: FalletterColor.gray100, height: 1);
    const gap = SizedBox(height: 12);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: FalletterColor.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model.headerText,
                      textAlign: TextAlign.center,
                      style: FalletterTextStyle.body3.copyWith(
                        color: FalletterColor.gray800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    divider,
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        model.content,
                        textAlign: TextAlign.start,
                        style: FalletterTextStyle.body3.copyWith(
                          color: FalletterColor.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    divider,
                    const SizedBox(height: 14),
                    Text(
                      model.dateText,
                      textAlign: TextAlign.center,
                      style: FalletterTextStyle.body3.copyWith(
                        color: FalletterColor.gray800,
                      ),
                    ),
                    gap,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: GestureDetector(
              onTap: onClose ?? () => Navigator.of(context).pop(),
              child: Container(
                width: closeButtonSize,
                height: closeButtonSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: FalletterColor.gray700,
                ),
                child: const Center(
                  child: Icon(
                    Symbols.close,
                    color: FalletterColor.gray100,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
