import 'dart:async';

import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/provider/sanction_action_provider.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/presentation/community/provider/community_action_provider.dart';
import 'package:falletter_mobile_admin/presentation/community/provider/community_provider.dart';
import 'package:falletter_mobile_admin/presentation/community/provider/community_marks_provider.dart';
import 'package:falletter_mobile_admin/presentation/community/widget/community_post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FalletterCommunityView extends ConsumerWidget {
  const FalletterCommunityView({super.key});

  void _openBanModal(
    BuildContext context,
    WidgetRef ref, {
    required String postId,
    required int userId,
  }) {
    showDialog(
      context: context,
      builder: (_) => DefaultModal(
        model: DefaultModalUiModel.ban(),
        onConfirmBan: (days, reason) {
          unawaited(
            ref
                .read(sanctionActionProvider.notifier)
                .block(userId: userId, days: days, reason: reason),
          );
          ref
              .read(communityMarksProvider.notifier)
              .markPostBanned(postId, true);
        },
        onConfirmLogout: null,
      ),
    );
  }

  Future<void> _onPostMenu(
    BuildContext context,
    WidgetRef ref, {
    required String postId,
    required int userId,
    required PostMenuAction action,
  }) async {
    switch (action) {
      case PostMenuAction.warn:
        await ref.read(sanctionActionProvider.notifier).warn(userId);
        ref.read(communityMarksProvider.notifier).markPostWarned(postId, true);
        break;

      case PostMenuAction.ban:
        _openBanModal(context, ref, postId: postId, userId: userId);
        break;

      case PostMenuAction.delete:
        await ref.read(communityActionProvider.notifier).deletePost(postId);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityPostsProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('커뮤니티를 불러오는 중 오류가 발생했어요', style: FalletterTextStyle.body2),
      ),
      data: (posts) {
        if (posts.isEmpty) {
          return Text('아직 작성된 글이 없어요.', style: FalletterTextStyle.body2);
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final p = posts[index];

            return CommunityPostItem(
              title: p.title,
              preview: p.preview,
              author: p.author,
              timeText: p.timeText,
              commentCount: p.commentCount,
              badge: p.deletedByAdmin,
              onMenu: (action) => _onPostMenu(
                context,
                ref,
                postId: p.id,
                userId: p.authorUserId,
                action: action,
              ),
              onTap: () =>
                  context.push(RouterPath.communityDetail, extra: p.id),
            );
          },
        );
      },
    );
  }
}
