import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Gender { male, female }
enum AdminRegisterStep { info, password, done }

final adminRegisterProvider =
NotifierProvider<AdminRegisterNotifier, AdminRegisterState>(
  AdminRegisterNotifier.new,
);

class AdminRegisterState {
  final AdminRegisterStep step;

  final Gender? gender;
  final String name;
  final String emailLocalPart;
  final String verifyCode;

  final String password;
  final String passwordConfirm;

  final bool obscurePassword;
  final bool obscurePasswordConfirm;
  final bool showErrorBorder;

  const AdminRegisterState({
    this.step = AdminRegisterStep.info,
    this.gender,
    this.name = '',
    this.emailLocalPart = '',
    this.verifyCode = '',
    this.password = '',
    this.passwordConfirm = '',
    this.obscurePassword = true,
    this.obscurePasswordConfirm = true,
    this.showErrorBorder = false,
  });

  bool get canGoNextInfo =>
      gender != null &&
          name.trim().isNotEmpty &&
          emailLocalPart.trim().isNotEmpty &&
          verifyCode.trim().isNotEmpty;

  bool get canRegister =>
      password.trim().isNotEmpty &&
          passwordConfirm.trim().isNotEmpty &&
          password == passwordConfirm;

  AdminRegisterState copyWith({
    AdminRegisterStep? step,
    Gender? gender,
    String? name,
    String? emailLocalPart,
    String? verifyCode,
    String? password,
    String? passwordConfirm,
    bool? obscurePassword,
    bool? obscurePasswordConfirm,
    bool? showErrorBorder,
  }) {
    return AdminRegisterState(
      step: step ?? this.step,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      emailLocalPart: emailLocalPart ?? this.emailLocalPart,
      verifyCode: verifyCode ?? this.verifyCode,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscurePasswordConfirm:
      obscurePasswordConfirm ?? this.obscurePasswordConfirm,
      showErrorBorder: showErrorBorder ?? this.showErrorBorder,
    );
  }
}

class AdminRegisterNotifier extends Notifier<AdminRegisterState> {
  @override
  AdminRegisterState build() => const AdminRegisterState();

  void selectGender(Gender gender) => state = state.copyWith(gender: gender);
  void setName(String v) => state = state.copyWith(name: v);
  void setEmailLocalPart(String v) => state = state.copyWith(emailLocalPart: v);
  void setVerifyCode(String v) => state = state.copyWith(verifyCode: v);

  /// TODO: 실제 API 연결 시 여기서 이메일 인증번호 전송 요청
  Future<void> sendVerifyCode() async {
    state = state.copyWith(showErrorBorder: true);
    if (state.emailLocalPart.trim().isEmpty) return;

    // TODO: send email code usecase/repo 호출
  }

  void nextToPassword() {
    state = state.copyWith(showErrorBorder: true);
    if (!state.canGoNextInfo) return;

    state = state.copyWith(
      step: AdminRegisterStep.password,
      showErrorBorder: false,
    );
  }

  void setPassword(String v) => state = state.copyWith(password: v);
  void setPasswordConfirm(String v) =>
      state = state.copyWith(passwordConfirm: v);

  void toggleObscurePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);

  void toggleObscurePasswordConfirm() => state = state.copyWith(
      obscurePasswordConfirm: !state.obscurePasswordConfirm);

  Future<void> register() async {
    state = state.copyWith(showErrorBorder: true);
    if (!state.canRegister) return;

    // TODO: 최종 등록(신청) API 호출

    state = state.copyWith(
      step: AdminRegisterStep.done,
      showErrorBorder: false,
    );
  }

  /// 완료 화면까지 갔다가 다시 처음으로 초기화가 필요하면 사용
  void reset() => state = const AdminRegisterState();
}
