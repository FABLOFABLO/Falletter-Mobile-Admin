import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:flutter/material.dart';


class ReportSection extends StatelessWidget {
  final String label;
  final Widget child;

  const ReportSection({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: FalletterTextStyle.body2.copyWith(fontSize: 16, height: 20 / 16),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

/// 신고된 글 / 레터 내용
class ReportContentCard extends StatelessWidget {
  final List<String> meta;
  final String content;

  const ReportContentCard({
    super.key,
    required this.meta,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return _GrayBox(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final text in meta)
                Text(
                  text,
                  style: FalletterTextStyle.body4.copyWith(
                    height: 2,
                    color: FalletterColor.gray850,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: _bodyStyle),
        ],
      ),
    );
  }
}


class ReportReasonBox extends StatelessWidget {
  final String reason;

  const ReportReasonBox({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 182),
      child: _GrayBox(
        padding: const EdgeInsets.all(12),
        child: Text(reason, style: _bodyStyle),
      ),
    );
  }
}

final _bodyStyle = FalletterTextStyle.body3.copyWith(height: 20 / 12);

class _GrayBox extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _GrayBox({required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: FalletterColor.middleWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
