import 'package:falletter_mobile_admin/feature/community/data/repository/community_repository.dart';
import 'package:falletter_mobile_admin/feature/community/domain/model/community_ui_models.dart';
import 'package:falletter_mobile_admin/feature/community/presentation/provider/community_marks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter_mobile_admin/core/network/dio.dart';
import 'package:falletter_mobile_admin/core/network/community_api.dart';

final communityApiProvider = Provider<CommunityApi>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return CommunityApi(dio);
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final api = ref.watch(communityApiProvider);
  return CommunityRepository(api: api);
});

final communityPostsProvider =
FutureProvider.autoDispose<List<PostUi>>((ref) async {
  final repo = ref.watch(communityRepositoryProvider);
  final marks = ref.watch(communityMarksProvider);
  return repo.fetchPosts(marks: marks);
});

final communityPostDetailProvider =
FutureProvider.autoDispose.family<PostDetailUi, String>((ref, postId) async {
  final repo = ref.watch(communityRepositoryProvider);
  final marks = ref.watch(communityMarksProvider);
  return repo.fetchPostDetail(postId: postId, marks: marks);
});