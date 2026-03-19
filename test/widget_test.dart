import 'package:crm_tuberias_valvulas_mobile/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('muestra dashboard con estilo nuevo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CrmDemoApp()));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Bienvenido de vuelta'), findsOneWidget);
  });
}
