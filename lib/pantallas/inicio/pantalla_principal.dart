import 'package:flutter/material.dart';

import '../../datos/catalogo_financiero.dart';
import '../../modelos/movimiento.dart';
import '../configuracion/pantalla_configuracion.dart';
import 'pantalla_inicio.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({
    super.key,
    required this.usuario,
    required this.alCerrarSesion,
  });

  final String usuario;
  final VoidCallback alCerrarSesion;

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indice = 0;
  late final List<Movimiento> _movimientos = movimientosIniciales();

  int get _entradas => _movimientos
      .where((movimiento) => movimiento.tipo == TipoMovimiento.entrada)
      .fold(0, (total, movimiento) => total + movimiento.monto);

  int get _gastos => _movimientos
      .where((movimiento) => movimiento.tipo == TipoMovimiento.gasto)
      .fold(0, (total, movimiento) => total + movimiento.monto);

  @override
  Widget build(BuildContext context) {
    final paginas = [
      PantallaInicio(
        usuario: widget.usuario,
        movimientos: _movimientos,
        entradas: _entradas,
        gastos: _gastos,
        alCerrarSesion: widget.alCerrarSesion,
      ),
      PantallaConfig(alCerrarSesion: widget.alCerrarSesion),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) widget.alCerrarSesion();
      },
      child: Scaffold(
        body: SafeArea(child: paginas[_indice]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _indice,
          onDestinationSelected: (valor) => setState(() => _indice = valor),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.tune_outlined),
              selectedIcon: Icon(Icons.tune),
              label: 'Config',
            ),
          ],
        ),
      ),
    );
  }
}
