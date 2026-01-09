import 'package:falletter_mobile_admin/core/components/icon/field_icon.dart';
import 'package:falletter_mobile_admin/core/components/text_form_field/text_form_field.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class FalletterSigninView extends StatefulWidget {
  const FalletterSigninView({super.key});

  @override
  State<FalletterSigninView> createState() => _FalletterSigninViewState();
}

class _FalletterSigninViewState extends State<FalletterSigninView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  bool isButtonEnabled = false;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();

    void updateButtonState() {
      setState(() {
        isButtonEnabled =
            emailController.text.isNotEmpty && pwController.text.isNotEmpty;
      });
    }

    emailController.addListener(updateButtonState);
    pwController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget suffixIcon = obscureText
        ? FieldIcon.hidePwIcon(
            onPressed: () => setState(() => obscureText = false),
          )
        : FieldIcon.showPwIcon(
            onPressed: () => setState(() => obscureText = true),
          );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('로그인하고\n팔레터 사용하기', style: FalletterTextStyle.title2),
              const SizedBox(height: 40),
              CustomTextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  labelStyle: FalletterTextStyle.label,
                  hintText: '이메일을 입력해주세요.',
                  hintStyle: FalletterTextStyle.placeholder.copyWith(
                    color: FalletterColor.gray800,
                  ),
                  suffixIcon: FieldIcon.emailText(),
                ),
              ),
              const SizedBox(height: 32),
              CustomTextFormField(
                controller: pwController,
                obscureText: obscureText,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  labelStyle: FalletterTextStyle.label,
                  hintText: '비밀번호를 입력해주세요.',
                  hintStyle: FalletterTextStyle.placeholder.copyWith(
                    color: FalletterColor.gray800,
                  ),
                  suffixIcon: suffixIcon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
