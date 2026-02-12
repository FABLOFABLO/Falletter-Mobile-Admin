import 'dart:async';

import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/feature/auth/presentation/provider/admin_logout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomAppBar extends ConsumerWidget {
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

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => DefaultModal(
        model: DefaultModalUiModel.logout(),
        onConfirmLogout: () {
          unawaited(() async {
            try {
              await ref.read(adminLogoutProvider.notifier).logout();
              if (!context.mounted) return;

              await Future<void>.delayed(Duration.zero);

              context.go(RouterPath.splash);
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '로그아웃에 실패했어요.',
                    style: FalletterTextStyle.body2.copyWith(
                      color: FalletterColor.white,
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: FalletterColor.black,
                  elevation: 0,
                ),
              );
            }
          }());
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
  Widget build(BuildContext context, WidgetRef ref) {
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
                          if (context.canPop()) context.pop();
                        },
                        child: const Icon(Symbols.arrow_back_ios, size: 22),
                      )
                    : const SizedBox(width: 40, height: 40),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: showLogout
                    ? _icon(
                        onTap: () => _handleLogout(context, ref),
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
