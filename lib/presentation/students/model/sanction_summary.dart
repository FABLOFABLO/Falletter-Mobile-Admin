import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class SanctionSummary {
  final String type;
  final String dateText;
  final String? countText;

  final String? reason;
  final DateTime? createdAt;
  final int? days;

  const SanctionSummary({
    required this.type,
    required this.dateText,
    this.countText,
    this.reason,
    this.createdAt,
    this.days,
  });
}

class SanctionPager extends StatefulWidget {
  final List<SanctionSummary> sanctions;
  final void Function(SanctionSummary sanction)? onTapDetail;

  const SanctionPager({super.key, required this.sanctions, this.onTapDetail});

  @override
  State<SanctionPager> createState() => _SanctionPagerState();
}

class _SanctionPagerState extends State<SanctionPager> {
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

  int _activeDotIndex(int totalPages, int currentPage) {
    if (totalPages <= 3) return currentPage;

    final last = totalPages - 1;
    if (currentPage == 0) return 0;
    if (currentPage == last) return 2;
    return 1;
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
    const double size = 6;
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
                          onTap: () => widget.onTapDetail?.call(s),
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

        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: () {
              final totalPages = pages.length;

              if (totalPages <= 1) return <Widget>[];

              if (totalPages <= 3) {
                return List.generate(totalPages, (i) {
                  final selected = i == _page;
                  return Container(
                    width: size,
                    height: size,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? FalletterColor.black
                          : FalletterColor.gray500,
                    ),
                  );
                });
              }

              final active = _activeDotIndex(totalPages, _page);
              return List.generate(3, (i) {
                final selected = i == active;
                return Container(
                  width: size,
                  height: size,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? FalletterColor.black
                        : FalletterColor.gray500,
                  ),
                );
              });
            }(),
          ),
        ),
      ],
    );
  }
}
