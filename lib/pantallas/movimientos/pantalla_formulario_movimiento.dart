import 'package:flutter/material.dart';

import '../../datos/catalogo_financiero.dart';
import '../../modelos/categoria_gasto.dart';
import '../../modelos/movimiento.dart';
import '../../tema/colores_app.dart';

class PantallaFormularioMovimiento extends StatefulWidget {
  const PantallaFormularioMovimiento({super.key});

  @override
  State<PantallaFormularioMovimiento> createState() =>
      _PantallaFormularioMovimientoState();
}

class _PantallaFormularioMovimientoState
    extends State<PantallaFormularioMovimiento> {
  final _titulo = TextEditingController();
  final _descripcion = TextEditingController();
  final _monto = TextEditingController();
  final _cantidad = TextEditingController(text: '1');

  TipoMovimiento _tipo = TipoMovimiento.gasto;
  DateTime _fecha = DateTime.now();
  String _unidad = 'unidad';
  bool _recurrente = false;
  late CategoriaGasto _categoria = categoriasGasto.first;

  List<CategoriaGasto> get _categorias =>
      _tipo == TipoMovimiento.gasto ? categoriasGasto : categoriasIngreso;

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    _monto.dispose();
    _cantidad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esGasto = _tipo == TipoMovimiento.gasto;
    final teclado = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: teclado > 0 ? 0.98 : 0.92,
      minChildSize: 0.68,
      maxChildSize: 0.98,
      builder: (context, scrollController) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: teclado),
          child: Material(
            color: ColoresApp.fondo,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: ListView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(20, 14, 20, teclado > 0 ? 34 : 24),
              children: [
                Center(
                  child: Container(
                    width: 46,
                    height: 5,
                    decoration: BoxDecoration(
                      color: ColoresApp.linea,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'images/logo_app.jpeg',
                        width: 58,
                        height: 58,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Agregar movimiento',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: ColoresApp.tinta,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 23,
                                ),
                          ),
                          const Text(
                            'Tu bolsillo, bien ordenadito.',
                            style: TextStyle(
                              color: ColoresApp.textoSuave,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _SelectorTipo(
                  tipo: _tipo,
                  alCambiar: (tipo) {
                    setState(() {
                      _tipo = tipo;
                      _categoria =
                          (tipo == TipoMovimiento.gasto
                                  ? categoriasGasto
                                  : categoriasIngreso)
                              .first;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _CampoFormulario(
                  controlador: _titulo,
                  etiqueta: esGasto ? 'En que gastaste' : 'Nombre del ingreso',
                  pista: esGasto ? 'Ej: Supermercado' : 'Ej: Salario',
                  icono: esGasto
                      ? Icons.shopping_bag_outlined
                      : Icons.payments_outlined,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _CampoFormulario(
                        controlador: _monto,
                        etiqueta: 'Costo',
                        pista: 'Gs.',
                        icono: Icons.attach_money,
                        teclado: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: _CampoFormulario(
                        controlador: _cantidad,
                        etiqueta: 'Cantidad',
                        pista: '1',
                        icono: Icons.numbers,
                        teclado: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _SelectorUnidad(
                  unidad: _unidad,
                  alCambiar: (valor) => setState(() => _unidad = valor),
                ),
                const SizedBox(height: 12),
                _BotonCategoria(
                  categoria: _categoria,
                  total: _categorias.length,
                  alTocar: _elegirCategoria,
                ),
                const SizedBox(height: 12),
                _SelectorFecha(fecha: _fecha, alTocar: _elegirFecha),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _recurrente,
                  activeThumbColor: ColoresApp.verde,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    esGasto ? 'Es un gasto constante' : 'Es un ingreso fijo',
                    style: const TextStyle(
                      color: ColoresApp.tinta,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: Text(
                    esGasto
                        ? 'Lo vamos a marcar como gasto recurrente.'
                        : 'Lo vamos a marcar como ingreso mensual/fijo.',
                    style: const TextStyle(
                      color: ColoresApp.textoSuave,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  secondary: const Icon(Icons.repeat, color: ColoresApp.verde),
                  onChanged: (valor) => setState(() => _recurrente = valor),
                ),
                const SizedBox(height: 12),
                _CampoFormulario(
                  controlador: _descripcion,
                  etiqueta: 'Descripcion',
                  pista: 'Opcional',
                  icono: Icons.notes_outlined,
                  maxLineas: 3,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _guardar,
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(esGasto ? 'Guardar gasto' : 'Guardar ingreso'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _elegirFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (fecha != null) setState(() => _fecha = fecha);
  }

  Future<void> _elegirCategoria() async {
    final categoria = await showModalBottomSheet<CategoriaGasto>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BuscadorCategorias(categorias: _categorias),
    );
    if (categoria != null) setState(() => _categoria = categoria);
  }

  void _guardar() {
    final titulo = _titulo.text.trim();
    final monto = int.tryParse(_monto.text.replaceAll('.', '').trim()) ?? 0;
    final cantidad = double.tryParse(_cantidad.text.replaceAll(',', '.')) ?? 1;

    if (titulo.isEmpty || monto <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Completa nombre y costo.')));
      return;
    }

    Navigator.pop(
      context,
      Movimiento(
        titulo: titulo,
        categoria: _categoria.nombre,
        monto: monto,
        fecha: _fecha,
        tipo: _tipo,
        descripcion: _descripcion.text.trim(),
        cantidad: cantidad,
        unidad: _unidad,
        esRecurrente: _recurrente,
      ),
    );
  }
}

class _SelectorTipo extends StatelessWidget {
  const _SelectorTipo({required this.tipo, required this.alCambiar});

  final TipoMovimiento tipo;
  final ValueChanged<TipoMovimiento> alCambiar;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TipoMovimiento>(
      segments: const [
        ButtonSegment(
          value: TipoMovimiento.gasto,
          icon: Icon(Icons.remove_circle_outline),
          label: Text('Gasto'),
        ),
        ButtonSegment(
          value: TipoMovimiento.entrada,
          icon: Icon(Icons.add_circle_outline),
          label: Text('Ingreso'),
        ),
      ],
      selected: {tipo},
      onSelectionChanged: (valor) => alCambiar(valor.first),
    );
  }
}

class _CampoFormulario extends StatelessWidget {
  const _CampoFormulario({
    required this.controlador,
    required this.etiqueta,
    required this.pista,
    required this.icono,
    this.teclado,
    this.maxLineas = 1,
  });

  final TextEditingController controlador;
  final String etiqueta;
  final String pista;
  final IconData icono;
  final TextInputType? teclado;
  final int maxLineas;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controlador,
      keyboardType: teclado,
      maxLines: maxLineas,
      scrollPadding: const EdgeInsets.only(bottom: 180),
      decoration: InputDecoration(
        labelText: etiqueta,
        hintText: pista,
        prefixIcon: Icon(icono, color: ColoresApp.verde),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: ColoresApp.linea),
        ),
      ),
    );
  }
}

class _SelectorUnidad extends StatelessWidget {
  const _SelectorUnidad({required this.unidad, required this.alCambiar});

  final String unidad;
  final ValueChanged<String> alCambiar;

  @override
  Widget build(BuildContext context) {
    const unidades = [
      'unidad',
      'kg',
      'g',
      'litro',
      'ml',
      'metro',
      'hora',
      'dia',
      'mes',
      'servicio',
      'paquete',
      'cuota',
    ];
    return DropdownButtonFormField<String>(
      initialValue: unidad,
      decoration: InputDecoration(
        labelText: 'Unidad de medida',
        prefixIcon: const Icon(Icons.straighten, color: ColoresApp.verde),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: ColoresApp.linea),
        ),
      ),
      items: unidades
          .map((unidad) => DropdownMenuItem(value: unidad, child: Text(unidad)))
          .toList(),
      onChanged: (valor) {
        if (valor != null) alCambiar(valor);
      },
    );
  }
}

class _BotonCategoria extends StatelessWidget {
  const _BotonCategoria({
    required this.categoria,
    required this.total,
    required this.alTocar,
  });

  final CategoriaGasto categoria;
  final int total;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: alTocar,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: ColoresApp.linea),
      ),
      tileColor: Colors.white,
      leading: CircleAvatar(
        backgroundColor: categoria.colorSuave,
        child: Icon(categoria.icono, color: categoria.color),
      ),
      title: Text(
        categoria.nombre,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      subtitle: Text('Buscar entre $total categorias'),
      trailing: const Icon(Icons.search),
    );
  }
}

class _SelectorFecha extends StatelessWidget {
  const _SelectorFecha({required this.fecha, required this.alTocar});

  final DateTime fecha;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: alTocar,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: ColoresApp.linea),
      ),
      tileColor: Colors.white,
      leading: const CircleAvatar(
        backgroundColor: ColoresApp.celesteSuave,
        child: Icon(Icons.calendar_month_outlined, color: ColoresApp.celeste),
      ),
      title: const Text('Fecha', style: TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text('${fecha.day}/${fecha.month}/${fecha.year}'),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _BuscadorCategorias extends StatefulWidget {
  const _BuscadorCategorias({required this.categorias});

  final List<CategoriaGasto> categorias;

  @override
  State<_BuscadorCategorias> createState() => _BuscadorCategoriasState();
}

class _BuscadorCategoriasState extends State<_BuscadorCategorias> {
  final _busqueda = TextEditingController();
  String _texto = '';

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtradas = widget.categorias
        .where(
          (categoria) =>
              categoria.nombre.toLowerCase().contains(_texto.toLowerCase()),
        )
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.45,
      maxChildSize: 0.94,
      builder: (context, controller) => Material(
        color: ColoresApp.fondo,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(
                color: ColoresApp.linea,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: TextField(
                controller: _busqueda,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar categoria',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onChanged: (valor) => setState(() => _texto = valor),
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                itemCount: filtradas.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final categoria = filtradas[index];
                  return ListTile(
                    onTap: () => Navigator.pop(context, categoria),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    tileColor: Colors.white,
                    leading: CircleAvatar(
                      backgroundColor: categoria.colorSuave,
                      child: Icon(categoria.icono, color: categoria.color),
                    ),
                    title: Text(
                      categoria.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
