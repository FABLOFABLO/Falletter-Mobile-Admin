import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/components/icon/field_icon.dart';
import 'package:falletter_mobile_admin/core/components/text_form_field/text_form_field.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/feature/signin/presentation/provider/signin_provider.dart';
import 'package:falletter_mobile_admin/feature/signin/presentation/provider/signin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class FalletterSigninView extends ConsumerStatefulWidget {
  const FalletterSigninView({super.key});

  @override
  ConsumerState<FalletterSigninView> createState() =>
      _FalletterSigninViewState();
}

class _FalletterSigninViewState extends ConsumerState<FalletterSigninView> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  ProviderSubscription<SignInState>? _sub;

  String? _errorMessage(SignInErrorType type) {
    switch (type) {
      case SignInErrorType.userNotFound:
      case SignInErrorType.invalidCredential:
        return '등록되지 않은 아이디 입니다';
      case SignInErrorType.notApproved:
        return '등록되지 않은 아이디 입니다';
      case SignInErrorType.unknown:
        return '등록되지 않은 아이디 입니다';
      case SignInErrorType.none:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      ref.read(signinProvider.notifier).onEmailChanged(emailController.text);
    });
    pwController.addListener(() {
      ref.read(signinProvider.notifier).onPasswordChanged(pwController.text);
    });

    _sub = ref.listenManual<SignInState>(signinProvider, (prev, next) {
      final prevSuccess = prev?.isSuccess ?? false;
      if (!prevSuccess && next.isSuccess) {
        context.go('/letter');
        ref.read(signinProvider.notifier).consumeSuccess();
        return;
      }

      final msg = _errorMessage(next.errorType);
      if (msg != null && msg.isNotEmpty) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        const buttonBottomPadding = 50.0;
        const horizontal = 20.0;
        const gapNoKeyboard = 60.0;

        final gap = bottomInset > 0 ? 0 : gapNoKeyboard;
        final bottomMargin = bottomInset + buttonBottomPadding + gap;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.fromLTRB(
                horizontal,
                0,
                horizontal,
                bottomMargin,
              ),
              backgroundColor: FalletterColor.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 2),
              content: Row(
                children: [
                  Expanded(
                    child: Text(
                      msg,
                      style: FalletterTextStyle.body2.copyWith(
                        color: FalletterColor.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ref.read(signinProvider.notifier).consumeError();
                    },
                    child: const Icon(
                      Symbols.cancel,
                      color: FalletterColor.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        ref.read(signinProvider.notifier).consumeError();
      }
    });
  }

  @override
  void dispose() {
    _sub?.close();
    _sub = null;

    emailController.dispose();
    pwController.dispose();
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
    required Widget suffixIcon,
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
    final state = ref.watch(signinProvider);
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;

    final canSubmit = state.canSubmit;
    final showError = state.showErrorBorder;

    final pwSuffixIcon = state.obscureText
        ? FieldIcon.hidePwIcon(
      onPressed: () => ref.read(signinProvider.notifier).toggleObscure(),
    )
        : FieldIcon.showPwIcon(
      onPressed: () => ref.read(signinProvider.notifier).toggleObscure(),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('로그인하고\n팔레터 사용하기', style: FalletterTextStyle.title2),
                    const SizedBox(height: 40),
                    CustomTextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: _decoration(
                        label: '이메일',
                        hint: '이메일을 입력해주세요.',
                        suffixIcon: FieldIcon.emailText(),
                        showError: showError,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextFormField(
                      controller: pwController,
                      obscureText: state.obscureText,
                      autocorrect: false,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => canSubmit
                          ? ref.read(signinProvider.notifier).submit()
                          : null,
                      decoration: _decoration(
                        label: '비밀번호',
                        hint: '비밀번호를 입력해주세요.',
                        suffixIcon: pwSuffixIcon,
                        showError: showError,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '회원가입은 관리자에게 문의하세요.',
                        style: FalletterTextStyle.body3.copyWith(
                          color: FalletterColor.gray700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => context.push(RouterPath.inquiry),
                        child: Text(
                          '문의',
                          style: FalletterTextStyle.body3.copyWith(
                            color: FalletterColor.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, viewInsetsBottom + 20),
                  child: CustomElevatedButton(
                    onPressed: canSubmit
                        ? () => ref.read(signinProvider.notifier).submit()
                        : null,
                    backgroundColor: canSubmit
                        ? FalletterColor.black
                        : FalletterColor.gray800,
                    textColor: FalletterColor.white,
                    child: const Text('로그인하기'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}