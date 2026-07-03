import 'package:flutter_test/flutter_test.dart';
import 'package:shopsage_frontend_flutter/main.dart';

void main() {
  testWidgets('ShopSage app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopSageApp());
    expect(find.text('ShopSage'), findsOneWidget);
  });
}
