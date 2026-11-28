import 'dart:async';
import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/error/app_error_type.dart';
import 'package:falletter_mobile_admin/core/error/dio_error_mapper.dart';
import 'package:falletter_mobile_admin/feature/auth/data/repository/admin_auth_repository.dart';
import 'package:falletter_mobile_admin/feature/auth/domain/model/admin_auth_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  /// 스낵바로 보여줄 에러 문구. 화면에서 변경을 감지해 표시한다.
  final String? errorMessage;

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
    this.errorMessage,
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
    String? errorMessage,
    bool clearError = false,
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
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AdminRegisterNotifier extends Notifier<AdminRegisterState> {
  Timer? _verifyExpiryTimer;
  bool _isRegistering = false;

  @override
  AdminRegisterState build() {
    ref.onDispose(() {
      _verifyExpiryTimer?.cancel();
      _verifyExpiryTimer = null;
    });
    return const AdminRegisterState();
  }

  String _buildDsmEmail(String input) {
    final trimmed = input.trim();
    final local = trimmed.contains('@') ? trimmed.split('@').first : trimmed;
    return '$local@dsm.hs.kr';
  }

  void selectGender(Gender gender) => state = state.copyWith(gender: gender);
  void setName(String v) => state = state.copyWith(name: v);
  void setEmailLocalPart(String v) => state = state.copyWith(emailLocalPart: v);
  void setVerifyCode(String v) => state = state.copyWith(verifyCode: v);

  Future<void> sendVerifyCode() async {
    state = state.copyWith(showErrorBorder: true);

    final input = state.emailLocalPart;
    if (input.trim().isEmpty) return;
    if (state.isSendingCode) return;

    final email = _buildDsmEmail(input);
    final repo = ref.read(adminAuthRepositoryProvider);

    state = state.copyWith(isSendingCode: true, clearError: true);

    try {
      await repo.sendEmailVerifyCode(email: email);
      state = state.copyWith(codeSent: true);
      _startVerifyExpiry(seconds: 300);
    } on DioException catch (e) {
      state = state.copyWith(
        codeSent: false,
        errorMessage: _sendCodeErrorMessage(e),
      );
    } catch (_) {
      state = state.copyWith(codeSent: false, errorMessage: _unknownMessage);
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
    state = state.copyWith(showErrorBorder: true);
    if (!state.canGoNextInfo) return;

    final email = _buildDsmEmail(state.emailLocalPart);
    final code = state.verifyCode.trim();
    final repo = ref.read(adminAuthRepositoryProvider);
    state = state.copyWith(clearError: true);

    try {
      await repo.matchEmailVerifyCode(email: email, verifyCode: code);

      state = state.copyWith(
        step: AdminRegisterStep.password,
        showErrorBorder: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        showErrorBorder: true,
        errorMessage: e.response?.statusCode == 403
            ? '인증코드가 일치하지 않아요.'
            : _commonDioMessage(e),
      );
    } catch (_) {
      state = state.copyWith(
        showErrorBorder: true,
        errorMessage: _unknownMessage,
      );
    }
  }

  static const _unknownMessage = '알 수 없는 오류가 발생했어요.';

  /// 409는 "이미 가입된 이메일"과 "재발송 대기 시간 미경과" 두 경우라
  /// 서버 응답 message로 구분한다.
  String _sendCodeErrorMessage(DioException e) {
    if (e.response?.statusCode == 409) {
      final data = e.response?.data;
      final message = data is Map ? '${data['message'] ?? ''}' : '';
      if (message.toLowerCase().contains('too soon')) {
        return '잠시 후 다시 인증코드를 요청해주세요.';
      }
      return '이미 가입된 이메일이에요.';
    }
    return _commonDioMessage(e);
  }

  String _commonDioMessage(DioException e) => e.toAppException().type.message;

  void setPassword(String v) => state = state.copyWith(password: v);
  void setPasswordConfirm(String v) =>
      state = state.copyWith(passwordConfirm: v);

  void toggleObscurePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);

  void toggleObscurePasswordConfirm() => state = state.copyWith(
    obscurePasswordConfirm: !state.obscurePasswordConfirm,
  );

  Future<void> register() async {
    state = state.copyWith(showErrorBorder: true);
    if (!state.canRegister) return;

    if (_isRegistering) return;
    _isRegistering = true;
    state = state.copyWith(clearError: true);

    try {
      final gender = state.gender;
      if (gender == null) return;

      final email = _buildDsmEmail(state.emailLocalPart);

      final request = AdminSignUpRequest(
        email: email,
        password: state.password,
        name: state.name.trim(),
        gender: genderToApi(gender),
      );

      final repo = ref.read(adminAuthRepositoryProvider);
      await repo.signUp(request);

      state = state.copyWith(
        step: AdminRegisterStep.done,
        showErrorBorder: false,
      );
    } on AdminSignUpException catch (e) {
      state = state.copyWith(showErrorBorder: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        showErrorBorder: true,
        errorMessage: _unknownMessage,
      );
    } finally {
      _isRegistering = false;
    }
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
