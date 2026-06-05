import 'package:flutter/material.dart';

import '../tema/colores_app.dart';

class FondoHuellitas extends StatelessWidget {
  const FondoHuellitas({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: ColoresApp.fondo)),
        Positioned(
          top: 26,
          right: 24,
          child: _Huella(opacidad: 0.18, tamano: 46, giro: -0.2),
        ),
        Positioned(
          top: 118,
          left: 34,
          child: _DecoracionCute(
            icono: Icons.auto_awesome,
            opacidad: 0.14,
            tamano: 20,
            giro: 0.18,
          ),
        ),
        Positioned(
          top: 194,
          right: 46,
          child: _DecoracionCute(
            icono: Icons.favorite,
            opacidad: 0.12,
            tamano: 18,
            giro: -0.28,
          ),
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
        Positioned(
          bottom: 168,
          right: 28,
          child: _DecoracionCute(
            icono: Icons.auto_awesome,
            opacidad: 0.12,
            tamano: 18,
            giro: -0.2,
          ),
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

class _DecoracionCute extends StatelessWidget {
  const _DecoracionCute({
    required this.icono,
    required this.opacidad,
    required this.tamano,
    required this.giro,
  });

  final IconData icono;
  final double opacidad;
  final double tamano;
  final double giro;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: giro,
      child: Icon(
        icono,
        size: tamano,
        color: ColoresApp.durazno.withValues(alpha: opacidad),
      ),
    );
  }
}
