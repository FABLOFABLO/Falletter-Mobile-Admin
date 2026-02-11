import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/constants/textstyle.dart';
import 'package:falletter_mobile_admin/core/util/date_format.dart';
import 'package:falletter_mobile_admin/presentation/letter/provider/letter_provider.dart';
import 'package:falletter_mobile_admin/presentation/letter/widget/letter_log_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FalletterLetterView extends ConsumerWidget {
  const FalletterLetterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLetters = ref.watch(unpassedLettersProvider);

    Future<void> onRefresh() async {
      ref.invalidate(unpassedLettersProvider);
      try {
        await ref.read(unpassedLettersProvider.future);
      } catch (_) {}
    }

    return asyncLetters.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('레터 목록을 불러오지 못했습니다.', style: FalletterTextStyle.body2),
      ),
      data: (letters) {
        final sortedLetters = [...letters]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        if (sortedLetters.isEmpty) {
          return RefreshIndicator(
            color: FalletterColor.black,
            backgroundColor: FalletterColor.middleWhite,
            strokeWidth: 2.5,
            displacement: 28,
            edgeOffset: 8,
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 260),
                Center(
                  child: Text(
                    '아직 반려된 레터가 없어요.',
                    style: FalletterTextStyle.body2,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: FalletterColor.black,
          backgroundColor: FalletterColor.middleWhite,
          strokeWidth: 2.5,
          displacement: 28,
          edgeOffset: 8,
          onRefresh: onRefresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: sortedLetters.length,
            itemBuilder: (context, index) {
              final letter = sortedLetters[index];

              final senderAsync = ref.watch(userLabelProvider(letter.senderId));
              final receptionAsync = ref.watch(
                userLabelProvider(letter.receptionId),
              );

              String labelOf(AsyncValue<String> v, int fallbackId) => v.when(
                data: (s) => s,
                loading: () => '$fallbackId',
                error: (_, __) => '$fallbackId',
              );

              final from = labelOf(senderAsync, letter.senderId);
              final to = labelOf(receptionAsync, letter.receptionId);

              return LetterLogItem(
                letterId: letter.id,
                dateText: DateFormatter.mmdd(letter.createdAt),
                fromTo: '$from → $to',
              );
            },
          ),
        );
      },
    );
  }
}
