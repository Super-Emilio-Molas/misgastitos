enum TipoMovimiento { gasto, entrada }

class Movimiento {
  const Movimiento({
    required this.titulo,
    required this.categoria,
    required this.monto,
    required this.fecha,
    required this.tipo,
  });

  final String titulo;
  final String categoria;
  final int monto;
  final DateTime fecha;
  final TipoMovimiento tipo;
}
