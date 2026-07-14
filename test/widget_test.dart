import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launchpad_alu/widgets/readiness_ring.dart';
import 'package:launchpad_alu/utils/app_strings.dart';

void main() {
  testWidgets('ReadinessRing shows the percentage', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ReadinessRing(percent: 75)),
      ),
    );
    expect(find.text('75%'), findsOneWidget);
  });

  test('AppStrings falls back to English then to the key', () {
    expect(AppStrings.get('login', 'en'), 'Sign in');
    expect(AppStrings.get('login', 'fr'), 'Se connecter');
    expect(AppStrings.get('missing_key', 'fr'), 'missing_key');
  });
}
