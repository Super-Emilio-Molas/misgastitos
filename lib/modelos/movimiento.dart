enum TipoMovimiento { gasto, entrada }

class Movimiento {
  const Movimiento({
    required this.titulo,
    required this.categoria,
    required this.monto,
    required this.fecha,
    required this.tipo,
    this.descripcion = '',
    this.cantidad = 1,
    this.unidad = 'unidad',
    this.esRecurrente = false,
  });

  final String titulo;
  final String categoria;
  final int monto;
  final DateTime fecha;
  final TipoMovimiento tipo;
  final String descripcion;
  final double cantidad;
  final String unidad;
  final bool esRecurrente;

  factory Movimiento.desdeMapa(Map<String, dynamic> mapa) {
    final fecha = mapa['fecha'];
    return Movimiento(
      titulo: (mapa['titulo'] as String?)?.trim().isNotEmpty == true
          ? mapa['titulo'] as String
          : 'Movimiento',
      categoria: (mapa['categoria'] as String?)?.trim().isNotEmpty == true
          ? mapa['categoria'] as String
          : 'Otros',
      monto: (mapa['monto'] as num?)?.round() ?? 0,
      fecha: fecha is DateTime
          ? fecha
          : DateTime.tryParse(fecha?.toString() ?? '') ?? DateTime.now(),
      tipo: mapa['tipo'] == 'entrada'
          ? TipoMovimiento.entrada
          : TipoMovimiento.gasto,
      descripcion: (mapa['descripcion'] as String?) ?? '',
      cantidad: (mapa['cantidad'] as num?)?.toDouble() ?? 1,
      unidad: (mapa['unidad'] as String?) ?? 'unidad',
      esRecurrente: (mapa['esRecurrente'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> aMapa() {
    return {
      'titulo': titulo,
      'categoria': categoria,
      'monto': monto,
      'fecha': fecha,
      'tipo': tipo == TipoMovimiento.entrada ? 'entrada' : 'gasto',
      'descripcion': descripcion,
      'cantidad': cantidad,
      'unidad': unidad,
      'esRecurrente': esRecurrente,
    };
  }
}
