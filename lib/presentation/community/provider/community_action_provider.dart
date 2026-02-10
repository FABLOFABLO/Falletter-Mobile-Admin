import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter_mobile_admin/presentation/community/provider/community_provider.dart';

final communityActionProvider =
    StateNotifierProvider<CommunityActionNotifier, AsyncValue<void>>(
      (ref) => CommunityActionNotifier(ref),
    );

class CommunityActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  CommunityActionNotifier(this._ref) : super(const AsyncData(null));

  Future<void> deletePost(String postId) async {
    state = const AsyncLoading();
    try {
      final api = _ref.read(communityApiProvider);
      await api.deleteCommunityPost(postId);

      _ref.invalidate(communityPostsProvider);
      _ref.invalidate(communityPostDetailProvider(postId));

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
