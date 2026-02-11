import 'package:falletter_mobile_admin/presentation/students/model/student_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter_mobile_admin/core/network/admin_user_api.dart';
import 'package:falletter_mobile_admin/core/network/dio.dart';

final adminUserApiProvider = Provider<AdminUserApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AdminUserApi(dioClient.dio);
});

final studentsListProvider = FutureProvider<List<StudentSummary>>((ref) async {
  final api = ref.read(adminUserApiProvider);

  final json = await api.fetchStudentsRaw(page: 0, size: 50);

  final content = (json['content'] as List?) ?? const [];
  return content
      .whereType<Map>()
      .map((e) => StudentSummary.fromJson(e.cast<String, dynamic>()))
      .toList();
});

final studentDetailProvider =
FutureProvider.family<StudentDetail, int>((ref, userId) async {
  final api = ref.read(adminUserApiProvider);
  final json = await api.fetchStudentDetailRaw(userId);
  return StudentDetail.fromJson(json);
});

final userIdNameMapProvider = Provider<Map<int, String>>((ref) {
  final usersAsync = ref.watch(studentsListProvider);

  return usersAsync.maybeWhen(
    data: (students) => {
      for (final s in students) s.id: '${s.schoolNumber} ${s.name}',
    },
    orElse: () => const {},
  );
});