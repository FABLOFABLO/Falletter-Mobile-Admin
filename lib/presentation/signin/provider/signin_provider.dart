import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'signin_state.dart';

final signinProvider =
NotifierProvider<SigninNotifier, SigninState>(SigninNotifier.new);

class SigninNotifier extends Notifier<SigninState> {
  @override
  SigninState build() => const SigninState();

  void onEmailChanged(String v) {
    state = state.copyWith(email: v, showErrorBorder: false, isSuccess: false);
  }

  void onPasswordChanged(String v) {
    state = state.copyWith(password: v, showErrorBorder: false, isSuccess: false);
  }

  bool _isValidEmail(String email) {
    final e = email.trim();
    final reg = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return reg.hasMatch(e);
  }

  void toggleObscure() {
    state = state.copyWith(obscureText: !state.obscureText);
  }

  /// ✅ 실제 로그인 API 붙이면 여기에서 ok 값을 API 결과로 바꾸면 끝
  Future<void> submit() async {
    final local = state.email.trim();
    final pw = state.password;

    final email = '$local@dsm.hs.kr';

    if (email.isEmpty || pw.isEmpty || !_isValidEmail(email)) {
      state = state.copyWith(showErrorBorder: true, isSuccess: false);
      return;
    }

    /// TODO: Clean Architecture UseCase 연결 시 여기에서 결과 받기
    // final ok = await ref.read(signInUseCaseProvider).call(email, pw);
    final ok = true; // <- 지금은 이동 확인을 위해 true

    if (ok) {
      state = state.copyWith(isSuccess: true, showErrorBorder: false);
    } else {
      state = state.copyWith(showErrorBorder: true, isSuccess: false);
    }
  }

  void consumeSuccess() {
    state = state.copyWith(isSuccess: false);
  }
}