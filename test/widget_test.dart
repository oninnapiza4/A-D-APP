import 'package:flutter_test/flutter_test.dart';
import 'package:blad_onin_final_nato/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ADThysiaApp());
    expect(find.byType(ADThysiaApp), findsOneWidget);
  });
}
