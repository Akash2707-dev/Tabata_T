import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart'; // Import GetWidget package
import 'package:audioplayers/audioplayers.dart'; // Import AudioPlayer package
import 'package:integration_test/integration_test.dart';
import 'package:tabatatimer/providers/timer_provider.dart';
import 'package:tabatatimer/screens/timer_screen.dart'; // Adjust the path as needed
import 'package:mockito/mockito.dart';
// Define mock for AudioPlayer if needed
class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Timer screen functionality test', (WidgetTester tester) async {
    // Build the app and render the TimerScreen
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: TimerScreen(),
        ),
      ),
    );

    // Check initial state
    expect(find.text('Break'), findsOneWidget);
    expect(find.byType(GFToggle), findsOneWidget);

    // Interact with the duration inputs and buttons
    await tester.tap(find.byType(GFToggle));
    await tester.pump();

    await tester.tap(find.byType(GFButton).first);
    await tester.pumpAndSettle();

    // Test the pause functionality
    await tester.tap(find.byType(GFButton).at(1));
    await tester.pumpAndSettle();

    // Test the reset functionality
    await tester.tap(find.byType(GFButton).last);
    await tester.pumpAndSettle();

    // Check that the TimerScreen updates correctly
    expect(find.text('Break'), findsOneWidget);
  });
}
