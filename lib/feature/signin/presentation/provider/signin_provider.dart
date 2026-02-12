import 'package:falletter_mobile_admin/core/network/dio.dart';
import 'package:falletter_mobile_admin/core/util/email_format.dart';
import 'package:falletter_mobile_admin/feature/auth/data/repository/admin_auth_repository.dart';
import 'package:falletter_mobile_admin/feature/auth/domain/model/admin_auth_models.dart';
import 'package:falletter_mobile_admin/feature/signin/presentation/provider/signin_state.dart';
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
      state = state.copyWith(errorType: _mapAuthErrorToSignInError(e.type));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  SignInErrorType _mapAuthErrorToSignInError(AdminSignInErrorType type) {
    switch (type) {
      case AdminSignInErrorType.userNotFound:
        return SignInErrorType.userNotFound;
      case AdminSignInErrorType.invalidCredential:
        return SignInErrorType.invalidCredential;
      case AdminSignInErrorType.notApproved:
        return SignInErrorType.notApproved;
      case AdminSignInErrorType.network:
      case AdminSignInErrorType.unknown:
        return SignInErrorType.unknown;
    }
  }
}