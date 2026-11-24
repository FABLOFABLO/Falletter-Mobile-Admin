import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/error/app_error_type.dart';
import 'package:falletter_mobile_admin/core/error/app_exception.dart';

extension DioErrorMapper on DioException {
  AppException toAppException() {
    final status = response?.statusCode;

    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.connectionError) {
      return AppException(AppErrorType.network, "네트워크 오류가 발생했습니다.");
    }

    if (status == 400) {
      return AppException(
        AppErrorType.badRequest,
        "잘못된 요청",
        statusCode: status,
      );
    }
    if (status == 401) {
      return AppException(
        AppErrorType.unauthorized,
        "인증 실패",
        statusCode: status,
      );
    }
    if (status == 403) {
      return AppException(AppErrorType.forbidden, "권한 없음", statusCode: status);
    }
    if (status == 404) {
      return AppException(AppErrorType.notFound, "찾을 수 없음", statusCode: status);
    }
    if (status != null && status >= 500) {
      return AppException(AppErrorType.server, "서버 오류", statusCode: status);
    }

    return AppException(
      AppErrorType.unknown,
      "알 수 없는 오류가 발생했습니다. (${status ?? message ?? "no status"})",
      statusCode: status,
    );
  }
}

Future<T> guardApi<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on AppException {
    rethrow;
  } on DioException catch (e) {
    throw e.toAppException();
  } catch (e) {
    throw AppException(AppErrorType.unknown, "응답 처리 중 오류: $e");
  }
}
