import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/presentation/community/provider/community_provider.dart';
import 'package:falletter_mobile_admin/presentation/community/widget/community_post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FalletterCommunityView extends ConsumerWidget {
  const FalletterCommunityView({super.key});

  void _openBanModal(BuildContext context, WidgetRef ref, String postId) {
    showDialog(
      context: context,
      builder: (_) => DefaultModal(
        model: DefaultModalUiModel.ban(),
        onConfirmBan: (days, reason) {
          ref.read(communityProvider.notifier).updatePost(postId, banned: true);
        },
        onConfirmLogout: null,
      ),
    );
  }

  void _onPostMenu(BuildContext context, WidgetRef ref, String postId, PostMenuAction action) {
    switch (action) {
      case PostMenuAction.warn:
        ref.read(communityProvider.notifier).updatePost(postId, warned: true);
        break;
      case PostMenuAction.ban:
        _openBanModal(context, ref, postId);
        break;
      case PostMenuAction.delete:
        ref.read(communityProvider.notifier).updatePost(postId, deletedByAdmin: true);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(communityProvider).posts;

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
          onMenu: (action) => _onPostMenu(context, ref, p.id, action),
          onTap: () {
            context.push(RouterPath.communityDetail, extra: p.id);
          },
        );
      },
    );
  }
}