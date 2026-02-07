import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/card/card_atoms.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/presentation/students/model/sanction_summary.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum StudentMenuAction { warn, ban }

const EdgeInsets _kCardPadding20 = EdgeInsets.all(20);
const double _kCardRadius8 = 8;

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(_kCardRadius8),
        child: InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(_kCardRadius8),
          child: Container(
            padding: _kCardPadding20,
            decoration: BoxDecoration(
              color: FalletterColor.middleWhite,
              borderRadius: BorderRadius.circular(_kCardRadius8),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Profile(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.numberName,
                            style: FalletterTextStyle.title3,
                          ),
                          const SizedBox(width: 8),
                          badgeChip,
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<StudentMenuAction>(
                      color: FalletterColor.middleWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_kCardRadius8),
                      ),
                      elevation: 0,
                      itemBuilder: (_) =>
                          MoreAction.buildItems<StudentMenuAction>([
                            const MoreActionItem(
                              value: StudentMenuAction.warn,
                              text: '경고',
                            ),
                            const MoreActionItem(
                              value: StudentMenuAction.ban,
                              text: '정지',
                            ),
                          ]),
                      onSelected: (v) => widget.onMenu?.call(v),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Symbols.more_vert),
                      ),
                    ),
                  ],
                ),
                if (_expanded) ...[
                  const SizedBox(height: 10),
                  SanctionPager(
                    sanctions: widget.sanctions,
                    onTapDetail: widget.onTapDetail,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
