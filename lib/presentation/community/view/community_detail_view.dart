import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/presentation/community/widget/community_post_item.dart';
import 'package:falletter_mobile_admin/presentation/community/widget/comment_item.dart';
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
      5,
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
    return Scaffold(
      backgroundColor: FalletterColor.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(showBack: true, showLogout: false),
            Expanded(
              child: ListView(
                children: [
                  CommunityPostItem(
                    title: widget.post.title,
                    preview: widget.post.preview,
                    author: widget.post.author,
                    timeText: widget.post.timeText,
                    commentCount: widget.post.commentCount,
                    badge: isPostDeleted,
                    onMenu: (action) {
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
                    int idx = entry.key;
                    var c = entry.value;
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
