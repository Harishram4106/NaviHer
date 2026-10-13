import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naviher_ai/app/app.dart';

void main() {
  testWidgets('NaviHer app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: NaviHerApp(),
      ),
    );
    // App renders without throwing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
