import 'package:flutter/foundation.dart';

@immutable
class SigninState {
  final String email;
  final String password;

  final bool obscureText;
  final bool showErrorBorder;

  final bool isLoading;
  final bool isSuccess;

  const SigninState({
    this.email = '',
    this.password = '',
    this.obscureText = true,
    this.showErrorBorder = false,
    this.isLoading = false,
    this.isSuccess = false,
});
  bool get canSubmit => email.trim().isNotEmpty && password.isNotEmpty;

  SigninState copyWith({
    String? email,
    String? password,
    bool? obscureText,
    bool? showErrorBorder,
    bool? isLoading,
    bool? isSuccess,
}) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscureText: obscureText ?? this.obscureText,
      showErrorBorder: showErrorBorder ?? this.showErrorBorder,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess
    );
  }
}