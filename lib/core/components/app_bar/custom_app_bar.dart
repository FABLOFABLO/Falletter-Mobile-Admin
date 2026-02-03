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
    // TODO: 나중에 실제 로그아웃 로직/모달 연결
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('로그아웃 모달 테스트용입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
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
                    ? _icon(onTap: () {
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
                        child: const Icon(Symbols.logout, size: 22),
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
