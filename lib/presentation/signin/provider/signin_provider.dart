import 'package:falletter_mobile_admin/core/network/dio.dart';
import 'package:falletter_mobile_admin/presentation/auth/model/admin_auth_models.dart';
import 'package:falletter_mobile_admin/presentation/auth/repository/admin_auth_repository.dart';
import 'package:falletter_mobile_admin/presentation/signin/provider/signin_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signinProvider = NotifierProvider<SigninNotifier, SignInState>(
  SigninNotifier.new,
);

class SigninNotifier extends Notifier<SignInState> {
  @override
  SignInState build() => const SignInState();

  void onEmailChanged(String v) {
    state = state.copyWith(
      email: v,
      showErrorBorder: false,
      errorType: SignInErrorType.none,
    );
  }

  void onPasswordChanged(String v) {
    state = state.copyWith(
      password: v,
      showErrorBorder: false,
      errorType: SignInErrorType.none,
    );
  }

  void toggleObscure() {
    state = state.copyWith(obscureText: !state.obscureText);
  }

  void consumeSuccess() {
    if (!state.isSuccess) return;
    state = state.copyWith(isSuccess: false);
  }

  void consumeError() {
    if (state.errorType == SignInErrorType.none) return;
    state = state.copyWith(errorType: SignInErrorType.none);
  }

  Future<void> submit() async {
    String normalizeDsmEmail(String input) {
      final t = input.trim();
      if (t.isEmpty) return t;
      if (t.contains('@')) return t;
      return '$t@dsm.hs.kr';
    }

    if (!state.canSubmit) {
      state = state.copyWith(showErrorBorder: true);
      return;
    }

    state = state.copyWith(
      isLoading: true,
      showErrorBorder: false,
      errorType: SignInErrorType.none,
    );

    final repo = ref.read(adminAuthRepositoryProvider);

    try {
      final req = AdminSignInRequest(
        email: normalizeDsmEmail(state.email),
        password: state.password,
      );

      final tokens = await repo.signIn(req);

      ref.read(accessTokenProvider.notifier).state = tokens.accessToken;
      ref.read(refreshTokenProvider.notifier).state = tokens.refreshToken;

      state = state.copyWith(isSuccess: true);
    } on AdminSignInException catch (e) {
      switch (e.type) {
        case AdminSignInErrorType.userNotFound:
          state = state.copyWith(errorType: SignInErrorType.userNotFound);
          break;
        case AdminSignInErrorType.invalidCredential:
          state = state.copyWith(errorType: SignInErrorType.invalidCredential);
          break;
        case AdminSignInErrorType.notApproved:
          state = state.copyWith(errorType: SignInErrorType.notApproved);
          break;
        case AdminSignInErrorType.network:
        case AdminSignInErrorType.unknown:
          state = state.copyWith(errorType: SignInErrorType.unknown);
          break;
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}