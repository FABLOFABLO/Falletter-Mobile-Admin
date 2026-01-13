import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/provider/default_modal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class DefaultModal extends ConsumerStatefulWidget {
  final DefaultModalUiModel model;

  final void Function(int selectedDays, String reason)? onConfirmBan;
  final VoidCallback? onConfirmLogout;

  const DefaultModal({
    super.key,
    required this.model,
    this.onConfirmBan,
    this.onConfirmLogout,
  });

  @override
  ConsumerState<DefaultModal> createState() => _DefaultModalState();
}

class _DefaultModalState extends ConsumerState<DefaultModal> {
  final TextEditingController _reasonController = TextEditingController();
  final FocusNode _reasonFocusNode = FocusNode();

  bool get _isBan => widget.model.dialogType == DialogType.ban;

  @override
  void initState() {
    super.initState();

    if (_isBan) {
      _reasonController.addListener(() {
        ref
            .read(defaultModalProvider(widget.model.duration).notifier)
            .setReason(_reasonController.text);
      });

      _reasonFocusNode.addListener(() {
        ref
            .read(defaultModalProvider(widget.model.duration).notifier)
            .setReasonFocused(_reasonFocusNode.hasFocus);
      });
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _reasonFocusNode.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).pop();

  void _confirm() {
    if (_isBan) {
      final state = ref.read(defaultModalProvider(widget.model.duration));
      if (!state.confirmEnabled) return;

      widget.onConfirmBan?.call(state.selectedDays, state.reason.trim());
    } else {
      widget.onConfirmLogout?.call();
    }
    _close();
  }

  @override
  Widget build(BuildContext context) {
    final banState =
    _isBan ? ref.watch(defaultModalProvider(widget.model.duration)) : null;

    final confirmEnabled = _isBan ? banState!.confirmEnabled : true;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: FalletterColor.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isBan) ...[
              _DurationDropdown(
                value: banState!.selectedDays,
                items: widget.model.duration,
                onChanged: (v) {
                  ref
                      .read(defaultModalProvider(widget.model.duration).notifier)
                      .setDays(v);
                },
              ),
              const SizedBox(height: 12),
              _BanReasonBox(
                hint: widget.model.banHintMessage,
                controller: _reasonController,
                focusNode: _reasonFocusNode,
                showMessage: banState.showMessage,
              ),
            ] else ...[
              Text(
                widget.model.logoutTitle,
                style: FalletterTextStyle.title3.copyWith(
                  color: FalletterColor.black,
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                widget.model.logoutMessage,
                style: FalletterTextStyle.button.copyWith(
                  color: FalletterColor.gray800,
                ),
              ),
              const SizedBox(height: 25,),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    backgroundColor: FalletterColor.gray500,
                    textColor: FalletterColor.middleWhite,
                    onPressed: _close,
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: CustomElevatedButton(
                    backgroundColor: confirmEnabled
                        ? FalletterColor.black
                        : FalletterColor.gray500,
                    textColor: confirmEnabled
                        ? FalletterColor.white
                        : FalletterColor.middleWhite,
                    onPressed: confirmEnabled ? _confirm : null,
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationDropdown extends StatelessWidget {
  final int value;
  final List<int> items;
  final ValueChanged<int> onChanged;

  const _DurationDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: FalletterColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          icon: const Icon(Symbols.keyboard_arrow_down),
          style: FalletterTextStyle.body1.copyWith(fontWeight: FontWeight.w500),
          items: items
              .map(
                (d) => DropdownMenuItem<int>(
              value: d,
              child: Center(child: Text('${d}일')),
            ),
          )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _BanReasonBox extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showMessage;

  const _BanReasonBox({
    required this.hint,
    required this.controller,
    required this.focusNode,
    required this.showMessage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: Container(
        height: 210,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: FalletterColor.middleWhite,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            if (showMessage)
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  hint,
                  style: FalletterTextStyle.body3.copyWith(
                    color: FalletterColor.gray700,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: showMessage ? 22 : 0),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: FalletterTextStyle.body3.copyWith(
                  color: FalletterColor.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: showMessage ? null : hint,
                  hintStyle: FalletterTextStyle.body3.copyWith(
                    color: FalletterColor.gray400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
