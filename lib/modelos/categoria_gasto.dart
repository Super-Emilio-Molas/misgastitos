import 'package:flutter/material.dart';

class CategoriaGasto {
  const CategoriaGasto({
    required this.nombre,
    required this.icono,
    required this.color,
    required this.colorSuave,
    required this.presupuesto,
  });

  final String nombre;
  final IconData icono;
  final Color color;
  final Color colorSuave;
  final int presupuesto;
}
