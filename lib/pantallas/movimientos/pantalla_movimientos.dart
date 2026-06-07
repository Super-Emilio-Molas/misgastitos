import 'package:flutter/material.dart';

import '../../componentes/formato_dinero.dart';
import '../../componentes/fondo_huellitas.dart';
import '../../componentes/tarjeta_suave.dart';
import '../../datos/catalogo_financiero.dart';
import '../../modelos/movimiento.dart';
import '../../servicios/exportador_movimientos_pdf.dart';
import '../../tema/colores_app.dart';

class PantallaMovimientos extends StatelessWidget {
  const PantallaMovimientos({
    super.key,
    required this.usuario,
    required this.movimientos,
    required this.alAbrirConfig,
  });

  final String usuario;
  final List<Movimiento> movimientos;
  final VoidCallback alAbrirConfig;

  @override
  Widget build(BuildContext context) {
    return FondoHuellitas(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Movimientos',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: ColoresApp.tinta,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Exportar PDF',
                onPressed: movimientos.isEmpty
                    ? null
                    : () => ExportadorMovimientosPdf().compartir(
                        usuario: usuario,
                        movimientos: movimientos,
                      ),
                icon: const Icon(Icons.picture_as_pdf_outlined),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: 'Ajustes',
                onPressed: alAbrirConfig,
                icon: const Icon(Icons.tune_outlined),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Todo lo que entra y sale de tu bolsillo.',
            style: TextStyle(
              color: ColoresApp.textoSuave,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          if (movimientos.isEmpty)
            const TarjetaSuave(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ColoresApp.verdeSuave,
                    child: Icon(Icons.pets, color: ColoresApp.verde),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Todavia no cargaste movimientos.',
                      style: TextStyle(
                        color: ColoresApp.textoSuave,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            TarjetaSuave(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < movimientos.length; i++) ...[
                    _MovimientoCompleto(movimiento: movimientos[i]),
                    if (i < movimientos.length - 1)
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
      ),
    );
  }
}

class _MovimientoCompleto extends StatelessWidget {
  const _MovimientoCompleto({required this.movimiento});

  final Movimiento movimiento;

  @override
  Widget build(BuildContext context) {
    final categoria = categoriasGasto.firstWhere(
      (item) => item.nombre == movimiento.categoria,
      orElse: () => categoriasIngreso.firstWhere(
        (item) => item.nombre == movimiento.categoria,
        orElse: () => categoriasGasto.last,
      ),
    );
    final esGasto = movimiento.tipo == TipoMovimiento.gasto;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: const TextStyle(
                    color: ColoresApp.tinta,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${movimiento.categoria} · ${_cantidad(movimiento.cantidad)} ${movimiento.unidad}',
                  style: const TextStyle(
                    color: ColoresApp.textoSuave,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (movimiento.descripcion.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    movimiento.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: ColoresApp.textoSuave),
                  ),
                ],
                if (movimiento.esRecurrente) ...[
                  const SizedBox(height: 6),
                  const _ChipMovimiento(texto: 'Fijo'),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
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

  String _cantidad(double valor) {
    if (valor == valor.roundToDouble()) return valor.round().toString();
    return valor.toStringAsFixed(2);
  }
}

class _ChipMovimiento extends StatelessWidget {
  const _ChipMovimiento({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColoresApp.verdeSuave,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          texto,
          style: const TextStyle(
            color: ColoresApp.verdeOscuro,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
