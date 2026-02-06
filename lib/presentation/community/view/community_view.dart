import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/presentation/community/view/community_detail_view.dart';
import 'package:falletter_mobile_admin/presentation/community/widget/community_post_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FalletterCommunityView extends StatefulWidget {
  const FalletterCommunityView({super.key});

  @override
  State<FalletterCommunityView> createState() => _FalletterCommunityViewState();
}

class _FalletterCommunityViewState extends State<FalletterCommunityView> {
  late List<_PostUi> posts;

  @override
  void initState() {
    super.initState();
    posts = List.generate(
      8,
      (i) => _PostUi(
        title: 'Title $i',
        preview: 'Text content...',
        author: '1411 이승현',
        timeText: '45분전',
        commentCount: 10,
      ),
    );
  }

  void _openBanModal() {
    showDialog(
      context: context,
      builder: (_) => DefaultModal(
        model: DefaultModalUiModel.ban(),
        onConfirmBan: (days, reason) {
          /// TODO: API 연결 시 여기서 요청
        },
        onConfirmLogout: null,
      ),
    );
  }

  void _onPostMenu(int index, PostMenuAction action) {
    switch (action) {
      case PostMenuAction.warn:
        break;
      case PostMenuAction.ban:
        _openBanModal();
        break;
      case PostMenuAction.delete:
        setState(() {
          posts[index] = posts[index].copyWith(deletedByAdmin: true);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          onMenu: (action) => _onPostMenu(index, action),
          onTap: () {
            context.push(RouterPath.communityDetail, extra: posts[index]);
          },
        );
      },
    );
  }
}

class _PostUi {
  final String title;
  final String preview;
  final String author;
  final String timeText;
  final int commentCount;
  final bool deletedByAdmin;

  const _PostUi({
    required this.title,
    required this.preview,
    required this.author,
    required this.timeText,
    required this.commentCount,
    this.deletedByAdmin = false,
  });

  _PostUi copyWith({bool? deletedByAdmin}) {
    return _PostUi(
      title: title,
      preview: preview,
      author: author,
      timeText: timeText,
      commentCount: commentCount,
      deletedByAdmin: deletedByAdmin ?? this.deletedByAdmin,
    );
  }
}
