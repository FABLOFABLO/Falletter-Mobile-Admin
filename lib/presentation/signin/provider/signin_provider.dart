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
    if (!state.canSubmit) {
      state = state.copyWith(showErrorBorder: true);
      return;
    }

    state = state.copyWith(
      isLoading: true,
      showErrorBorder: false,
      errorType: SignInErrorType.none,
    );

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final responseCode = 'NOT_APPROVED';

      switch (responseCode) {
        case 'SUCCESS':
          state = state.copyWith(isSuccess: true);
          return;

        case 'NOT_APPROVED':
          state = state.copyWith(errorType: SignInErrorType.notApproved);
          return;

        case 'USER_NOT_FOUND':
          state = state.copyWith(errorType: SignInErrorType.userNotFound);
          return;

        case 'INVALID_CREDENTIAL':
          state = state.copyWith(errorType: SignInErrorType.invalidCredential);
          return;

        default:
          state = state.copyWith(errorType: SignInErrorType.unknown);
          return;
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}