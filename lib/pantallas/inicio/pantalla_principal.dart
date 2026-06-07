import 'package:flutter/material.dart';

import '../../modelos/movimiento.dart';
import '../../modelos/usuario_sesion.dart';
import '../../servicios/repositorio_movimientos.dart';
import '../configuracion/pantalla_configuracion.dart';
import '../movimientos/pantalla_formulario_movimiento.dart';
import '../movimientos/pantalla_movimientos.dart';
import 'pantalla_inicio.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({
    super.key,
    required this.usuario,
    required this.movimientos,
    required this.alCerrarSesion,
  });

  final UsuarioSesion usuario;
  final RepositorioMovimientos movimientos;
  final Future<void> Function() alCerrarSesion;

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indice = 0;
  bool _cerrandoSesion = false;

  int _entradas(List<Movimiento> movimientos) => movimientos
      .where((movimiento) => movimiento.tipo == TipoMovimiento.entrada)
      .fold(0, (total, movimiento) => total + movimiento.monto);

  int _gastos(List<Movimiento> movimientos) => movimientos
      .where((movimiento) => movimiento.tipo == TipoMovimiento.gasto)
      .fold(0, (total, movimiento) => total + movimiento.monto);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) await _pedirCerrarSesion();
      },
      child: StreamBuilder<List<Movimiento>>(
        stream: widget.movimientos.escucharMovimientos(widget.usuario.uid),
        initialData: const [],
        builder: (context, snapshot) {
          final movimientos = snapshot.data ?? const <Movimiento>[];
          final paginas = [
            PantallaInicio(
              usuario: widget.usuario.nombre,
              movimientos: movimientos,
              entradas: _entradas(movimientos),
              gastos: _gastos(movimientos),
              alCerrarSesion: _pedirCerrarSesion,
              alAbrirConfig: () => setState(() => _indice = 2),
            ),
            PantallaMovimientos(
              usuario: widget.usuario.nombre,
              movimientos: movimientos,
              alAbrirConfig: () => setState(() => _indice = 2),
            ),
            PantallaConfig(
              usuario: widget.usuario,
              alCerrarSesion: _pedirCerrarSesion,
            ),
          ];

          return Scaffold(
            body: SafeArea(child: paginas[_indice]),
            bottomNavigationBar: _BarraInferiorPastel(
              indice: _indice,
              alCambiar: (valor) => setState(() => _indice = valor),
              alAgregar: _abrirFormularioMovimiento,
            ),
          );
        },
      ),
    );
  }

  Future<void> _abrirFormularioMovimiento() async {
    final movimiento = await showModalBottomSheet<Movimiento>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PantallaFormularioMovimiento(),
    );
    if (movimiento == null) return;

    await widget.movimientos.agregarMovimiento(
      uid: widget.usuario.uid,
      movimiento: movimiento,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Movimiento guardado.')));
  }

  Future<void> _pedirCerrarSesion() async {
    if (_cerrandoSesion) return;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesion'),
        content: const Text('Queres salir de Mis gastitos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;
    setState(() => _cerrandoSesion = true);
    await widget.alCerrarSesion();
    if (mounted) setState(() => _cerrandoSesion = false);
  }
}

class _BarraInferiorPastel extends StatelessWidget {
  const _BarraInferiorPastel({
    required this.indice,
    required this.alCambiar,
    required this.alAgregar,
  });

  final int indice;
  final ValueChanged<int> alCambiar;
  final VoidCallback alAgregar;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 20,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 8, 14, bottom + 8),
        child: Row(
          children: [
            Expanded(
              child: _ItemBarra(
                activo: indice == 0,
                icono: Icons.home_outlined,
                iconoActivo: Icons.home,
                texto: 'Inicio',
                alTocar: () => alCambiar(0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Tooltip(
                message: 'Agregar movimiento',
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: alAgregar,
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.shade600,
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 34),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _ItemBarra(
                activo: indice == 1,
                icono: Icons.receipt_long_outlined,
                iconoActivo: Icons.receipt_long,
                texto: 'Movimientos',
                alTocar: () => alCambiar(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemBarra extends StatelessWidget {
  const _ItemBarra({
    required this.activo,
    required this.icono,
    required this.iconoActivo,
    required this.texto,
    required this.alTocar,
  });

  final bool activo;
  final IconData icono;
  final IconData iconoActivo;
  final String texto;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: alTocar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: activo ? const Color(0xFFEAF5E7) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              activo ? iconoActivo : icono,
              color: activo ? Colors.green.shade700 : const Color(0xFF56514D),
            ),
            const SizedBox(height: 3),
            Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: activo ? Colors.green.shade800 : const Color(0xFF56514D),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
