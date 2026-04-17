import 'package:flutter_test/flutter_test.dart';
import 'package:neon_pulse_3d/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NeonPulseApp());
    expect(find.byType(NeonPulseApp), findsOneWidget);
  });
}
