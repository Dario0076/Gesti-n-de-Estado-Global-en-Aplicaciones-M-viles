// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/presentation/di/injection_container.dart' as di;

void main() {
  setUpAll(() async {
    await di.init();
  });

  testWidgets('App should load home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that our home page loads
    expect(find.text('Gestión de Estado - Comparación'), findsOneWidget);
    expect(find.text('Demo - Bloc Pattern'), findsOneWidget);
    expect(find.text('Demo - Provider'), findsOneWidget);
    expect(find.text('Demo - Riverpod'), findsOneWidget);
  });
}
