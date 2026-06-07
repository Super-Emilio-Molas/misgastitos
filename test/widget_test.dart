import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:misgastitos/aplicacion/mis_gastitos_app.dart';
import 'package:misgastitos/modelos/movimiento.dart';
import 'package:misgastitos/modelos/usuario_sesion.dart';
import 'package:misgastitos/servicios/repositorio_movimientos.dart';
import 'package:misgastitos/servicios/servicio_autenticacion.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ServicioAutenticacionFalso autenticacion;
  late RepositorioMovimientosFalso movimientos;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    autenticacion = ServicioAutenticacionFalso();
    movimientos = RepositorioMovimientosFalso();
  });

  testWidgets('muestra login y entra con servicio de autenticacion', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MisGastitosApp(autenticacion: autenticacion, movimientos: movimientos),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mis gastitos'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
    expect(find.textContaining('Usuario de prueba'), findsNothing);

    await tester.enterText(find.byType(TextField).at(0), 'luz');
    await tester.enterText(find.byType(TextField).at(1), 'clave-segura-123');
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Hola Luz'), findsOneWidget);
    expect(find.text('Resumen pastel'), findsOneWidget);
    expect(find.text('Gs. 0'), findsWidgets);

    await tester.drag(find.byType(ListView), const Offset(0, -420));
    await tester.pumpAndSettle();
    expect(find.text('Todavia no hay movimientos.'), findsOneWidget);

    await tester.tap(find.byTooltip('Ocultar saldo'));
    await tester.pumpAndSettle();

    expect(find.text('Gs. ******'), findsOneWidget);
  });

  testWidgets('permite registrarse con email usuario y contrasena', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MisGastitosApp(autenticacion: autenticacion, movimientos: movimientos),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Registrarme'));
    await tester.pumpAndSettle();

    expect(find.text('Crear cuenta'), findsOneWidget);
    expect(find.text('Gmail'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'luz@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), 'luz');
    await tester.enterText(find.byType(TextField).at(2), 'clave-segura-123');
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Crear cuenta'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Crear cuenta'));
    await tester.pumpAndSettle();

    expect(find.text('Hola Luz'), findsOneWidget);
  });

  testWidgets('permite abrir configuracion desde el menu inferior', (
    WidgetTester tester,
  ) async {
    await _abrirSesion(tester, autenticacion, movimientos);

    await tester.tap(find.byTooltip('Ajustes').first);
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Configuracion'), findsOneWidget);
    expect(find.text('Acceso por biometria'), findsOneWidget);
    expect(find.text('Patron cute'), findsNothing);
  });

  testWidgets('abre el formulario para cargar gastos o ingresos', (
    WidgetTester tester,
  ) async {
    await _abrirSesion(tester, autenticacion, movimientos);

    await tester.tap(find.byTooltip('Agregar movimiento'));
    await tester.pumpAndSettle();

    expect(find.text('Agregar movimiento'), findsOneWidget);
    expect(find.text('Gasto'), findsOneWidget);
    expect(find.text('Ingreso'), findsOneWidget);
    expect(find.text('En que gastaste'), findsOneWidget);
    expect(find.textContaining('Buscar entre'), findsOneWidget);
  });

  testWidgets('el boton salir pide confirmacion antes de cerrar', (
    WidgetTester tester,
  ) async {
    await _abrirSesion(tester, autenticacion, movimientos);

    await tester.tap(find.byTooltip('Salir'));
    await tester.pumpAndSettle();

    expect(find.text('Cerrar sesion'), findsOneWidget);
    expect(find.text('Queres salir de Mis gastitos?'), findsOneWidget);

    await tester.tap(find.text('Salir').last);
    await tester.pumpAndSettle();

    expect(find.text('Mis gastitos'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
  });

  testWidgets('el gesto atras pide confirmacion', (WidgetTester tester) async {
    await _abrirSesion(tester, autenticacion, movimientos);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Cerrar sesion'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Hola Luz'), findsOneWidget);
  });

  testWidgets('la tarjeta de saldo se adapta a pantallas angostas', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 780));
    await tester.pumpWidget(
      MisGastitosApp(autenticacion: autenticacion, movimientos: movimientos),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'luz');
    await tester.enterText(find.byType(TextField).at(1), 'clave-segura-123');
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Ocultar saldo'));
    await tester.pumpAndSettle();

    expect(find.text('Gs. ******'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _abrirSesion(
  WidgetTester tester,
  ServicioAutenticacionFalso autenticacion,
  RepositorioMovimientosFalso movimientos,
) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  await tester.pumpWidget(
    MisGastitosApp(autenticacion: autenticacion, movimientos: movimientos),
  );
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).at(0), 'luz');
  await tester.enterText(find.byType(TextField).at(1), 'clave-segura-123');
  await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
  await tester.pumpAndSettle();
}

class ServicioAutenticacionFalso implements ServicioAutenticacion {
  final _controlador = StreamController<UsuarioSesion?>.broadcast();
  UsuarioSesion? _usuarioActual;

  @override
  Stream<UsuarioSesion?> cambiosSesion() => _controlador.stream;

  @override
  UsuarioSesion? get usuarioActual => _usuarioActual;

  @override
  Future<void> cerrarSesion() async {
    _usuarioActual = null;
    _controlador.add(null);
  }

  @override
  Future<UsuarioSesion> ingresar({
    required String usuario,
    required String clave,
  }) async {
    _usuarioActual = UsuarioSesion(
      uid: 'uid-luz',
      usuario: usuario,
      nombre: 'Luz',
      correo: '$usuario@example.com',
    );
    _controlador.add(_usuarioActual);
    return _usuarioActual!;
  }

  @override
  Future<UsuarioSesion> registrar({
    required String correo,
    required String usuario,
    required String clave,
  }) async {
    _usuarioActual = UsuarioSesion(
      uid: 'uid-$usuario',
      usuario: usuario,
      nombre: 'Luz',
      correo: correo,
    );
    _controlador.add(_usuarioActual);
    return _usuarioActual!;
  }
}

class RepositorioMovimientosFalso implements RepositorioMovimientos {
  final List<Movimiento> _movimientos = [];

  @override
  Stream<List<Movimiento>> escucharMovimientos(String uid) {
    return Stream.value(_movimientos);
  }

  @override
  Future<void> agregarMovimiento({
    required String uid,
    required Movimiento movimiento,
  }) async {
    _movimientos.add(movimiento);
  }
}
