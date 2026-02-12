import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter_mobile_admin/core/network/api_endpoints.dart';
import 'package:falletter_mobile_admin/core/network/auth_api.dart';
import 'package:falletter_mobile_admin/core/network/auth_interceptor.dart';
import 'package:falletter_mobile_admin/feature/splash/presentation/provider/auth_status_provider.dart';

class DioClient {
  final Dio dio;

  DioClient({required Ref ref})
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          headers: {Headers.acceptHeader: Headers.jsonContentType},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onError: (e, handler) {
          handler.next(e);
        },
      ),
    );

    final storage = ref.read(tokenStorageProvider);
    final authApi = AuthApi(dio);

    dio.interceptors.add(
      AuthInterceptor(dio: dio, storage: storage, authApi: authApi),
    );
  }
}

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref: ref);
});
