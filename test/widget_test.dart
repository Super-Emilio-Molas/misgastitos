import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:misgastitos/aplicacion/mis_gastitos_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('muestra login y entra con usuario de prueba', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const MisGastitosApp());
    await tester.pumpAndSettle();

    expect(find.text('Mis gastitos'), findsWidgets);
    expect(find.text('Entrar'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'luz');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Hola Luz Valeria'), findsOneWidget);
    expect(find.text('Resumen pastel'), findsOneWidget);

    await tester.tap(find.byTooltip('Ocultar saldo'));
    await tester.pumpAndSettle();

    expect(find.text('Gs. ******'), findsOneWidget);
  });

  testWidgets('permite abrir configuracion desde el menu inferior', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const MisGastitosApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'luz');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Config'));
    await tester.pumpAndSettle();

    expect(find.text('Configuracion'), findsOneWidget);
    expect(find.text('Acceso por biometria'), findsOneWidget);
  });
}
