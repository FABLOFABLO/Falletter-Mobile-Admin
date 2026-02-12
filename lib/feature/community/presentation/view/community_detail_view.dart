import 'dart:async';

import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/card/detail_card.dart';
import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/provider/sanction_action_provider.dart';
import 'package:falletter_mobile_admin/feature/community/presentation/provider/community_action_provider.dart';
import 'package:falletter_mobile_admin/feature/community/presentation/provider/community_marks_provider.dart';
import 'package:falletter_mobile_admin/feature/community/presentation/provider/community_provider.dart';
import 'package:falletter_mobile_admin/feature/community/presentation/widget/comment_item.dart';
import 'package:falletter_mobile_admin/feature/community/presentation/widget/community_post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityDetailView extends ConsumerWidget {
  final String postId;

  const CommunityDetailView({super.key, required this.postId});

  void _openBanModalForUser(
    BuildContext context,
    WidgetRef ref, {
    required int userId,
    required VoidCallback onMarkedBanned,
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
          onMarkedBanned();
        },
        onConfirmLogout: null,
      ),
    );
  }

  Future<void> _onPostMenu(
    BuildContext context,
    WidgetRef ref,
    PostUi post,
    PostMenuAction action,
  ) async {
    switch (action) {
      case PostMenuAction.warn:
        await ref.read(sanctionActionProvider.notifier).warn(post.authorUserId);
        ref.read(communityMarksProvider.notifier).markPostWarned(postId, true);
        break;

      case PostMenuAction.ban:
        _openBanModalForUser(
          context,
          ref,
          userId: post.authorUserId,
          onMarkedBanned: () => ref
              .read(communityMarksProvider.notifier)
              .markPostBanned(postId, true),
        );
        break;

      case PostMenuAction.delete:
        await ref.read(communityActionProvider.notifier).deletePost(postId);
        break;
    }
  }

  Future<void> _onCommentMenu(
    BuildContext context,
    WidgetRef ref,
    CommentUi comment,
    CommentMenuAction action,
  ) async {
    switch (action) {
      case CommentMenuAction.warn:
        await ref
            .read(sanctionActionProvider.notifier)
            .warn(comment.authorUserId);
        ref
            .read(communityMarksProvider.notifier)
            .markCommentWarned(postId, comment.id, true);
        break;

      case CommentMenuAction.ban:
        _openBanModalForUser(
          context,
          ref,
          userId: comment.authorUserId,
          onMarkedBanned: () => ref
              .read(communityMarksProvider.notifier)
              .markCommentBanned(postId, comment.id, true),
        );
        break;

      case CommentMenuAction.delete:
        ref
            .read(communityMarksProvider.notifier)
            .markCommentDeletedByAdmin(postId, comment.id, true);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityPostDetailProvider(postId));

    return state.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        backgroundColor: FalletterColor.background,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(showBack: true, showLogout: false),
              Expanded(child: Center(child: Text('게시글을 불러오는 중 오류가 발생했어요: $e'))),
            ],
          ),
        ),
      ),
      data: (detail) {
        final post = detail.post;
        final comments = detail.comments;

        final menuItems = MoreAction.buildItems<PostMenuAction>([
          MoreActionItem<PostMenuAction>(
            value: PostMenuAction.warn,
            text: '경고',
          ),
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
                        onMenuSelected: (action) => _onPostMenu(
                          context,
                          ref,
                          post,
                          action as PostMenuAction,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...comments.map((comment) {
                        return CommentItem(
                          author: comment.author,
                          timeText: comment.timeText,
                          content: comment.content,
                          badge: comment.deletedByAdmin,
                          onMenu: (action) =>
                              _onCommentMenu(context, ref, comment, action),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
