import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter_mobile_admin/feature/auth/data/repository/admin_auth_repository.dart';
import 'package:falletter_mobile_admin/feature/splash/presentation/provider/auth_status_provider.dart';

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

      final storage = _ref.read(tokenStorageProvider);
      await storage.clear();

      _ref.invalidate(authStatusProvider);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
