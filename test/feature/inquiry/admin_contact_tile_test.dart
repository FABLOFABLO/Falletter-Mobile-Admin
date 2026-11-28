import 'package:falletter_mobile_admin/feature/inquiry/presentation/widget/admin_contact_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<int Function()> pumpTile(WidgetTester tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdminContactTile(
            name: '홍길동',
            role: '관리자',
            onTap: () => count++,
          ),
        ),
      ),
    );
    return () => count;
  }

  testWidgets('이름과 역할을 표시한다', (tester) async {
    await pumpTile(tester);

    expect(find.text('홍길동'), findsOneWidget);
    expect(find.text('관리자'), findsOneWidget);
  });

  testWidgets('화살표뿐 아니라 이름을 눌러도 onTap이 호출된다', (tester) async {
    final count = await pumpTile(tester);

    await tester.tap(find.text('홍길동'));
    expect(count(), 1);
  });

  testWidgets('이름과 화살표 사이 빈 영역을 눌러도 onTap이 호출된다', (tester) async {
    final count = await pumpTile(tester);

    final tile = tester.getRect(find.byType(AdminContactTile));
    await tester.tapAt(tile.center);
    expect(count(), 1);
  });
}
