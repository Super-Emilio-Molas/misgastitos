import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../componentes/formato_dinero.dart';
import '../../componentes/fondo_huellitas.dart';
import '../../componentes/tarjeta_suave.dart';
import '../../datos/catalogo_financiero.dart';
import '../../modelos/categoria_gasto.dart';
import '../../modelos/movimiento.dart';
import '../../tema/colores_app.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({
    super.key,
    required this.usuario,
    required this.movimientos,
    required this.entradas,
    required this.gastos,
    required this.alCerrarSesion,
    required this.alAbrirConfig,
  });

  final String usuario;
  final List<Movimiento> movimientos;
  final int entradas;
  final int gastos;
  final Future<void> Function() alCerrarSesion;
  final VoidCallback alAbrirConfig;

  int get saldo => entradas - gastos;

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  bool _saldoOculto = false;

  @override
  Widget build(BuildContext context) {
    return FondoHuellitas(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final ancho = constraints.maxWidth;
          final esAncho = ancho >= 700;

          return ListView(
            padding: EdgeInsets.fromLTRB(
              ancho < 380 ? 16 : 22,
              16,
              ancho < 380 ? 16 : 22,
              24,
            ),
            children: [
              _BarraSuperior(
                alCerrarSesion: widget.alCerrarSesion,
                alAbrirConfig: widget.alAbrirConfig,
              ),
              const SizedBox(height: 16),
              Text(
                'Hola ${_nombreMostrable(widget.usuario)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: ColoresApp.tinta,
                  fontSize: ancho < 380 ? 25 : 30,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Hoy cuidamos tus gastitos paso a paso',
                style: TextStyle(
                  color: ColoresApp.textoSuave,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              if (esAncho)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _TarjetaSaldo(
                        saldo: widget.saldo,
                        saldoOculto: _saldoOculto,
                        alAlternarSaldo: _alternarSaldo,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _TarjetaResumen(
                        gastos: widget.gastos,
                        movimientos: widget.movimientos,
                      ),
                    ),
                  ],
                )
              else ...[
                _TarjetaSaldo(
                  saldo: widget.saldo,
                  saldoOculto: _saldoOculto,
                  alAlternarSaldo: _alternarSaldo,
                ),
                const SizedBox(height: 16),
                _TarjetaResumen(
                  gastos: widget.gastos,
                  movimientos: widget.movimientos,
                ),
              ],
              const SizedBox(height: 22),
              _TituloSeccion(titulo: 'Ultimos movimientos'),
              const SizedBox(height: 12),
              _ListaMovimientos(movimientos: widget.movimientos),
            ],
          );
        },
      ),
    );
  }

  void _alternarSaldo() {
    setState(() => _saldoOculto = !_saldoOculto);
  }

  String _nombreMostrable(String usuario) {
    final limpio = usuario.trim();
    if (limpio.isEmpty) return 'usuario';
    return limpio[0].toUpperCase() + limpio.substring(1);
  }
}

class _BarraSuperior extends StatelessWidget {
  const _BarraSuperior({
    required this.alCerrarSesion,
    required this.alAbrirConfig,
  });

  final Future<void> Function() alCerrarSesion;
  final VoidCallback alAbrirConfig;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          tooltip: 'Salir',
          onPressed: () {
            alCerrarSesion();
          },
          icon: const Icon(Icons.logout),
        ),
        const Spacer(),
        IconButton.filledTonal(
          tooltip: 'Notificaciones',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: 'Ajustes',
          onPressed: alAbrirConfig,
          icon: const Icon(Icons.tune_outlined),
        ),
      ],
    );
  }
}

class _TarjetaSaldo extends StatelessWidget {
  const _TarjetaSaldo({
    required this.saldo,
    required this.saldoOculto,
    required this.alAlternarSaldo,
  });

  final int saldo;
  final bool saldoOculto;
  final VoidCallback alAlternarSaldo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final anchoTarjeta = constraints.maxWidth;
        final compacto = anchoTarjeta < 380;
        final anchoPerrito = (anchoTarjeta * 0.34).clamp(96.0, 136.0);
        final altoPerrito = anchoPerrito * 0.72;
        final espacioPerrito = (anchoPerrito * 0.36).clamp(38.0, 56.0);
        final margenSuperior = (altoPerrito - 6).clamp(58.0, 92.0);
        final paddingSuperior = compacto ? 18.0 : 20.0;
        final posicionDerecha = (anchoTarjeta * 0.035).clamp(4.0, 14.0);
        final posicionSuperior = margenSuperior - altoPerrito + 6;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: posicionSuperior,
              right: posicionDerecha,
              child: IgnorePointer(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final escala = Tween<double>(
                      begin: 0.92,
                      end: 1,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: escala, child: child),
                    );
                  },
                  child: Image.asset(
                    saldoOculto
                        ? 'images/perrito_tapando_los_ojos_sobre_panel_saldo_actual.png'
                        : 'images/perrito_sobre_panel_saldo_actual.png',
                    key: ValueKey(saldoOculto),
                    width: anchoPerrito,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: margenSuperior),
              padding: EdgeInsets.fromLTRB(
                compacto ? 16 : 18,
                paddingSuperior,
                compacto ? 12 : 16,
                18,
              ),
              decoration: BoxDecoration(
                color: ColoresApp.crema,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: ColoresApp.linea),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saldo actual',
                          style: TextStyle(
                            color: ColoresApp.textoSuave,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 220),
                                  child: Text(
                                    saldoOculto
                                        ? 'Gs. ******'
                                        : formatoGuaranies(saldo),
                                    key: ValueKey(saldoOculto),
                                    style: const TextStyle(
                                      color: ColoresApp.tinta,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton.filledTonal(
                              tooltip: saldoOculto
                                  ? 'Mostrar saldo'
                                  : 'Ocultar saldo',
                              onPressed: alAlternarSaldo,
                              icon: Icon(
                                saldoOculto
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.savings_outlined,
                                color: ColoresApp.verde,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Buen ritmo este mes',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: ColoresApp.verdeOscuro,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: espacioPerrito),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TarjetaResumen extends StatelessWidget {
  const _TarjetaResumen({required this.gastos, required this.movimientos});

  final int gastos;
  final List<Movimiento> movimientos;

  @override
  Widget build(BuildContext context) {
    final resumen = _resumenCategorias(movimientos);
    return TarjetaSuave(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TituloSeccion(titulo: 'Resumen pastel'),
          const SizedBox(height: 14),
          Center(
            child: SizedBox.square(
              dimension: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size.square(150),
                    painter: _PintorDona(resumen: resumen, total: gastos),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Gastado',
                        style: TextStyle(
                          color: ColoresApp.textoSuave,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        formatoGuaranies(gastos),
                        style: const TextStyle(
                          color: ColoresApp.tinta,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (resumen.isEmpty)
            const Text(
              'Cargá tus gastos con el botón + y el pastel va a cobrar vida.',
              style: TextStyle(
                color: ColoresApp.textoSuave,
                fontWeight: FontWeight.w800,
              ),
            )
          else
            ...resumen.take(5).map((item) => _FilaCategoria(item: item)),
        ],
      ),
    );
  }

  List<_ResumenCategoria> _resumenCategorias(List<Movimiento> movimientos) {
    final montos = <String, int>{};
    for (final movimiento in movimientos) {
      if (movimiento.tipo != TipoMovimiento.gasto) continue;
      montos.update(
        movimiento.categoria,
        (valor) => valor + movimiento.monto,
        ifAbsent: () => movimiento.monto,
      );
    }

    final resumen = montos.entries.map((entry) {
      final categoria = categoriasGasto.firstWhere(
        (item) => item.nombre == entry.key,
        orElse: () => categoriasGasto.last,
      );
      return _ResumenCategoria(categoria: categoria, monto: entry.value);
    }).toList();

    resumen.sort((a, b) => b.monto.compareTo(a.monto));
    return resumen;
  }
}

class _ListaMovimientos extends StatelessWidget {
  const _ListaMovimientos({required this.movimientos});

  final List<Movimiento> movimientos;

  @override
  Widget build(BuildContext context) {
    if (movimientos.isEmpty) {
      return const TarjetaSuave(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: ColoresApp.verdeSuave,
              child: Icon(Icons.pets, color: ColoresApp.verde),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Todavia no hay movimientos.',
                style: TextStyle(
                  color: ColoresApp.textoSuave,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return TarjetaSuave(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < movimientos.take(4).length; i++) ...[
            _FilaMovimiento(movimiento: movimientos[i]),
            if (i < movimientos.take(4).length - 1)
              const Divider(height: 1, indent: 76, color: ColoresApp.linea),
          ],
        ],
      ),
    );
  }
}

class _FilaMovimiento extends StatelessWidget {
  const _FilaMovimiento({required this.movimiento});

  final Movimiento movimiento;

  @override
  Widget build(BuildContext context) {
    final categoria = categoriasGasto.firstWhere(
      (item) => item.nombre == movimiento.categoria,
      orElse: () => categoriasGasto.last,
    );
    final esGasto = movimiento.tipo == TipoMovimiento.gasto;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: categoria.colorSuave,
            child: Icon(categoria.icono, color: categoria.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movimiento.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColoresApp.tinta,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  movimiento.categoria,
                  style: const TextStyle(
                    color: ColoresApp.textoSuave,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${esGasto ? '-' : '+'}${formatoGuaranies(movimiento.monto)}',
            style: TextStyle(
              color: esGasto ? ColoresApp.tinta : ColoresApp.verde,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumenCategoria {
  const _ResumenCategoria({required this.categoria, required this.monto});

  final CategoriaGasto categoria;
  final int monto;
}

class _FilaCategoria extends StatelessWidget {
  const _FilaCategoria({required this.item});

  final _ResumenCategoria item;

  @override
  Widget build(BuildContext context) {
    final categoria = item.categoria;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(categoria.icono, color: categoria.color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              categoria.nombre,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          Text(
            formatoGuaranies(item.monto),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion({required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: const TextStyle(
        color: ColoresApp.tinta,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _PintorDona extends CustomPainter {
  _PintorDona({required this.resumen, required this.total});

  final List<_ResumenCategoria> resumen;
  final int total;

  @override
  void paint(Canvas canvas, Size size) {
    final trazo = size.width * 0.16;
    final rect =
        Offset(trazo / 2, trazo / 2) &
        Size(size.width - trazo, size.height - trazo);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = trazo;

    if (total <= 0 || resumen.isEmpty) {
      paint.color = ColoresApp.linea.withValues(alpha: 0.7);
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2, false, paint);
      return;
    }

    var inicio = -math.pi / 2;
    for (final item in resumen.take(8)) {
      final angulo = math.pi * 2 * (item.monto / total);
      paint.color = item.categoria.color;
      canvas.drawArc(rect, inicio, math.max(0, angulo - 0.035), false, paint);
      inicio += angulo;
    }
  }

  @override
  bool shouldRepaint(covariant _PintorDona oldDelegate) =>
      oldDelegate.total != total || oldDelegate.resumen != resumen;
}
