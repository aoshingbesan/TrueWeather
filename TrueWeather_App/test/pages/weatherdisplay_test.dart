import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/pages/api.dart';

void main() {
  testWidgets('SearchBar Functionality Test', (WidgetTester tester) async {
    // Build the widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: ThirdRoute()));

    // Ensure that the initial state shows a specific text or widget.
    expect(find.text('Search City'), findsOneWidget);

    // Tap the search button
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle(); // Wait for FutureBuilders to settle

    // Additional assertions to verify weather data is displayed correctly
  });

  testWidgets('Initial State Test', (WidgetTester tester) async {
    // Build the widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: ThirdRoute()));

    // // Ensure that the initial state shows a specific text or widget.
    // expect(find.text('Nairobi'), findsOneWidget);
  
    // // Additional assertions for other initial state conditions
  });
}
