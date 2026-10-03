// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:erp_sample/main.dart';

void main() {
  testWidgets('School ERP app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SchoolERPApp());

    expect(find.text('Aarav Sharma'), findsOneWidget);
    expect(find.text('Quick Overview'), findsOneWidget);
    expect(find.text('Fees Due'), findsOneWidget);
  });
}