import 'package:crm_tuberias_valvulas_mobile/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('muestra el shell principal', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CrmDemoApp()));
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Pipeline'), findsWidgets);
    expect(find.text('IA'), findsWidgets);
  });
}
