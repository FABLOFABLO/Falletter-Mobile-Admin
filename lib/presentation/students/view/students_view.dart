import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/components/text_form_field/text_form_field.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/presentation/students/widget/student_list_item.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class FalletterStudentsView extends StatefulWidget {
  const FalletterStudentsView({super.key});

  @override
  State<FalletterStudentsView> createState() => _FalletterStudentsViewState();
}

class _FalletterStudentsViewState extends State<FalletterStudentsView> {
  final _searchController = TextEditingController();
  final Set<int> _selectedGrades = {};

  late final List<_StudentUi> _allStudents = [
    _StudentUi(
      grade: 1,
      numberName: '1401 김수인',
      isFemale: true,
      sanctions: [
        SanctionSummary(type: '정지', dateText: '12월 15일', countText: null),
        SanctionSummary(type: '경고', dateText: '12월 15일', countText: '+1'),
        SanctionSummary(type: '경고', dateText: '12월 15일', countText: '+1'),
        SanctionSummary(type: '경고', dateText: '12월 15일', countText: '+1'),
        SanctionSummary(type: '경고', dateText: '12월 15일', countText: '+1'),
      ],
    ),
    const _StudentUi(
      grade: 1,
      numberName: '1300 이강희',
      isFemale: false,
      sanctions: [],
    ),
    const _StudentUi(
      grade: 1,
      numberName: '1403 김지윤',
      isFemale: true,
      sanctions: [],
    ),
    const _StudentUi(
      grade: 1,
      numberName: '1300 권수현',
      isFemale: false,
      sanctions: [],
    ),
    const _StudentUi(
      grade: 2,
      numberName: '2400 최승우',
      isFemale: true,
      sanctions: [],
    ),
    const _StudentUi(
      grade: 3,
      numberName: '3400 최승우',
      isFemale: true,
      sanctions: [],
    ),
    const _StudentUi(
      grade: 3,
      numberName: '3400 최승우',
      isFemale: true,
      sanctions: [],
    ),
  ];

  List<_StudentUi> get _filtered {
    final q = _searchController.text.trim();
    return _allStudents.where((s) {
      final byGrade =
      _selectedGrades.isEmpty ? true : _selectedGrades.contains(s.grade);
      final byQuery = q.isEmpty ? true : s.numberName.contains(q);
      return byGrade && byQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSanctionDetailModal(BuildContext context, _StudentUi student) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _SanctionDetailModal(
        dateText: '12월 15일',
        content: 'Lorem ipsum mi fringilla massa at purus fermentum lectus rhoncus lectus rhoncus\n'
            'nunc sit nam ut et nunc lectus elit elit urna\n'
            'leo placerat quis elit ipsum sed amet nec\n'
            'nunc in viverra leo vitae odio habitant quis\n'
            'sed auctor.',
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

  void _onStudentMenu(StudentMenuAction action) {
    if (action == StudentMenuAction.ban) {
      _openBanModal();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FalletterColor.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: '학생 검색',
                        contentPadding: EdgeInsets.all(12),
                        suffixIcon: Icon(
                          Symbols.search,
                          size: 22,
                          color: FalletterColor.gray600,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (_selectedGrades.toList()..sort())
                                .map(
                                  (g) => _GradeChip(
                                text: '${g}학년',
                                onRemove: () => setState(
                                      () => _selectedGrades.remove(g),
                                ),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                        PopupMenuButton<int>(
                          offset: const Offset(0, 44),
                          color: FalletterColor.gray100,
                          elevation: 0,
                          itemBuilder: (context) =>
                              MoreAction.buildItems<int>([
                                const MoreActionItem(value: 1, text: '1학년'),
                                const MoreActionItem(value: 2, text: '2학년'),
                                const MoreActionItem(value: 3, text: '3학년'),
                              ]),
                          onSelected: (v) {
                            setState(() {
                              if (_selectedGrades.contains(v)) {
                                _selectedGrades.remove(v);
                              } else {
                                _selectedGrades.add(v);
                              }
                            });
                          },
                          child: SizedBox(
                            width: 40,
                            height: 44,
                            child: const Center(
                              child: Icon(
                                Symbols.tune,
                                size: 22,
                                color: FalletterColor.gray800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final s = items[index];

                    return StudentListItem(
                      numberName: s.numberName,
                      genderLabel: s.isFemale ? '여학생' : '남학생',
                      isFemale: s.isFemale,
                      sanctions: s.sanctions,
                      onTapDetail: () => _openSanctionDetailModal(context, s),
                      onMenu: _onStudentMenu,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeChip extends StatelessWidget {
  final String text;
  final VoidCallback onRemove;

  const _GradeChip({required this.text, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: FalletterColor.black, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style:
            FalletterTextStyle.body4
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Symbols.x_circle,
                size: 16, color: FalletterColor.red),
          ),
        ],
      ),
    );
  }
}

class _SanctionDetailModal extends StatelessWidget {
  final String content;
  final String dateText;

  const _SanctionDetailModal({
    required this.content,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    final closeButtonSize = MediaQuery.of(context).size.width * 0.13;
    const divider = Divider(color: FalletterColor.gray200, height: 1);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: FalletterColor.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: FalletterColor.black, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '제재 내역',
                    style: FalletterTextStyle.body3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  divider,
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      content,
                      style: FalletterTextStyle.body4
                    ),
                  ),
                  const SizedBox(height: 18),
                  divider,
                  const SizedBox(height: 14),
                  Text(
                    dateText,
                    style: FalletterTextStyle.body4
                        .copyWith(color: FalletterColor.gray700),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: closeButtonSize,
                height: closeButtonSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: FalletterColor.gray400,
                ),
                child: const Center(
                  child: Icon(Symbols.close,
                      color: FalletterColor.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentUi {
  final int grade;
  final String numberName;
  final bool isFemale;
  final List<SanctionSummary> sanctions;

  const _StudentUi({
    required this.grade,
    required this.numberName,
    required this.isFemale,
    required this.sanctions,
  });
}