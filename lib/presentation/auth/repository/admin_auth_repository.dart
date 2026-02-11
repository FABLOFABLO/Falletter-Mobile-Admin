import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/network/api_endpoints.dart';
import 'package:falletter_mobile_admin/core/network/dio.dart';
import 'package:falletter_mobile_admin/presentation/auth/model/admin_auth_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminAuthRepositoryProvider = Provider<AdminAuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AdminAuthRepository(dioClient: dioClient);
});

class AdminAuthRepository {
  final DioClient dioClient;

  AdminAuthRepository({required this.dioClient});

  Future<void> signUp(AdminSignUpRequest request) async {
    try {
      await dioClient.dio.post(
        ApiEndpoints.signUp,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 409) {
        throw AdminSignUpException(
          AdminSignUpErrorType.emailAlreadyExists,
          "이미 존재하는 이메일입니다.",
        );
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw AdminSignUpException(
          AdminSignUpErrorType.network,
          "네트워크 오류가 발생했습니다.",
        );
      }

      throw AdminSignUpException(
        AdminSignUpErrorType.unknown,
        "알 수 없는 오류가 발생했습니다. (${status ?? "no status"})",
      );
    } catch (_) {
      throw AdminSignUpException(
        AdminSignUpErrorType.unknown,
        "알 수 없는 오류가 발생했습니다.",
      );
    }
  }

  Future<AdminTokenResponse> signIn(AdminSignInRequest request) async {
    try {
      final res = await dioClient.dio.post(
        ApiEndpoints.signIn,
        data: request.toJson(),
      );

      final data = res.data;
      if (data is Map<String, dynamic>) {
        return AdminTokenResponse.fromJson(data);
      }

      throw AdminSignInException(
        AdminSignInErrorType.unknown,
        "응답 형식이 올바르지 않습니다.",
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 400) {
        throw AdminSignInException(
          AdminSignInErrorType.invalidCredential,
          "비밀번호 불일치",
        );
      }
      if (status == 403) {
        throw AdminSignInException(
          AdminSignInErrorType.notApproved,
          "승인되지 않은 어드민",
        );
      }
      if (status == 404) {
        throw AdminSignInException(
          AdminSignInErrorType.userNotFound,
          "어드민을 찾을 수 없음",
        );
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw AdminSignInException(
          AdminSignInErrorType.network,
          "네트워크 오류가 발생했습니다.",
        );
      }

      throw AdminSignInException(
        AdminSignInErrorType.unknown,
        "알 수 없는 오류가 발생했습니다. (${status ?? "no status"})",
      );
    } catch (_) {
      throw AdminSignInException(
        AdminSignInErrorType.unknown,
        "알 수 없는 오류가 발생했습니다.",
      );
    }
  }

  Future<void> logout() async {
    try {
      await dioClient.dio.delete(ApiEndpoints.logOut);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception('네트워크 오류로 로그아웃 실패');
      }
      throw Exception('로그아웃 실패: ${e.response?.statusCode}');
    }
  }

  Future<void> sendEmailVerifyCode({required String email}) async {
    await dioClient.dio.post(
      ApiEndpoints.emailVerify,
      data: {"email": email},
    );
  }

  Future<void> matchEmailVerifyCode({
    required String email,
    required String verifyCode,
  }) async {
    await dioClient.dio.post(
      ApiEndpoints.emailMatch,
      data: {
        "email": email,
        "verify_code": verifyCode,
      },
    );
  }
}
