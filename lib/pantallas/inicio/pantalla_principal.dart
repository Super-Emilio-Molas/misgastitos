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
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, bottom + 10),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SizedBox(
            height: 90,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: PhysicalShape(
                    color: Colors.white,
                    elevation: 10,
                    shadowColor: const Color(0x245C6B8A),
                    clipper: const _RecorteBarraCentral(),
                    child: SizedBox(
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 4, 18, 6),
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
                            const SizedBox(width: 98),
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
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Tooltip(
                    message: 'Agregar movimiento',
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: alAgregar,
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF76A866), Color(0xFF436B39)],
                            ),
                            border: Border.all(
                              color: const Color(0xFFF8FAF4),
                              width: 5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x4076A866),
                                blurRadius: 26,
                                offset: Offset(0, 12),
                              ),
                              BoxShadow(
                                color: Color(0x24F6CA5C),
                                blurRadius: 18,
                                offset: Offset(-8, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecorteBarraCentral extends CustomClipper<Path> {
  const _RecorteBarraCentral();

  @override
  Path getClip(Size size) {
    final ancho = size.width;
    final alto = size.height;
    final centro = ancho / 2;
    const radio = 30.0;
    final hueco = ancho < 360 ? 46.0 : 54.0;
    const profundidad = 24.0;

    return Path()
      ..moveTo(radio, 0)
      ..lineTo(centro - hueco, 0)
      ..cubicTo(centro - 34, 0, centro - 34, profundidad, centro, profundidad)
      ..cubicTo(centro + 34, profundidad, centro + 34, 0, centro + hueco, 0)
      ..lineTo(ancho - radio, 0)
      ..quadraticBezierTo(ancho, 0, ancho, radio)
      ..lineTo(ancho, alto - radio)
      ..quadraticBezierTo(ancho, alto, ancho - radio, alto)
      ..lineTo(radio, alto)
      ..quadraticBezierTo(0, alto, 0, alto - radio)
      ..lineTo(0, radio)
      ..quadraticBezierTo(0, 0, radio, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant _RecorteBarraCentral oldClipper) => false;
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
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              activo ? iconoActivo : icono,
              size: 22,
              color: activo ? Colors.green.shade700 : const Color(0xFF8A8898),
            ),
            const SizedBox(height: 2),
            Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                color: activo ? Colors.green.shade800 : const Color(0xFF6D6978),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
