import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/feature/report/domain/model/report_detail.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/provider/report_detail_provider.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/category_button.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/custom_tab_bar.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReportListView extends ConsumerStatefulWidget {
  const ReportListView({super.key});

  @override
  ConsumerState<ReportListView> createState() => _ReportListViewState();
}

class _ReportListViewState extends ConsumerState<ReportListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: ReportStatus.values.length,
      vsync: this,
    )..addListener(_onTabChanged);
  }

  void _onTabChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = ReportCategory.values[_selectedIndex];
    final status = ReportStatus.values[_tabController.index];
    final reportsAsync = ref.watch(reportListProvider(status));

    return Scaffold(
      backgroundColor: FalletterColor.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const CustomAppBar(
                showBack: true,
                title: '신고 목록',
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 19),
              CustomTabBar(controller: _tabController),
              const SizedBox(height: 20),
              CategoryButton(
                labels: ReportCategory.values.map((e) => e.label).toList(),
                selectedIndex: _selectedIndex,
                onSelected: (i) => setState(() => _selectedIndex = i),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: reportsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: TextButton(
                      onPressed: () =>
                          ref.invalidate(reportListProvider(status)),
                      child: const Text('불러오지 못했습니다. 다시 시도'),
                    ),
                  ),
                  data: (reports) {
                    final filtered = reports
                        .where((r) => category.matches(r.type))
                        .toList();
                    return RefreshIndicator(
                      onRefresh: () =>
                          ref.refresh(reportListProvider(status).future),
                      child: filtered.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: 200),
                                Center(
                                  child: Text(
                                    '접수된 신고가 없어요.',
                                    style: FalletterTextStyle.body2,
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, int index) {
                                final report = filtered[index];
                                return ReportCard(
                                  onPressed: () => context.push(
                                    RouterPath.reportDetail,
                                    extra: report,
                                  ),
                                  time: DateFormat(
                                    'yyyy.MM.dd',
                                  ).format(report.createdAt),
                                  studentInfo: report.target,
                                );
                              },
                              separatorBuilder: (context, int index) =>
                                  const SizedBox(height: 12),
                              itemCount: filtered.length,
                            ),
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
