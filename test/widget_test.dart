import 'package:flutter_test/flutter_test.dart';
import 'package:caro_project_cnttk25/main.dart';

void main() {
  testWidgets('UngDungCaro hien thi menu chinh',
      (WidgetTester tester) async {
    await tester.pumpWidget(const UngDungCaro());

    expect(find.text('Đấu 2 Người (PvP)'), findsOneWidget);
    expect(find.text('Đấu với Máy (PvE - AI)'), findsOneWidget);
    expect(find.text('Hai người chơi chung một máy'), findsOneWidget);
    expect(find.text('Thách đấu với máy thông minh'), findsOneWidget);
  });
}
