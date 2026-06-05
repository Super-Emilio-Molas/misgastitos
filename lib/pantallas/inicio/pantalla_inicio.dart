import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../componentes/formato_dinero.dart';
import '../../componentes/fondo_huellitas.dart';
import '../../componentes/tarjeta_suave.dart';
import '../../datos/datos_financieros_prueba.dart';
import '../../datos/usuario_prueba.dart';
import '../../modelos/categoria_gasto.dart';
import '../../modelos/movimiento.dart';
import '../../tema/colores_app.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({
    super.key,
    required this.movimientos,
    required this.entradas,
    required this.gastos,
  });

  final List<Movimiento> movimientos;
  final int entradas;
  final int gastos;

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
              const _BarraSuperior(),
              const SizedBox(height: 16),
              Text(
                'Hola ${UsuarioPrueba.nombreVisible}',
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
                    Expanded(child: _TarjetaResumen(gastos: widget.gastos)),
                  ],
                )
              else ...[
                _TarjetaSaldo(
                  saldo: widget.saldo,
                  saldoOculto: _saldoOculto,
                  alAlternarSaldo: _alternarSaldo,
                ),
                const SizedBox(height: 16),
                _TarjetaResumen(gastos: widget.gastos),
              ],
              const SizedBox(height: 18),
              _AccionesRapidas(ancho: ancho),
              const SizedBox(height: 22),
              _TituloSeccion(titulo: 'Ultimos movimientos'),
              const SizedBox(height: 12),
              TarjetaSuave(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (
                      var i = 0;
                      i < widget.movimientos.take(4).length;
                      i++
                    ) ...[
                      _FilaMovimiento(movimiento: widget.movimientos[i]),
                      if (i < widget.movimientos.take(4).length - 1)
                        const Divider(
                          height: 1,
                          indent: 76,
                          color: ColoresApp.linea,
                        ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _alternarSaldo() {
    setState(() => _saldoOculto = !_saldoOculto);
  }
}

class _BarraSuperior extends StatelessWidget {
  const _BarraSuperior();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          tooltip: 'Menu',
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        const Spacer(),
        IconButton.filledTonal(
          tooltip: 'Notificaciones',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
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
        final anchoPerrito = (anchoTarjeta * 0.37).clamp(104.0, 150.0);
        final espacioPerrito = (anchoPerrito * 0.42).clamp(46.0, 68.0);
        final margenSuperior = (anchoPerrito * 0.42).clamp(42.0, 62.0);
        final paddingSuperior = compacto ? 18.0 : 20.0;
        final posicionDerecha = (anchoTarjeta * 0.035).clamp(4.0, 14.0);

        return Stack(
          clipBehavior: Clip.none,
          children: [
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
            Positioned(
              top: 2,
              right: posicionDerecha,
              child: IgnorePointer(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
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
          ],
        );
      },
    );
  }
}

class _TarjetaResumen extends StatelessWidget {
  const _TarjetaResumen({required this.gastos});

  final int gastos;

  @override
  Widget build(BuildContext context) {
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
                    painter: _PintorDona(gastos: gastos),
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
          ...categoriasGasto.take(3).map((categoria) {
            final monto = _gastadoPorCategoria(categoria.nombre);
            return _FilaCategoria(categoria: categoria, monto: monto);
          }),
        ],
      ),
    );
  }

  int _gastadoPorCategoria(String nombre) {
    final semillas = {
      'Alimentacion': 80000,
      'Hogar': 50000,
      'Transporte': 40000,
    };
    return semillas[nombre] ?? 0;
  }
}

class _AccionesRapidas extends StatelessWidget {
  const _AccionesRapidas({required this.ancho});

  final double ancho;

  @override
  Widget build(BuildContext context) {
    final columnas = ancho < 380 ? 2 : 4;
    return GridView.count(
      crossAxisCount: columnas,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: columnas == 2 ? 2.3 : 0.95,
      children: const [
        _AccionPastel(
          titulo: 'Gasto',
          icono: Icons.add_circle_outline,
          fondo: ColoresApp.verdeSuave,
          color: ColoresApp.verde,
        ),
        _AccionPastel(
          titulo: 'Entrada',
          icono: Icons.receipt_long_outlined,
          fondo: ColoresApp.duraznoSuave,
          color: ColoresApp.durazno,
        ),
        _AccionPastel(
          titulo: 'Metas',
          icono: Icons.flag_outlined,
          fondo: ColoresApp.lilaSuave,
          color: ColoresApp.lila,
        ),
        _AccionPastel(
          titulo: 'Perrito',
          icono: Icons.pets,
          fondo: ColoresApp.amarilloSuave,
          color: ColoresApp.amarillo,
        ),
      ],
    );
  }
}

class _AccionPastel extends StatelessWidget {
  const _AccionPastel({
    required this.titulo,
    required this.icono,
    required this.fondo,
    required this.color,
  });

  final String titulo;
  final IconData icono;
  final Color fondo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: fondo,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: color, size: 30),
              const SizedBox(height: 7),
              Text(
                titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ColoresApp.tinta,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
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

class _FilaCategoria extends StatelessWidget {
  const _FilaCategoria({required this.categoria, required this.monto});

  final CategoriaGasto categoria;
  final int monto;

  @override
  Widget build(BuildContext context) {
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
            formatoGuaranies(monto),
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
  _PintorDona({required this.gastos});

  final int gastos;

  @override
  void paint(Canvas canvas, Size size) {
    final trazo = size.width * 0.16;
    final rect =
        Offset(trazo / 2, trazo / 2) &
        Size(size.width - trazo, size.height - trazo);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = trazo;
    final colores = [
      ColoresApp.verde,
      ColoresApp.durazno,
      ColoresApp.lila,
      ColoresApp.amarillo,
      ColoresApp.celeste,
    ];
    var inicio = -math.pi / 2;
    for (var i = 0; i < colores.length; i++) {
      paint.color = colores[i];
      canvas.drawArc(
        rect,
        inicio,
        math.pi * 2 / colores.length - 0.04,
        false,
        paint,
      );
      inicio += math.pi * 2 / colores.length;
    }
  }

  @override
  bool shouldRepaint(covariant _PintorDona oldDelegate) =>
      oldDelegate.gastos != gastos;
}
