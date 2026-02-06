import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/presentation/inquiry/provider/admin_register_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_register_done_view.dart';
import 'admin_register_info_view.dart';
import 'admin_register_password_view.dart';

class AdminRegisterView extends ConsumerStatefulWidget {
  const AdminRegisterView({super.key});

  @override
  ConsumerState<AdminRegisterView> createState() => _AdminRegisterViewState();
}

class _AdminRegisterViewState extends ConsumerState<AdminRegisterView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final verifyController = TextEditingController();
  final pwController = TextEditingController();
  final pwConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.addListener(() {
      ref.read(adminRegisterProvider.notifier).setName(nameController.text);
    });
    emailController.addListener(() {
      ref
          .read(adminRegisterProvider.notifier)
          .setEmailLocalPart(emailController.text);
    });
    verifyController.addListener(() {
      ref
          .read(adminRegisterProvider.notifier)
          .setVerifyCode(verifyController.text);
    });

    pwController.addListener(() {
      ref.read(adminRegisterProvider.notifier).setPassword(pwController.text);
    });
    pwConfirmController.addListener(() {
      ref
          .read(adminRegisterProvider.notifier)
          .setPasswordConfirm(pwConfirmController.text);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    verifyController.dispose();
    pwController.dispose();
    pwConfirmController.dispose();
    super.dispose();
  }

  OutlineInputBorder _outline(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  InputDecoration _decoration({
    required String label,
    required String hint,
    Widget? suffixIcon,
    required bool showError,
  }) {
    final enabled = _outline(
      showError ? FalletterColor.red : FalletterColor.middleWhite,
    );
    final focused = _outline(
      showError ? FalletterColor.red : FalletterColor.black,
    );

    return InputDecoration(
      labelText: label,
      labelStyle: FalletterTextStyle.label,
      hintText: hint,
      hintStyle: FalletterTextStyle.placeholder.copyWith(
        color: FalletterColor.gray800,
      ),
      suffixIcon: suffixIcon,
      enabledBorder: enabled,
      focusedBorder: focused,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminRegisterProvider);
    final notifier = ref.read(adminRegisterProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: switch (state.step) {
            AdminRegisterStep.info => AdminRegisterInfoView(
              state: state,
              notifier: notifier,
              nameController: nameController,
              emailController: emailController,
              verifyController: verifyController,
              decorationBuilder: _decoration,
              outlinedButtonBuilder: outlinedCustomButton,
            ),
            AdminRegisterStep.password => AdminRegisterPasswordView(
              state: state,
              notifier: notifier,
              pwController: pwController,
              pwConfirmController: pwConfirmController,
              decorationBuilder: _decoration,
            ),
            AdminRegisterStep.done => AdminRegisterDoneView(
              onBackToSplash: () {
                context.go('/splash');
              },
            ),
          },
        ),
      ),
    );
  }

  Widget outlinedCustomButton({
    required String label,
    required VoidCallback onPressed,
    required bool selected,
  }) {
    return CustomElevatedButton(
      backgroundColor: selected ? Colors.white : FalletterColor.middleWhite,
      textColor: selected ? FalletterColor.black : FalletterColor.gray800,
      border: selected
          ? const BorderSide(color: FalletterColor.black, width: 1)
          : BorderSide.none,
      onPressed: onPressed,
      child: Text(label, style: FalletterTextStyle.placeholder),
    );
  }
}
