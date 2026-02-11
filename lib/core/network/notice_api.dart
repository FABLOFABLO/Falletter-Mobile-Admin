import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/network/api_endpoints.dart';

class NoticeApi {
  final Dio _dio;
  NoticeApi(this._dio);

  Future<List<Map<String, dynamic>>> fetchNoticesRaw() async {
    final res = await _dio.get(ApiEndpoints.notice);

    final data = res.data;
    if (data is List) {
      return data.map((e) => (e as Map).cast<String, dynamic>()).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> fetchNoticeDetailRaw(int id) async {
    final res = await _dio.get(
      ApiEndpoints.noticeDetailDelete(id.toString()),
    );

    return (res.data as Map).cast<String, dynamic>();
  }

  Future<void> createNotice({
    required String title,
    required String content,
  }) async {
    await _dio.post(
      ApiEndpoints.notice,
      data: {
        "title": title,
        "content": content,
      },
    );
  }

  Future<void> deleteNotice(int id) async {
    await _dio.delete(
      ApiEndpoints.noticeDetailDelete(id.toString()),
    );
  }
}