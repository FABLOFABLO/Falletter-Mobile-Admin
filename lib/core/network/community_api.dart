import 'package:dio/dio.dart';
import 'package:falletter_mobile_admin/core/error/dio_error_mapper.dart';
import 'package:falletter_mobile_admin/core/network/api_endpoints.dart';

class CommunityApi {
  final Dio _dio;

  CommunityApi(this._dio);

  Future<List<Map<String, dynamic>>> fetchPostsRaw() => guardApi(() async {
    final res = await _dio.get(ApiEndpoints.communityPosts);
    final List data = res.data as List;
    return data.map((e) => (e as Map).cast<String, dynamic>()).toList();
  });

  Future<Map<String, dynamic>> fetchPostDetailRaw(String postId) =>
      guardApi(() async {
        final res = await _dio.get(ApiEndpoints.communityPostDetail(postId));
        return (res.data as Map).cast<String, dynamic>();
      });

  Future<void> deleteCommunityPost(String communityId) => guardApi(() async {
    await _dio.patch(ApiEndpoints.communityDelete(communityId));
  });
}
