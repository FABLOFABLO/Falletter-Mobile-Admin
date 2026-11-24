import 'package:falletter_mobile_admin/core/error/app_error_type.dart';

class AppException implements Exception {
  final AppErrorType type;
  final String message;
  final int? statusCode;

  AppException(this.type, this.message, {this.statusCode});

  @override
  String toString() => 'AppException($type, $statusCode): $message';
}
