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
    presupuesto: 0,
  ),
  CategoriaGasto(
    nombre: 'Hogar',
    icono: Icons.home_outlined,
    color: ColoresApp.durazno,
    colorSuave: ColoresApp.duraznoSuave,
    presupuesto: 0,
  ),
  CategoriaGasto(
    nombre: 'Transporte',
    icono: Icons.directions_car_outlined,
    color: ColoresApp.lila,
    colorSuave: ColoresApp.lilaSuave,
    presupuesto: 0,
  ),
  CategoriaGasto(
    nombre: 'Diversion',
    icono: Icons.confirmation_number_outlined,
    color: ColoresApp.amarillo,
    colorSuave: ColoresApp.amarilloSuave,
    presupuesto: 0,
  ),
  CategoriaGasto(
    nombre: 'Otros',
    icono: Icons.more_horiz,
    color: ColoresApp.celeste,
    colorSuave: ColoresApp.celesteSuave,
    presupuesto: 0,
  ),
];

List<Movimiento> movimientosIniciales() {
  return [];
}
