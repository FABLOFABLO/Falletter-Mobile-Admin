import 'dart:async';
import 'package:falletter_mobile_admin/core/network/api_endpoints.dart';
import 'package:falletter_mobile_admin/presentation/auth/repository/admin_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter_mobile_admin/core/network/dio.dart';

final adminLogoutProvider =
StateNotifierProvider<AdminLogoutNotifier, AsyncValue<void>>(
      (ref) => AdminLogoutNotifier(ref),
);

class AdminLogoutNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AdminLogoutNotifier(this._ref) : super(const AsyncData(null));

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      final repo = _ref.read(adminAuthRepositoryProvider);
      await repo.logout();

      _ref.read(accessTokenProvider.notifier).state = null;
      _ref.read(refreshTokenProvider.notifier).state = null;

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
