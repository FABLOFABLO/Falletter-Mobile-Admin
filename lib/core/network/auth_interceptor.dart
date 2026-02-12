import 'dart:async';
import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/network/auth_api.dart';
import 'package:falletter_mobile_admin/core/util/jwt_utils.dart';
import 'package:falletter_mobile_admin/feature/auth/data/datasource/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final TokenStorage _storage;
  final AuthApi _authApi;

  AuthInterceptor({
    required Dio dio,
    required TokenStorage storage,
    required AuthApi authApi,
  }) : _dio = dio,
       _storage = storage,
       _authApi = authApi;

  bool _refreshing = false;
  final List<Completer<String>> _waiters = [];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    final access = await _storage.readAccessToken();
    if (access != null && access.isNotEmpty && !JwtUtils.isExpired(access)) {
      options.headers['Authorization'] = 'Bearer $access';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final is401 = status == 401;

    if (!is401) return handler.next(err);

    if (err.requestOptions.path.contains('/auth/refresh')) {
      await _storage.clear();
      return handler.next(err);
    }

    final refresh = await _storage.readRefreshToken();
    if (refresh == null || refresh.isEmpty || JwtUtils.isExpired(refresh)) {
      await _storage.clear();
      return handler.next(err);
    }

    try {
      final newAccess = await _getNewAccessToken(refresh);

      final req = err.requestOptions;
      req.headers['Authorization'] = 'Bearer $newAccess';

      final response = await _dio.fetch(req);
      return handler.resolve(response);
    } catch (_) {
      await _storage.clear();
      return handler.next(err);
    }
  }

  Future<String> _getNewAccessToken(String refreshToken) async {
    if (_refreshing) {
      final c = Completer<String>();
      _waiters.add(c);
      return c.future;
    }

    _refreshing = true;
    try {
      final data = await _authApi.refresh(refreshToken);

      final newAccess = data['access_token'] as String;
      final newRefresh = data['refresh_token'] as String;

      await _storage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      for (final w in _waiters) {
        if (!w.isCompleted) w.complete(newAccess);
      }
      _waiters.clear();

      return newAccess;
    } catch (e) {
      for (final w in _waiters) {
        if (!w.isCompleted) w.completeError(e);
      }
      _waiters.clear();
      rethrow;
    } finally {
      _refreshing = false;
    }
  }
}
