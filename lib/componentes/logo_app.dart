import 'package:flutter/material.dart';

import '../tema/colores_app.dart';
import 'perrito_dibujado.dart';

class LogoApp extends StatelessWidget {
  const LogoApp({super.key, required this.tamano});

  final double tamano;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        'images/logo_app.jpeg',
        width: tamano,
        height: tamano,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: tamano,
            height: tamano,
            decoration: BoxDecoration(
              color: ColoresApp.crema,
              borderRadius: BorderRadius.circular(24),
            ),
            child: PerritoDibujado(tamano: tamano * 0.86),
          );
        },
      ),
    );
  }
}
