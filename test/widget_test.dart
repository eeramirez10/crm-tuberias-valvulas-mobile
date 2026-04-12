import 'package:crm_tuberias_valvulas_mobile/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('muestra vista inicial de empresas', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CrmDemoApp()));
    await tester.pumpAndSettle();

    expect(find.text('All Companies'), findsOneWidget);
    expect(find.text('New Company'), findsOneWidget);
  });
}
