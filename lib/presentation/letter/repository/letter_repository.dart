import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/network/api_endpoints.dart';
import 'package:falletter_mobile_admin/core/network/dio.dart';
import 'package:falletter_mobile_admin/presentation/letter/model/letter_unpassed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final letterRepositoryProvider = Provider<LetterRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return LetterRepository(dioClient: dioClient);
});

class LetterRepository {
  final DioClient dioClient;

  LetterRepository({required this.dioClient});

  Future<List<LetterUnpassed>> fetchUnpassedLetters() async {
    try {
      final res = await dioClient.dio.get(ApiEndpoints.letterUnpassed);

      final data = res.data;
      if (data is List) {
        return data
            .map(
              (e) =>
                  LetterUnpassed.fromJson((e as Map).cast<String, dynamic>()),
            )
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw e;
    }
  }

  Future<LetterUnpassedDetail> fetchUnpassedLetterDetail({
    required int letterId,
  }) async {
    try {
      final res = await dioClient.dio.get(
        ApiEndpoints.letterUnpassedDetail(letterId.toString()),
      );

      final data = (res.data as Map).cast<String, dynamic>();
      return LetterUnpassedDetail.fromJson(data);
    } on DioException catch (e) {
      throw e;
    }
  }
}
