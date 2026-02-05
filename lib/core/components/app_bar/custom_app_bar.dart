import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomAppBar extends StatelessWidget {
  final String? leftAsset;
  final String? rightAsset;

  final bool showBack;
  final bool showLogout;

  final double height;
  final EdgeInsetsGeometry padding;

  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    this.leftAsset,
    this.rightAsset,
    this.showBack = true,
    this.showLogout = false,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    this.onBack,
  });

  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => DefaultModal(
        model: DefaultModalUiModel.logout(),
        onConfirmLogout: () {
          // 실제 로그아웃 로직 수행 (예: Provider 호출, 페이지 이동 등)
        },
      ),
    );
  }

  Widget _icon({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(width: 40, height: 40, child: Center(child: child)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Padding(
          padding: padding,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: showBack
                    ? _icon(
                        onTap: () {
                          if (onBack != null) {
                            onBack!();
                            return;
                          }
                          Navigator.of(context).maybePop();
                        },
                        child: const Icon(Symbols.arrow_back_ios, size: 22),
                      )
                    : const SizedBox(width: 40, height: 40),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: showLogout
                    ? _icon(
                        onTap: () => _handleLogout(context),
                        child: Icon(
                          Symbols.logout,
                          size: 22,
                          color: FalletterColor.red,
                          weight: 600,
                        ),
                      )
                    : const SizedBox(width: 40, height: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
