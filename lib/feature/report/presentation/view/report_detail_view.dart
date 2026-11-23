import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/provider/report_detail_provider.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/report_decision_button.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/report_card.dart';
import 'package:falletter_mobile_admin/feature/report/presentation/widget/report_detail_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportDetailView extends ConsumerWidget {
  final int reportId;

  const ReportDetailView({super.key, required this.reportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = reportDetailProvider(reportId);
    final report = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    return Scaffold(
      backgroundColor: FalletterColor.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(showBack: true, title: '신고 목록 상세'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 32,
                  children: [
                    ReportSection(
                      label: '신고자',
                      child: ReportCard(studentInfo: report.reporter),
                    ),
                    ReportSection(
                      label: '대상자',
                      child: ReportCard(
                        studentInfo: report.target,
                        showArrow: true,
                        onPressed: () => context.go(RouterPath.students),
                      ),
                    ),
                    ReportSection(
                      label: report.type.contentLabel,
                      child: ReportContentCard(
                        meta: report.contentMeta,
                        content: report.content,
                      ),
                    ),
                    ReportSection(
                      label: '신고 사유',
                      child: ReportReasonBox(reason: report.reason),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: ReportDecisionButton(
                status: report.status,
                onReject: notifier.reject,
                onComplete: notifier.complete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
