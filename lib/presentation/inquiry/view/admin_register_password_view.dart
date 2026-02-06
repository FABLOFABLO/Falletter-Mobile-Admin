import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/components/icon/field_icon.dart';
import 'package:falletter_mobile_admin/core/components/text_form_field/text_form_field.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/presentation/inquiry/provider/admin_register_provider.dart';
import 'package:flutter/material.dart';

class AdminRegisterPasswordView extends StatelessWidget {
  final AdminRegisterState state;
  final AdminRegisterNotifier notifier;
  final TextEditingController pwController;
  final TextEditingController pwConfirmController;

  final InputDecoration Function({
    required String label,
    required String hint,
    Widget? suffixIcon,
    required bool showError,
  })
  decorationBuilder;

  const AdminRegisterPasswordView({
    super.key,
    required this.state,
    required this.notifier,
    required this.pwController,
    required this.pwConfirmController,
    required this.decorationBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final showError = state.showErrorBorder;
    final pwMismatch =
        state.passwordConfirm.trim().isNotEmpty &&
        state.password != state.passwordConfirm;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CustomAppBar(
            showBack: true,
            showLogout: false,
            onBack: notifier.backToInfo,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('어드민 등록', style: FalletterTextStyle.title2),
                const SizedBox(height: 42),

                CustomTextFormField(
                  controller: pwController,
                  obscureText: state.obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: decorationBuilder(
                    label: '비밀번호',
                    hint: '비밀번호를 입력해주세요.',
                    suffixIcon: state.obscurePassword
                        ? FieldIcon.hidePwIcon(
                            onPressed: notifier.toggleObscurePassword,
                          )
                        : FieldIcon.showPwIcon(
                            onPressed: notifier.toggleObscurePassword,
                          ),
                    showError: showError && state.password.trim().isEmpty,
                  ),
                ),

                const SizedBox(height: 32),

                CustomTextFormField(
                  controller: pwConfirmController,
                  obscureText: state.obscurePasswordConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) =>
                      state.canRegister ? notifier.register() : null,
                  decoration: decorationBuilder(
                    label: '비밀번호 확인',
                    hint: '비밀번호를 입력해주세요.',
                    suffixIcon: state.obscurePasswordConfirm
                        ? FieldIcon.hidePwIcon(
                            onPressed: notifier.toggleObscurePasswordConfirm,
                          )
                        : FieldIcon.showPwIcon(
                            onPressed: notifier.toggleObscurePasswordConfirm,
                          ),
                    showError:
                        (showError && state.passwordConfirm.trim().isEmpty) ||
                        (showError && pwMismatch),
                  ),
                ),

                if (showError && pwMismatch) ...[
                  const SizedBox(height: 10),
                  Text(
                    '비밀번호가 일치하지 않습니다.',
                    style: FalletterTextStyle.label.copyWith(
                      color: FalletterColor.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomElevatedButton(
              onPressed: state.canRegister ? notifier.register : null,
              child: const Text('등록하기'),
            ),
          ),
        ],
      ),
    );
  }
}
