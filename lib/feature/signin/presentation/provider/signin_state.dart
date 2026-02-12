enum SignInErrorType {
  none,
  userNotFound,
  invalidCredential,
  notApproved,
  unknown,
}

class SignInState {
  final String email;
  final String password;

  final bool isLoading;
  final bool obscureText;
  final bool showErrorBorder;
  final bool isSuccess;

  final SignInErrorType errorType;

  const SignInState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.obscureText = true,
    this.showErrorBorder = false,
    this.isSuccess = false,
    this.errorType = SignInErrorType.none,
  });

  bool get canSubmit => email.trim().isNotEmpty && password.trim().isNotEmpty;

  SignInState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? obscureText,
    bool? showErrorBorder,
    bool? isSuccess,
    SignInErrorType? errorType,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      obscureText: obscureText ?? this.obscureText,
      showErrorBorder: showErrorBorder ?? this.showErrorBorder,
      isSuccess: isSuccess ?? this.isSuccess,
      errorType: errorType ?? this.errorType,
    );
  }
}