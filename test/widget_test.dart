import 'package:crm_tuberias_valvulas_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('muestra la base limpia', (WidgetTester tester) async {
    await tester.pumpWidget(const CrmSeedApp());
    await tester.pumpAndSettle();

    expect(find.text('CRM Tuvansa - Base limpia'), findsOneWidget);
  });
}
