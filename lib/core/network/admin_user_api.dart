import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/network/api_endpoints.dart';

class AdminUserApi {
  final Dio _dio;

  AdminUserApi(this._dio);

  Future<Map<String, dynamic>> fetchStudentsRaw({
    required int page,
    required int size,
    List<String>? sort,
  }) async {
    final res = await _dio.get(
      ApiEndpoints.userAll,
      queryParameters: {
        'page': page,
        'size': size,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> fetchStudentDetailRaw(int userId) async {
    final res = await _dio.get(ApiEndpoints.userProfile(userId.toString()));
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<void> giveWarning(int userId) async {
    await _dio.post(ApiEndpoints.userWarn(userId.toString()));
  }

  Future<void> giveBlock({
    required int userId,
    required int days,
    required String reason,
  }) async {
    await _dio.post(
      ApiEndpoints.userBan(userId.toString()),
      data: {'days': days, 'reason': reason},
    );
  }
}
