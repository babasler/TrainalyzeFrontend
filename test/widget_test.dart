import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trainalyze_flutter/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TrainalyzeApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('App displays welcome text in German', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TrainalyzeApp());

    // Verify that the German welcome text is displayed
    expect(find.text('Willkommen bei Trainalyze!'), findsOneWidget);
    expect(find.text('Eine Basis Flutter App für iOS und Desktop'), findsOneWidget);
  });

  testWidgets('App displays platform information', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TrainalyzeApp());

    // Verify platform information is displayed
    expect(find.text('Plattform Informationen:'), findsOneWidget);
    expect(find.text('Unterstützte Plattformen:'), findsOneWidget);
    
    // Check for platform chips
    expect(find.text('iOS'), findsOneWidget);
    expect(find.text('macOS'), findsOneWidget);
    expect(find.text('Windows'), findsOneWidget);
    expect(find.text('Linux'), findsOneWidget);
  });
}