import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/card/base_card_list.dart';
import 'package:falletter_mobile_admin/core/components/card/card_atoms.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

enum StudentMenuAction { warn, ban }

class StudentListItem extends StatefulWidget {
  final String numberName;
  final String genderLabel;
  final bool isFemale;
  final List<SanctionSummary> sanctions;
  final VoidCallback? onTapDetail;
  final void Function(StudentMenuAction action)? onMenu;

  const StudentListItem({
    super.key,
    required this.numberName,
    required this.genderLabel,
    required this.isFemale,
    this.sanctions = const [],
    this.onTapDetail,
    this.onMenu,
  });

  @override
  State<StudentListItem> createState() => _StudentListItemState();
}

class _StudentListItemState extends State<StudentListItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final badgeChip = BadgeChip(
      text: widget.genderLabel,
      badgeColor: widget.isFemale ? FalletterColor.red : FalletterColor.blue,
    );

    return BaseCardList(
      onTap: () => setState(() => _expanded = !_expanded),
      leading: const Profile(),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.numberName, style: FalletterTextStyle.title3),
          const SizedBox(width: 8),
          badgeChip,
        ],
      ),
      menuItems: MoreAction.buildItems<StudentMenuAction>([
        const MoreActionItem(value: StudentMenuAction.warn, text: '경고'),
        const MoreActionItem(value: StudentMenuAction.ban, text: '정지'),
      ]),
      onMenuSelected: (v) {
        if (v is StudentMenuAction) {
          widget.onMenu?.call(v);
        }
      },
      body: _expanded
          ? _SanctionPager(
        sanctions: widget.sanctions,
        onTapDetail: widget.onTapDetail,
      )
          : const SizedBox.shrink(),
    );
  }
}

class SanctionSummary {
  final String type;
  final String dateText;
  final String? countText;

  const SanctionSummary({
    required this.type,
    required this.dateText,
    this.countText,
  });
}

class _SanctionPager extends StatefulWidget {
  final List<SanctionSummary> sanctions;
  final VoidCallback? onTapDetail;

  const _SanctionPager({
    required this.sanctions,
    this.onTapDetail,
  });

  @override
  State<_SanctionPager> createState() => _SanctionPagerState();
}

class _SanctionPagerState extends State<_SanctionPager> {
  late final PageController _controller = PageController();
  int _page = 0;

  List<List<SanctionSummary>> _chunk(List<SanctionSummary> list, int size) {
    if (list.isEmpty) return const [];
    final result = <List<SanctionSummary>>[];
    for (var i = 0; i < list.length; i += size) {
      result.add(list.sublist(i, (i + size).clamp(0, list.length)));
    }
    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sanctions = widget.sanctions;

    if (sanctions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Text(
            '제재 내역이 없습니다.',
            style: FalletterTextStyle.body4.copyWith(
              color: FalletterColor.gray600,
            ),
          ),
        ),
      );
    }

    final pages = _chunk(sanctions, 4);

    return Column(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, pageIndex) {
              final list = pages[pageIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list.map((s) {
                  final isBan = s.type == '정지';
                  final rightWidget = isBan
                      ? GestureDetector(
                    onTap: widget.onTapDetail,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '내역보기',
                        style: FalletterTextStyle.body4.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: FalletterColor.gray600,
                          color: FalletterColor.gray600,
                        ),
                      ),
                    ),
                  )
                      : (s.countText != null)
                      ? Text(
                    s.countText!,
                    style: FalletterTextStyle.body4.copyWith(
                      color: FalletterColor.red,
                    ),
                  )
                      : const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                s.type,
                                style: FalletterTextStyle.body3.copyWith(
                                  color: isBan
                                      ? FalletterColor.red
                                      : FalletterColor.yellow,
                                ),
                              ),
                              const Spacer(),
                              rightWidget,
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s.dateText,
                            style: FalletterTextStyle.body4.copyWith(
                              color: FalletterColor.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pages.length, (i) {
            final selected = i == _page;
            return Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? FalletterColor.black : FalletterColor.gray500,
              ),
            );
          }),
        ),
      ],
    );
  }
}
