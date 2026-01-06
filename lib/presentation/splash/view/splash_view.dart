import 'package:falletter_mobile_admin/core/components/button/elevated_button.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/presentation/splash/provider/auth_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStatusProvider);

    return Scaffold(
      body: auth.when(
        data: (status) {
          final isLoggedIn = status == AuthStatus.logIn;

          if (isLoggedIn) {
            return Center(
              child: SvgPicture.asset('assets/svg/admin_logo.svg'),
            );
          }

          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: SvgPicture.asset('assets/svg/admin_logo.svg')),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '회원가입은 관리자에게 문의하세요.  ',
                            style: FalletterTextStyle.body3.copyWith(
                              color: FalletterColor.gray900,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              '문의',
                              style: FalletterTextStyle.body3.copyWith(decoration: TextDecoration.underline),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12,),
                      CustomElevatedButton(
                        textColor: FalletterColor.black,
                        backgroundColor: FalletterColor.gray300,
                        child: Text('로그인하기'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        error: (e, _) => Center(child: Text('에러 발생\n$e')),
        loading: () => const Center(
          child: CircularProgressIndicator(color: FalletterColor.white),
        ),
      ),
    );
  }
}
