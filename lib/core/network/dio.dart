import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/network/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accessTokenProvider = StateProvider<String?>((ref) => null);
final refreshTokenProvider = StateProvider<String?>((ref) => null);

class DioClient {
  late final Dio dio;

  DioClient({
    required String? accessToken,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          Headers.acceptHeader: Headers.jsonContentType,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          handler.next(options);
        },
        onError: (e, handler) {
          print('[DIO ERROR] ${e.response?.statusCode} ${e.requestOptions.uri}');
          print('[DIO ERROR DATA] ${e.response?.data}');
          handler.next(e);
        },
      ),
    );
  }
}

final dioClientProvider = Provider<DioClient>((ref) {
  final token = ref.watch(accessTokenProvider);
  return DioClient(accessToken: token);
});