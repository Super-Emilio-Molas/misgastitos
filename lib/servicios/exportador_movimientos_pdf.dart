import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../componentes/formato_dinero.dart';
import '../modelos/movimiento.dart';

class ExportadorMovimientosPdf {
  Future<void> compartir({
    required String usuario,
    required List<Movimiento> movimientos,
  }) async {
    final bytes = await _crearPdf(usuario: usuario, movimientos: movimientos);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'mis_gastitos_movimientos.pdf',
    );
  }

  Future<Uint8List> _crearPdf({
    required String usuario,
    required List<Movimiento> movimientos,
  }) async {
    final pdf = pw.Document();
    final totalIngresos = movimientos
        .where((movimiento) => movimiento.tipo == TipoMovimiento.entrada)
        .fold(0, (total, movimiento) => total + movimiento.monto);
    final totalGastos = movimientos
        .where((movimiento) => movimiento.tipo == TipoMovimiento.gasto)
        .fold(0, (total, movimiento) => total + movimiento.monto);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(28),
          theme: pw.ThemeData.withFont(),
        ),
        build: (context) => [
          pw.Text(
            'Mis Gastitos',
            style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text('Movimientos de $usuario'),
          pw.SizedBox(height: 18),
          pw.Row(
            children: [
              _resumen('Ingresos', formatoGuaranies(totalIngresos)),
              pw.SizedBox(width: 10),
              _resumen('Gastos', formatoGuaranies(totalGastos)),
              pw.SizedBox(width: 10),
              _resumen('Saldo', formatoGuaranies(totalIngresos - totalGastos)),
            ],
          ),
          pw.SizedBox(height: 18),
          if (movimientos.isEmpty)
            pw.Text('Todavia no hay movimientos para exportar.')
          else
            pw.TableHelper.fromTextArray(
              headerDecoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFEAF5E7),
              ),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellAlignment: pw.Alignment.centerLeft,
              headers: const [
                'Fecha',
                'Tipo',
                'Nombre',
                'Categoria',
                'Cantidad',
                'Monto',
                'Fijo',
              ],
              data: movimientos.map((movimiento) {
                return [
                  _fecha(movimiento.fecha),
                  movimiento.tipo == TipoMovimiento.gasto ? 'Gasto' : 'Ingreso',
                  movimiento.titulo,
                  movimiento.categoria,
                  '${_cantidad(movimiento.cantidad)} ${movimiento.unidad}',
                  formatoGuaranies(movimiento.monto),
                  movimiento.esRecurrente ? 'Si' : 'No',
                ];
              }).toList(),
            ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _resumen(String titulo, String valor) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: const PdfColor.fromInt(0xFFCEDDC8)),
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(titulo, style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(height: 4),
            pw.Text(valor, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  String _fecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  String _cantidad(double valor) {
    if (valor == valor.roundToDouble()) return valor.round().toString();
    return valor.toStringAsFixed(2);
  }
}
