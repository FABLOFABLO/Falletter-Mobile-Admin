import 'package:falletter_mobile_admin/core/provider/sanction_action_provider.dart';
import 'package:falletter_mobile_admin/feature/students/presentation/provider/students_provider.dart' hide adminUserApiProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentsActionProvider =
StateNotifierProvider<StudentsActionNotifier, AsyncValue<void>>(
      (ref) => StudentsActionNotifier(ref),
);

class StudentsActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  StudentsActionNotifier(this._ref) : super(const AsyncData(null));

  Future<void> warn(int userId) async {
    state = const AsyncLoading();
    try {
      final api = _ref.read(adminUserApiProvider);
      await api.giveWarning(userId);
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
      final api = _ref.read(adminUserApiProvider);
      await api.giveBlock(
        userId: userId,
        days: days,
        reason: reason,
      );

      _ref.invalidate(studentsListProvider);
      _ref.invalidate(studentDetailProvider(userId));

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}