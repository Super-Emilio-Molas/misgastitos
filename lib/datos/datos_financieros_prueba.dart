import 'package:flutter/material.dart';

import '../modelos/categoria_gasto.dart';
import '../modelos/movimiento.dart';
import '../tema/colores_app.dart';

const categoriasGasto = [
  CategoriaGasto(
    nombre: 'Alimentacion',
    icono: Icons.shopping_basket_outlined,
    color: ColoresApp.verde,
    colorSuave: ColoresApp.verdeSuave,
    presupuesto: 120000,
  ),
  CategoriaGasto(
    nombre: 'Hogar',
    icono: Icons.home_outlined,
    color: ColoresApp.durazno,
    colorSuave: ColoresApp.duraznoSuave,
    presupuesto: 90000,
  ),
  CategoriaGasto(
    nombre: 'Transporte',
    icono: Icons.directions_car_outlined,
    color: ColoresApp.lila,
    colorSuave: ColoresApp.lilaSuave,
    presupuesto: 60000,
  ),
  CategoriaGasto(
    nombre: 'Diversion',
    icono: Icons.confirmation_number_outlined,
    color: ColoresApp.amarillo,
    colorSuave: ColoresApp.amarilloSuave,
    presupuesto: 50000,
  ),
  CategoriaGasto(
    nombre: 'Otros',
    icono: Icons.more_horiz,
    color: ColoresApp.celeste,
    colorSuave: ColoresApp.celesteSuave,
    presupuesto: 40000,
  ),
];

List<Movimiento> movimientosIniciales() {
  final ahora = DateTime.now();
  return [
    Movimiento(
      titulo: 'Supermercado',
      categoria: 'Alimentacion',
      monto: 25000,
      fecha: ahora.subtract(const Duration(hours: 2)),
      tipo: TipoMovimiento.gasto,
    ),
    Movimiento(
      titulo: 'Luz',
      categoria: 'Hogar',
      monto: 40000,
      fecha: ahora.subtract(const Duration(days: 1, hours: 2)),
      tipo: TipoMovimiento.gasto,
    ),
    Movimiento(
      titulo: 'Pasaje',
      categoria: 'Transporte',
      monto: 5000,
      fecha: ahora.subtract(const Duration(days: 1, hours: 3)),
      tipo: TipoMovimiento.gasto,
    ),
    Movimiento(
      titulo: 'Freelance',
      categoria: 'Otros',
      monto: 320000,
      fecha: ahora.subtract(const Duration(days: 3)),
      tipo: TipoMovimiento.entrada,
    ),
  ];
}
