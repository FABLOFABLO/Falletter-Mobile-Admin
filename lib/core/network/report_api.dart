import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/error/dio_error_mapper.dart';
import 'package:falletter_mobile_admin/core/network/api_endpoints.dart';

class ReportApi {
  final Dio _dio;

  ReportApi(this._dio);

  /// 신고 목록 조회. [status]: PENDING | COMPLETED | REJECTED (null이면 전체)
  Future<List<Map<String, dynamic>>> fetchReportsRaw({String? status}) =>
      guardListApi(empty: [], () async {
        final res = await _dio.get(
          ApiEndpoints.report,
          queryParameters: {if (status != null) 'status': status},
        );
        final List data = res.data as List;
        return data.map((e) => (e as Map).cast<String, dynamic>()).toList();
      });

  /// 신고 처리 상태 변경
  Future<void> updateReportStatus({
    required int reportId,
    required String status,
  }) => guardApi(() async {
    await _dio.patch(
      ApiEndpoints.reportStatus(reportId.toString()),
      data: {'status': status},
    );
  });
}
