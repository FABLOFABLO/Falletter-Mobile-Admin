import 'package:falletter_mobile_admin/feature/letter/data/repository/letter_repository.dart';
import 'package:falletter_mobile_admin/feature/letter/domain/model/letter_unpassed.dart';
import 'package:falletter_mobile_admin/feature/students/presentation/provider/students_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLabelProvider = AutoDisposeFutureProvider.family<String, int>((
  ref,
  userId,
) async {
  final detail = await ref.read(studentDetailProvider(userId).future);
  return '${detail.schoolNumber} ${detail.name}';
});

final unpassedLettersProvider = AutoDisposeFutureProvider<List<LetterUnpassed>>(
  (ref) async {
    final repo = ref.read(letterRepositoryProvider);
    final list = await repo.fetchUnpassedLetters();
    return list.where((e) => e.isPassed == false).toList();
  },
);

final unpassedLetterDetailProvider =
    AutoDisposeFutureProvider.family<LetterUnpassedDetail, int>((
      ref,
      letterId,
    ) async {
      final repo = ref.read(letterRepositoryProvider);
      return repo.fetchUnpassedLetterDetail(letterId: letterId);
    });
