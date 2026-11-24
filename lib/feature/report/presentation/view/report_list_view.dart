import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/feature/report/domain/model/report_detail.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/provider/report_detail_provider.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/category_button.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/custom_tab_bar.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final statuses = ref.watch(reportStatusesProvider);
    final reportIds = dummyReportIds
        .where((id) => statuses[id] == status)
        .where((id) => category.matches(dummyReportTypeOf(id)))
        .toList();

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
                child: ListView.separated(
                  itemBuilder: (context, int index) {
                    final reportId = reportIds[index];
                    return ReportCard(
                      onPressed: () => context.push(
                        RouterPath.reportDetail,
                        extra: reportId,
                      ),
                      time: '2026.07.06',
                      studentInfo: '2100 이지아',
                    );
                  },
                  separatorBuilder: (context, int index) =>
                      const SizedBox(height: 12),
                  itemCount: reportIds.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
