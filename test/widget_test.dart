import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_hub/main.dart';

void main() {
  testWidgets('WatchHubApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WatchHubApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
