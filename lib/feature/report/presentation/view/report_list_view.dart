import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/category_button.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/custom_tab_bar.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/report_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportListView extends StatefulWidget {
  const ReportListView({super.key});

  @override
  State<ReportListView> createState() => _ReportListViewState();
}

class _ReportListViewState extends State<ReportListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    return ReportCard(
                      onPressed: () => context.push(
                        RouterPath.reportDetail,
                        extra: index,
                      ),
                      time: '2026.07.06',
                      studentInfo: '2100 이지아',
                    );
                  },
                  separatorBuilder: (context, int index) =>
                      const SizedBox(height: 12),
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
