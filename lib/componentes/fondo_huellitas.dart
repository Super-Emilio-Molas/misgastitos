import 'package:flutter/material.dart';

import '../tema/colores_app.dart';

class FondoHuellitas extends StatelessWidget {
  const FondoHuellitas({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 26,
          right: 24,
          child: _Huella(opacidad: 0.18, tamano: 46, giro: -0.2),
        ),
        Positioned(
          bottom: 92,
          left: 22,
          child: _Huella(opacidad: 0.14, tamano: 54, giro: 0.28),
        ),
        Positioned(
          bottom: 24,
          right: 58,
          child: _Huella(opacidad: 0.16, tamano: 38, giro: -0.08),
        ),
        child,
      ],
    );
  }
}

class _Huella extends StatelessWidget {
  const _Huella({
    required this.opacidad,
    required this.tamano,
    required this.giro,
  });

  final double opacidad;
  final double tamano;
  final double giro;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: giro,
      child: Icon(
        Icons.pets,
        size: tamano,
        color: ColoresApp.durazno.withValues(alpha: opacidad),
      ),
    );
  }
}
