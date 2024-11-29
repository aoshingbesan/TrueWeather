import 'package:flutter_test/flutter_test.dart';
import '../../lib/pages/welcome.dart';
import 'package:flutter/material.dart';


void main() {
group('WelcomeRoute Widget Tests', () {
    testWidgets('WelcomeRoute UI Test', (WidgetTester tester) async {
      // Define a test key.
      final testKey = GlobalKey();

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: WelcomeRoute(key: testKey),
        routes: {
          '/registration': (context) => const Text('Registration Page'),
        },
      ));

      // Verify that certain texts are found in the widget tree.
      expect(find.text('WeatherMan'), findsOneWidget);
      expect(find.text('Version 1.0'), findsOneWidget);
      expect(find.text('Discover the Weather in'), findsOneWidget);
      expect(find.text('Your City'), findsOneWidget);

      // Verify the "Get Started" button is present.
      expect(find.text('Get Started'), findsOneWidget);

      // Tap the 'Get Started' button and trigger a frame.
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Verify that tapping the button pushes the new route.
      expect(find.text('Registration Page'), findsOneWidget);
    });

    // Add more tests as needed for different scenarios.
  });
}
