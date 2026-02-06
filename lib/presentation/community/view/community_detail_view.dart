import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/card/detail_card.dart';
import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/presentation/community/widget/comment_item.dart';
import 'package:falletter_mobile_admin/presentation/community/widget/community_post_item.dart';
import 'package:flutter/material.dart';

class CommunityDetailView extends StatefulWidget {
  final dynamic post;
  final void Function(PostMenuAction action)? onMenu;
  final VoidCallback onDelete;

  const CommunityDetailView({
    super.key,
    required this.post,
    this.onMenu,
    required this.onDelete,
  });

  @override
  State<CommunityDetailView> createState() => _CommunityDetailViewState();
}

class _CommunityDetailViewState extends State<CommunityDetailView> {
  late List<_CommentUi> comments;
  late bool isPostDeleted;

  @override
  void initState() {
    super.initState();
    isPostDeleted = widget.post.deletedByAdmin;
    comments = List.generate(
      10,
      (i) => _CommentUi(
        author: '댓글 작성자 $i',
        timeText: '10분전',
        content: '댓글 내용입니다.',
      ),
    );
  }

  void _openBanModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DefaultModal(
        model: DefaultModalUiModel.ban(),
        onConfirmBan: (days, reason) => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    writer: widget.post.author,
                    timeText: widget.post.timeText,
                    title: widget.post.title,
                    content: widget.post.preview,
                    badge: isPostDeleted
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
                    onMenuSelected: (action) {
                      if (action == PostMenuAction.delete) {
                        setState(() => isPostDeleted = true);
                        widget.onDelete();
                      } else if (action == PostMenuAction.ban) {
                        _openBanModal(context);
                      }
                      widget.onMenu?.call(action);
                    },
                  ),

                  const SizedBox(height: 6),

                  ...comments.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final c = entry.value;
                    return CommentItem(
                      author: c.author,
                      timeText: c.timeText,
                      content: c.content,
                      badge: c.deletedByAdmin,
                      onMenu: (action) {
                        if (action == CommentMenuAction.delete) {
                          setState(() {
                            comments[idx] = comments[idx].copyWith(
                              deletedByAdmin: true,
                            );
                          });
                        } else if (action == CommentMenuAction.ban) {
                          _openBanModal(context);
                        }
                      },
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

class _CommentUi {
  final String author;
  final String timeText;
  final String content;
  final bool deletedByAdmin;

  const _CommentUi({
    required this.author,
    required this.timeText,
    required this.content,
    this.deletedByAdmin = false,
  });

  _CommentUi copyWith({bool? deletedByAdmin}) {
    return _CommentUi(
      author: author,
      timeText: timeText,
      content: content,
      deletedByAdmin: deletedByAdmin ?? this.deletedByAdmin,
    );
  }
}
