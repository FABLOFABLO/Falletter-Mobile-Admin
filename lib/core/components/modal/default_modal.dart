import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/components/modal/components/ban_reason_box.dart';
import 'package:falletter_mobile_admin/core/components/modal/components/duration_dropdown.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/provider/default_modal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultModal extends ConsumerStatefulWidget {
  final DefaultModalUiModel model;

  final void Function(int selectedDays, String reason)? onConfirmBan;
  final VoidCallback? onConfirmLogout;
  final VoidCallback? onConfirmDelete;

  const DefaultModal({
    super.key,
    required this.model,
    this.onConfirmBan,
    this.onConfirmLogout,
    this.onConfirmDelete,
  });

  @override
  ConsumerState<DefaultModal> createState() => _DefaultModalState();
}

class _DefaultModalState extends ConsumerState<DefaultModal> {
  final TextEditingController _reasonController = TextEditingController();
  final FocusNode _reasonFocusNode = FocusNode();

  bool get _isBan => widget.model.dialogType == DialogType.ban;

  int _computeInitialDay(List<int> duration) {
    if (duration.contains(3)) return 3;
    if (duration.isNotEmpty) return duration.first;
    return 3;
  }

  @override
  void initState() {
    super.initState();

    if (_isBan) {
      _reasonFocusNode.addListener(() {
        final initialDay = _computeInitialDay(widget.model.duration);
        ref
            .read(defaultModalProvider(initialDay).notifier)
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

  void _confirm(int initialDay) {
    if (_isBan) {
      final state = ref.read(defaultModalProvider(initialDay));
      if (!state.confirmEnabled) return;
      _close();
      widget.onConfirmBan?.call(state.selectedDays, state.reason.trim());
      return;
    }

    _close();
    if (widget.model.dialogType == DialogType.delete) {
      widget.onConfirmDelete?.call();
    } else {
      widget.onConfirmLogout?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialDay = _computeInitialDay(widget.model.duration);
    final banState = _isBan
        ? ref.watch(defaultModalProvider(initialDay))
        : null;
    final confirmEnabled = _isBan ? banState!.confirmEnabled : true;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: FalletterColor.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: FalletterColor.black, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isBan) ...[
              DurationDropdown(
                value: banState!.selectedDays,
                items: widget.model.duration,
                onChanged: (v) {
                  ref
                      .read(defaultModalProvider(initialDay).notifier)
                      .setDays(v);
                },
              ),
              const SizedBox(height: 12),
              BanReasonBox(
                hint: widget.model.banHintMessage,
                controller: _reasonController,
                focusNode: _reasonFocusNode,
                onChanged: (text) {
                  ref
                      .read(defaultModalProvider(initialDay).notifier)
                      .setReason(text);
                },
              ),
            ] else ...[
              const SizedBox(height: 45),
              Text(
                widget.model.logoutTitle,
                style: FalletterTextStyle.title3.copyWith(
                  color: FalletterColor.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.model.logoutMessage,
                style: FalletterTextStyle.button.copyWith(
                  color: FalletterColor.gray800,
                ),
              ),
              const SizedBox(height: 20),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    backgroundColor: FalletterColor.gray500,
                    textColor: FalletterColor.middleWhite,
                    onPressed: _close,
                    child: Text(widget.model.cancelText),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomElevatedButton(
                    backgroundColor: confirmEnabled
                        ? FalletterColor.black
                        : FalletterColor.gray500,
                    textColor: confirmEnabled
                        ? FalletterColor.white
                        : FalletterColor.middleWhite,
                    onPressed: () => _confirm(initialDay),
                    child: Text(widget.model.confirmText),
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
