import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/components/icon/field_icon.dart';
import 'package:falletter_mobile_admin/core/components/text_form_field/text_form_field.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/presentation/inquiry/provider/admin_register_provider.dart';
import 'package:flutter/material.dart';

class AdminRegisterInfoView extends StatelessWidget {
  final AdminRegisterState state;
  final AdminRegisterNotifier notifier;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController verifyController;

  final InputDecoration Function({
  required String label,
  required String hint,
  Widget? suffixIcon,
  required bool showError,
  }) decorationBuilder;

  final Widget Function({
  required String label,
  required VoidCallback onPressed,
  required bool selected,
  }) outlinedButtonBuilder;

  const AdminRegisterInfoView({
    super.key,
    required this.state,
    required this.notifier,
    required this.nameController,
    required this.emailController,
    required this.verifyController,
    required this.decorationBuilder,
    required this.outlinedButtonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final showError = state.showErrorBorder;

    String formatMmSs(int seconds) {
      final m = (seconds ~/ 60).toString().padLeft(2, '0');
      final s = (seconds % 60).toString().padLeft(2, '0');
      return '$m:$s';
    }

    final bottomInset = MediaQuery
        .of(context)
        .viewInsets
        .bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: AnimatedPadding(
          padding: EdgeInsets.only(bottom: bottomInset),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                    .onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const CustomAppBar(showBack: true, showLogout: false),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('어드민 등록', style: FalletterTextStyle.title2),
                              const SizedBox(height: 42),

                              Padding(
                                padding: const EdgeInsets.only(right: 70),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: outlinedButtonBuilder(
                                        label: '남성',
                                        selected: state.gender == Gender.male,
                                        onPressed: () =>
                                            notifier.selectGender(Gender.male),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: outlinedButtonBuilder(
                                        label: '여성',
                                        selected: state.gender == Gender.female,
                                        onPressed: () =>
                                            notifier.selectGender(
                                                Gender.female),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),

                              CustomTextFormField(
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                decoration: decorationBuilder(
                                  label: '이름',
                                  hint: '이름을 입력해주세요.',
                                  suffixIcon: null,
                                  showError:
                                  showError && state.name
                                      .trim()
                                      .isEmpty,
                                ),
                              ),

                              const SizedBox(height: 32),

                              CustomTextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: decorationBuilder(
                                  label: '이메일',
                                  hint: '이메일을 입력해주세요.',
                                  suffixIcon: FieldIcon.emailText(),
                                  showError: showError &&
                                      state.emailLocalPart
                                          .trim()
                                          .isEmpty,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: 28,
                                  child: OutlinedButton(
                                    onPressed: state.isSendingCode
                                        ? null
                                        : () => notifier.sendVerifyCode(),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: FalletterColor.gray500,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                    ),
                                    child: Text(
                                      state.isSendingCode
                                          ? '전송중...'
                                          : '인증번호 전송',
                                      style: FalletterTextStyle.body4.copyWith(
                                        color: FalletterColor.gray800,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              CustomTextFormField(
                                controller: verifyController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) =>
                                state.canGoNextInfo
                                    ? notifier.nextToPassword()
                                    : null,
                                decoration: decorationBuilder(
                                  label: '인증번호',
                                  hint: '인증번호를 입력해주세요.',
                                  suffixIcon: null,
                                  showError: showError &&
                                      state.verifyCode
                                          .trim()
                                          .isEmpty,
                                ),
                              ),

                              if (state.codeSent) ...[
                                const SizedBox(height: 10),
                                Text(
                                  '인증 만료 시간 ${formatMmSs(
                                      state.verifyExpiresSecondsLeft)}',
                                  style: FalletterTextStyle.body4.copyWith(
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
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          child: CustomElevatedButton(
                            onPressed: state.canGoNextInfo
                                ? notifier.nextToPassword
                                : null,
                            child: const Text('다음'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}