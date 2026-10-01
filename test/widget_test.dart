import 'package:flutter_test/flutter_test.dart';
import 'package:prism_auto/app.dart';

void main() {
  testWidgets('PRISM AUTO launches without framework exceptions',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PrismAutoApp());
    await tester.pumpAndSettle();

    expect(find.byType(PrismAutoApp), findsOneWidget);
  });
}
