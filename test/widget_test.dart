import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:misgastitos/main.dart';

void main() {
  testWidgets('shows login and opens dashboard', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 1400));
    await tester.pumpWidget(const MisGastitosApp());

    expect(find.text('Mis gastitos'), findsWidgets);
    expect(find.text('Iniciar sesión'), findsOneWidget);

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Hola Luz Valeria 👋'), findsOneWidget);
    expect(find.text('Resumen de este mes'), findsOneWidget);
  });

  testWidgets('adds a new expense', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 1400));
    await tester.pumpWidget(const MisGastitosApp());
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nuevo gasto'));
    await tester.pumpAndSettle();

    expect(find.text('Nuevo movimiento'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('entry-title-field')),
      'Café',
    );
    await tester.enterText(
      find.byKey(const ValueKey('entry-amount-field')),
      '12000',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('save-entry-button')));
    await tester.tap(find.byKey(const ValueKey('save-entry-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gastos'));
    await tester.pumpAndSettle();

    expect(find.text('Café'), findsOneWidget);
    expect(find.text('-Gs. 12.000'), findsOneWidget);
  });
}
