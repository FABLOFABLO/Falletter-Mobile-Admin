import 'dart:async';

import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/presentation/auth/model/admin_auth_models.dart';
import 'package:falletter_mobile_admin/presentation/auth/provider/admin_register_provider.dart';
import 'package:falletter_mobile_admin/presentation/auth/repository/admin_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AdminRegisterErrorType {
  none,
  verifyCodeMismatchOrNotFound,
  emailAlreadyExists,
  network,
  unknown,
}

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
  final AdminRegisterErrorType errorType;

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
    this.errorType = AdminRegisterErrorType.none,
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
    AdminRegisterErrorType? errorType,
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
      errorType: errorType ?? this.errorType,
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

  void selectGender(Gender gender) =>
      state = state.copyWith(gender: gender, errorType: AdminRegisterErrorType.none);

  void setName(String v) =>
      state = state.copyWith(name: v, errorType: AdminRegisterErrorType.none);

  void setEmailLocalPart(String v) =>
      state = state.copyWith(emailLocalPart: v, errorType: AdminRegisterErrorType.none);

  void setVerifyCode(String v) =>
      state = state.copyWith(verifyCode: v, errorType: AdminRegisterErrorType.none);

  Future<void> sendVerifyCode() async {
    state = state.copyWith(
      showErrorBorder: true,
      errorType: AdminRegisterErrorType.none,
    );

    final local = state.emailLocalPart.trim();
    if (local.isEmpty) return;

    if (state.isSendingCode) return;

    final email = '$local@dsm.hs.kr';
    final repo = ref.read(adminAuthRepositoryProvider);

    state = state.copyWith(isSendingCode: true);

    try {
      await repo.sendEmailVerifyCode(email: email);

      state = state.copyWith(codeSent: true);
      _startVerifyExpiry(seconds: 300);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        state = state.copyWith(errorType: AdminRegisterErrorType.network);
      } else {
        state = state.copyWith(errorType: AdminRegisterErrorType.unknown);
      }
    } catch (_) {
      state = state.copyWith(errorType: AdminRegisterErrorType.unknown);
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

  Future<void> nextToPassword() async {
    state = state.copyWith(
      showErrorBorder: true,
      errorType: AdminRegisterErrorType.none,
    );
    if (!state.canGoNextInfo) return;

    final email = '${state.emailLocalPart.trim()}@dsm.hs.kr';
    final code = state.verifyCode.trim();
    final repo = ref.read(adminAuthRepositoryProvider);

    try {
      await repo.matchEmailVerifyCode(email: email, verifyCode: code);

      state = state.copyWith(
        step: AdminRegisterStep.password,
        showErrorBorder: false,
        errorType: AdminRegisterErrorType.none,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 403) {
        state = state.copyWith(
          errorType: AdminRegisterErrorType.verifyCodeMismatchOrNotFound,
        );
        return;
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        state = state.copyWith(errorType: AdminRegisterErrorType.network);
        return;
      }

      state = state.copyWith(errorType: AdminRegisterErrorType.unknown);
    } catch (_) {
      state = state.copyWith(errorType: AdminRegisterErrorType.unknown);
    }
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
      errorType: AdminRegisterErrorType.none,
    );
  }

  void prepareExitToRoot() {
    state = state.copyWith(
      step: AdminRegisterStep.info,
      showErrorBorder: false,
      errorType: AdminRegisterErrorType.none,
    );
  }

  void reset() => state = const AdminRegisterState();
}
