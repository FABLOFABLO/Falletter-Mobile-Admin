import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/network/api_endpoints.dart';

class AuthApi {
  final Dio _dio;

  AuthApi(this._dio);

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final res = await _dio.post(
      ApiEndpoints.refreshToken,
      data: {"refresh_token": refreshToken},
      options: Options(headers: {"Authorization": null}),
    );

    return (res.data as Map<String, dynamic>);
  }
}
