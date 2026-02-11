import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter_mobile_admin/core/network/admin_user_api.dart';
import 'package:falletter_mobile_admin/core/network/dio.dart';

// ✅ 추가
import 'package:falletter_mobile_admin/presentation/students/provider/students_provider.dart';

final adminUserApiProvider = Provider<AdminUserApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AdminUserApi(dioClient.dio);
});

final sanctionActionProvider =
    StateNotifierProvider<SanctionActionNotifier, AsyncValue<void>>(
      (ref) => SanctionActionNotifier(ref),
    );

class SanctionActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  SanctionActionNotifier(this._ref) : super(const AsyncData(null));

  Future<void> warn(int userId) async {
    state = const AsyncLoading();
    try {
      await _ref.read(adminUserApiProvider).giveWarning(userId);
      _ref.invalidate(studentsListProvider);
      _ref.invalidate(studentDetailProvider(userId));

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> block({
    required int userId,
    required int days,
    required String reason,
  }) async {
    state = const AsyncLoading();
    try {
      await _ref
          .read(adminUserApiProvider)
          .giveBlock(userId: userId, days: days, reason: reason);
      _ref.invalidate(studentsListProvider);
      _ref.invalidate(studentDetailProvider(userId));

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
