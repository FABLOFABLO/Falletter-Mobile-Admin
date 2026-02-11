import 'dart:async';

import 'package:falletter_mobile_admin/core/components/button/more_action_button.dart';
import 'package:falletter_mobile_admin/core/components/modal/default_modal.dart';
import 'package:falletter_mobile_admin/core/components/modal/ui_model/default_modal_ui_model.dart';
import 'package:falletter_mobile_admin/core/components/text_form_field/text_form_field.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/util/date_format.dart';
import 'package:falletter_mobile_admin/presentation/students/model/sanction_summary.dart';
import 'package:falletter_mobile_admin/presentation/students/model/student_model.dart';
import 'package:falletter_mobile_admin/presentation/students/provider/students_action_provider.dart';
import 'package:falletter_mobile_admin/presentation/students/provider/students_provider.dart';
import 'package:falletter_mobile_admin/presentation/students/widget/student_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class FalletterStudentsView extends ConsumerStatefulWidget {
  const FalletterStudentsView({super.key});

  @override
  ConsumerState<FalletterStudentsView> createState() =>
      _FalletterStudentsViewState();
}

class _FalletterStudentsViewState extends ConsumerState<FalletterStudentsView> {
  Timer? _refreshTimer;

  final _searchController = TextEditingController();
  final Set<int> _selectedGrades = {};
  String _committedQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshStudents();
    });

    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      _refreshStudents();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshStudents() async {
    ref.invalidate(studentsListProvider);
    try {
      await ref.read(studentsListProvider.future);
    } catch (_) {}
  }

  void _commitSearch() {
    setState(() {
      _committedQuery = _searchController.text;
    });
    FocusScope.of(context).unfocus();
  }

  int _gradeFromSchoolNumber(String schoolNumber) {
    if (schoolNumber.isEmpty) return 0;
    final g = int.tryParse(schoolNumber.substring(0, 1));
    return g ?? 0;
  }

  String _genderLabel(String gender) => gender == 'FEMALE' ? '여학생' : '남학생';

  bool _isFemale(String gender) => gender == 'FEMALE';

  bool _isZeroDate(DateTime? dt) =>
      dt == null || dt.millisecondsSinceEpoch == 0;

  String _mmddOrFallback(DateTime? dt, {String fallback = '날짜 없음'}) {
    if (_isZeroDate(dt)) return fallback;
    return DateFormatter.mmdd(dt!);
  }

  List<_StudentUi> _mapToUi(List<StudentSummary> list) {
    return list.map((s) {
      return _StudentUi(
        id: s.id,
        grade: _gradeFromSchoolNumber(s.schoolNumber),
        numberName: '${s.schoolNumber} ${s.name}',
        isFemale: _isFemale(s.gender),
        genderLabel: _genderLabel(s.gender),
      );
    }).toList();
  }

  List<_StudentUi> _applyFilters(List<_StudentUi> all) {
    final q = _committedQuery.trim();
    return all.where((s) {
      final byGrade = _selectedGrades.isEmpty
          ? true
          : _selectedGrades.contains(s.grade);
      final byQuery = q.isEmpty ? true : s.numberName.contains(q);
      return byGrade && byQuery;
    }).toList();
  }

  List<SanctionSummary> _buildTimelineSanctions(StudentDetail detail) {
    final items = [...detail.suspends];
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return items.map((s) {
      final dateText = _mmddOrFallback(s.createdAt, fallback: '날짜 없음');

      if (s.type == 'WARNING') {
        return SanctionSummary(
          type: '경고',
          dateText: dateText,
          countText: '+1',
          createdAt: s.createdAt,
        );
      }

      if (s.type == 'BLOCK') {
        return SanctionSummary(
          type: '정지',
          dateText: dateText,
          countText: '${s.days}일',
          reason: s.reason,
          days: s.days,
          createdAt: s.createdAt,
        );
      }

      return SanctionSummary(
        type: s.type,
        dateText: dateText,
        countText: '',
        createdAt: s.createdAt,
      );
    }).toList();
  }

  void _openSanctionDetailModal(SanctionSummary sanction) {
    final reason = (sanction.reason == null || sanction.reason!.trim().isEmpty)
        ? '사유 없음'
        : sanction.reason!.trim();

    final dateText = _mmddOrFallback(sanction.createdAt);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _SanctionDetailModal(content: reason, dateText: dateText),
    );
  }

  void _openBanModal(int userId) {
    showDialog(
      context: context,
      builder: (_) => DefaultModal(
        model: DefaultModalUiModel.ban(),
        onConfirmBan: (days, reason) async {
          await ref
              .read(studentsActionProvider.notifier)
              .block(userId: userId, days: days, reason: reason);

          ref.invalidate(studentsListProvider);
          ref.invalidate(studentDetailProvider(userId));
        },
        onConfirmLogout: null,
      ),
    );
  }

  void _onStudentMenu(StudentMenuAction action, int userId) async {
    if (action == StudentMenuAction.ban) {
      _openBanModal(userId);
      return;
    }

    if (action == StudentMenuAction.warn) {
      await ref.read(studentsActionProvider.notifier).warn(userId);
      ref.invalidate(studentsListProvider);
      ref.invalidate(studentDetailProvider(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncStudents = ref.watch(studentsListProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FalletterColor.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (_) => _commitSearch(),
                      decoration: InputDecoration(
                        hintText: '학생 검색',
                        contentPadding: const EdgeInsets.all(12),
                        suffixIcon: IconButton(
                          onPressed: _commitSearch,
                          icon: const Icon(
                            Symbols.search,
                            size: 22,
                            color: FalletterColor.gray600,
                          ),
                        ),
                      ),
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
                                    text: '$g학년',
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
                          itemBuilder: (context) => MoreAction.buildItems<int>([
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
                          child: const SizedBox(
                            height: 44,
                            child: Center(
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
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: FalletterColor.middleWhite,
                  color: FalletterColor.black,
                  onRefresh: _refreshStudents,
                  child: asyncStudents.when(
                    loading: () => ListView(
                      children: const [
                        SizedBox(height: 260),
                        Center(child: CircularProgressIndicator()),
                      ],
                    ),
                    error: (e, _) => ListView(
                      children: [
                        const SizedBox(height: 260),
                        Center(
                          child: Text(
                            '학생 목록을 불러오지 못했습니다.',
                            style: FalletterTextStyle.body2,
                          ),
                        ),
                      ],
                    ),
                    data: (students) {
                      if (students.isEmpty) {
                        return ListView(
                          children: [
                            const SizedBox(height: 260),
                            Center(
                              child: Text(
                                '아직 가입한 학생이 없어요.',
                                style: FalletterTextStyle.body2,
                              ),
                            ),
                          ],
                        );
                      }
                      final allUi = _mapToUi(students);
                      final items = _applyFilters(allUi);
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final sUi = items[index];
                          final detailAsync = ref.watch(
                            studentDetailProvider(sUi.id),
                          );
                          return detailAsync.when(
                            loading: () => StudentListItem(
                              numberName: sUi.numberName,
                              genderLabel: sUi.genderLabel,
                              isFemale: sUi.isFemale,
                              sanctions: const [],
                              onTapDetail: null,
                              onMenu: (action) =>
                                  _onStudentMenu(action, sUi.id),
                            ),
                            error: (_, __) => StudentListItem(
                              numberName: sUi.numberName,
                              genderLabel: sUi.genderLabel,
                              isFemale: sUi.isFemale,
                              sanctions: const [],
                              onTapDetail: null,
                              onMenu: (action) =>
                                  _onStudentMenu(action, sUi.id),
                            ),
                            data: (detail) {
                              final sanctions = _buildTimelineSanctions(detail);
                              return StudentListItem(
                                numberName: sUi.numberName,
                                genderLabel: sUi.genderLabel,
                                isFemale: sUi.isFemale,
                                sanctions: sanctions,
                                onTapDetail: (sanction) {
                                  if (sanction.type != '정지') return;
                                  _openSanctionDetailModal(sanction);
                                },

                                onMenu: (action) =>
                                    _onStudentMenu(action, sUi.id),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
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
          Text(text, style: FalletterTextStyle.body4),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Symbols.x_circle,
              size: 16,
              color: FalletterColor.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _SanctionDetailModal extends StatelessWidget {
  final String content;
  final String dateText;

  const _SanctionDetailModal({required this.content, required this.dateText});

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
                  Text('제재 내역', style: FalletterTextStyle.body3),
                  const SizedBox(height: 14),
                  divider,
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.center,
                    child: Text(content, style: FalletterTextStyle.body4),
                  ),
                  const SizedBox(height: 18),
                  divider,
                  const SizedBox(height: 14),
                  Text(
                    dateText,
                    style: FalletterTextStyle.body4.copyWith(
                      color: FalletterColor.gray700,
                    ),
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
                  child: Icon(
                    Symbols.close,
                    color: FalletterColor.white,
                    size: 28,
                  ),
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
  final int id;
  final int grade;
  final String numberName;
  final bool isFemale;
  final String genderLabel;

  const _StudentUi({
    required this.id,
    required this.grade,
    required this.numberName,
    required this.isFemale,
    required this.genderLabel,
  });
}
