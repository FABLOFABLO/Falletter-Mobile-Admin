import 'dart:async';
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

  final bool isSendingCode;
  final bool codeSent;

  final int verifyExpiresSecondsLeft;

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
    this.isSendingCode = false,
    this.codeSent = false,
    this.verifyExpiresSecondsLeft = 0,
  });

  bool get canGoNextInfo =>
      gender != null &&
          name.trim().isNotEmpty &&
          emailLocalPart.trim().isNotEmpty &&
          verifyCode.trim().isNotEmpty &&
          codeSent &&
          verifyExpiresSecondsLeft > 0;

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
    bool? isSendingCode,
    bool? codeSent,
    int? verifyExpiresSecondsLeft,
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
      isSendingCode: isSendingCode ?? this.isSendingCode,
      codeSent: codeSent ?? this.codeSent,
      verifyExpiresSecondsLeft:
      verifyExpiresSecondsLeft ?? this.verifyExpiresSecondsLeft,
    );
  }
}

class AdminRegisterNotifier extends Notifier<AdminRegisterState> {
  Timer? _verifyExpiryTimer;

  @override
  AdminRegisterState build() {
    ref.onDispose(() {
      _verifyExpiryTimer?.cancel();
      _verifyExpiryTimer = null;
    });
    return const AdminRegisterState();
  }

  void selectGender(Gender gender) => state = state.copyWith(gender: gender);
  void setName(String v) => state = state.copyWith(name: v);
  void setEmailLocalPart(String v) => state = state.copyWith(emailLocalPart: v);
  void setVerifyCode(String v) => state = state.copyWith(verifyCode: v);

  Future<void> sendVerifyCode() async {
    state = state.copyWith(showErrorBorder: true);
    final local = state.emailLocalPart.trim();
    if (local.isEmpty) return;

    if (state.isSendingCode) return;

    final email = '$local@dsm.hs.kr';

    state = state.copyWith(isSendingCode: true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));

      state = state.copyWith(codeSent: true);
      _startVerifyExpiry(seconds: 300);
    } finally {
      state = state.copyWith(isSendingCode: false);
    }
  }

  void _startVerifyExpiry({required int seconds}) {
    _verifyExpiryTimer?.cancel();
    state = state.copyWith(verifyExpiresSecondsLeft: seconds);

    _verifyExpiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.verifyExpiresSecondsLeft - 1;
      if (next <= 0) {
        timer.cancel();
        state = state.copyWith(verifyExpiresSecondsLeft: 0);
        return;
      }
      state = state.copyWith(verifyExpiresSecondsLeft: next);
    });
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

  void backToInfo() {
    if (state.step != AdminRegisterStep.password) return;
    state = state.copyWith(
      step: AdminRegisterStep.info,
      showErrorBorder: false,
    );
  }

  void prepareExitToRoot() {
    state = state.copyWith(
      step: AdminRegisterStep.info,
      showErrorBorder: false,
    );
  }

  void reset() => state = const AdminRegisterState();
}