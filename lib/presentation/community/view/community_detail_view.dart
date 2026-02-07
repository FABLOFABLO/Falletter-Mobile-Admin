import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/card/detail_card.dart';
import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/presentation/community/provider/community_provider.dart';
import 'package:falletter_mobile_admin/presentation/community/widget/comment_item.dart';
import 'package:falletter_mobile_admin/presentation/community/widget/community_post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityDetailView extends ConsumerWidget {
  final String postId;

  const CommunityDetailView({
    super.key,
    required this.postId,
  });

  void _openBanModal(BuildContext context, WidgetRef ref, {String? commentId}) {
    showDialog(
      context: context,
      builder: (_) => DefaultModal(
        model: DefaultModalUiModel.ban(),
        onConfirmBan: (days, reason) {
          if (commentId != null) {
            ref
                .read(communityProvider.notifier)
                .updateComment(postId, commentId, banned: true);
          } else {
            ref
                .read(communityProvider.notifier)
                .updatePost(postId, banned: true);
          }
        },
        onConfirmLogout: null,
      ),
    );
  }

  void _onPostMenu(BuildContext context, WidgetRef ref, PostMenuAction action) {
    switch (action) {
      case PostMenuAction.warn:
        ref.read(communityProvider.notifier).updatePost(postId, warned: true);
        break;
      case PostMenuAction.ban:
        _openBanModal(context, ref);
        break;
      case PostMenuAction.delete:
        ref
            .read(communityProvider.notifier)
            .updatePost(postId, deletedByAdmin: true);
        break;
    }
  }

  void _onCommentMenu(
    BuildContext context,
    WidgetRef ref,
    String commentId,
    CommentMenuAction action,
  ) {
    switch (action) {
      case CommentMenuAction.warn:
        ref
            .read(communityProvider.notifier)
            .updateComment(postId, commentId, warned: true);
        break;
      case CommentMenuAction.ban:
        _openBanModal(context, ref, commentId: commentId);
        break;
      case CommentMenuAction.delete:
        ref
            .read(communityProvider.notifier)
            .updateComment(postId, commentId, deletedByAdmin: true);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityState = ref.watch(communityProvider);
    final post = communityState.posts.firstWhere(
      (p) => p.id == postId,
      orElse: () => PostUi(
        id: '',
        title: '',
        preview: '',
        author: '',
        timeText: '',
        commentCount: 0,
      ),
    );
    final comments = communityState.comments[postId] ?? [];

    if (post.id.isEmpty) {
      return Scaffold(
        backgroundColor: FalletterColor.background,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(showBack: true, showLogout: false),
              Expanded(
                child: Center(
                  child: Text(
                    '게시글을 찾을 수 없습니다.',
                    style: FalletterTextStyle.body3,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final menuItems = MoreAction.buildItems<PostMenuAction>([
      MoreActionItem<PostMenuAction>(value: PostMenuAction.warn, text: '경고'),
      MoreActionItem<PostMenuAction>(value: PostMenuAction.ban, text: '정지'),
      MoreActionItem<PostMenuAction>(
        value: PostMenuAction.delete,
        text: '삭제',
        style: FalletterTextStyle.body3.copyWith(color: FalletterColor.red),
        showDivider: false,
      ),
    ]);

    return Scaffold(
      backgroundColor: FalletterColor.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(showBack: true, showLogout: false),
            Expanded(
              child: ListView(
                children: [
                  DetailCard(
                    writer: post.author,
                    timeText: post.timeText,
                    title: post.title,
                    content: post.preview,
                    badge: post.deletedByAdmin
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: FalletterColor.red),
                            ),
                            child: Text(
                              '관리자에 의해 삭제되었습니다',
                              style: FalletterTextStyle.body4.copyWith(
                                color: FalletterColor.red,
                              ),
                            ),
                          )
                        : null,
                    menuItems: menuItems,
                    onMenuSelected: (action) =>
                        _onPostMenu(context, ref, action),
                  ),
                  const SizedBox(height: 6),
                  ...comments.map((comment) {
                    return CommentItem(
                      author: comment.author,
                      timeText: comment.timeText,
                      content: comment.content,
                      badge: comment.deletedByAdmin,
                      onMenu: (action) =>
                          _onCommentMenu(context, ref, comment.id, action),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
