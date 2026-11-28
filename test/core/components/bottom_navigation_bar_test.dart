import 'package:falletter_mobile_admin/core/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(bottomNavigationBar: child));

  testWidgets('하단 탭 4개 라벨을 표시한다', (tester) async {
    await tester.pumpWidget(
      wrap(CustomBottomNavigationBar(currentIndex: 0, onTap: (_) {})),
    );

    for (final label in ['레터', '커뮤니티', '학생 목록', '공지']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('탭을 누르면 해당 인덱스로 onTap을 호출한다', (tester) async {
    final tapped = <int>[];
    await tester.pumpWidget(
      wrap(CustomBottomNavigationBar(currentIndex: 0, onTap: tapped.add)),
    );

    await tester.tap(find.text('커뮤니티'));
    await tester.tap(find.text('공지'));

    expect(tapped, [1, 3]);
  });
}
