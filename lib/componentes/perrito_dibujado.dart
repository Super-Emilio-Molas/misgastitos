import 'package:flutter/material.dart';

import '../tema/colores_app.dart';

class PerritoDibujado extends StatelessWidget {
  const PerritoDibujado({super.key, required this.tamano});

  final double tamano;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: tamano,
      child: CustomPaint(painter: _PintorPerrito()),
    );
  }
}

class _PintorPerrito extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final escala = size.width / 200;
    canvas.save();
    canvas.scale(escala);

    final relleno = Paint()..color = const Color(0xFFFFE6BC);
    final oreja = Paint()..color = const Color(0xFFF7C98B);
    final linea = Paint()
      ..color = ColoresApp.tinta
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final billetera = Paint()..color = const Color(0xFF83542E);
    final dinero = Paint()..color = const Color(0xFF9FBE74);

    canvas.drawOval(
      const Rect.fromLTWH(34, 132, 132, 28),
      Paint()..color = const Color(0xFFEAD0AD),
    );
    canvas.drawOval(const Rect.fromLTWH(30, 32, 102, 116), relleno);
    canvas.drawOval(const Rect.fromLTWH(45, 52, 35, 68), oreja);
    canvas.drawPath(
      Path()
        ..moveTo(52, 62)
        ..quadraticBezierTo(32, 84, 38, 108)
        ..quadraticBezierTo(47, 127, 70, 118)
        ..quadraticBezierTo(82, 89, 72, 62),
      linea,
    );
    canvas.drawPath(
      Path()
        ..moveTo(86, 32)
        ..lineTo(104, 16)
        ..lineTo(100, 37)
        ..quadraticBezierTo(126, 28, 143, 44)
        ..quadraticBezierTo(122, 50, 132, 65)
        ..quadraticBezierTo(143, 75, 164, 75)
        ..quadraticBezierTo(181, 76, 185, 88)
        ..quadraticBezierTo(166, 86, 156, 102)
        ..quadraticBezierTo(139, 132, 106, 139)
        ..quadraticBezierTo(69, 149, 42, 126)
        ..quadraticBezierTo(24, 108, 30, 82)
        ..quadraticBezierTo(36, 54, 65, 44)
        ..quadraticBezierTo(54, 36, 86, 32),
      linea,
    );
    canvas.drawCircle(
      const Offset(126, 78),
      9,
      Paint()..color = ColoresApp.tinta,
    );
    canvas.drawCircle(
      const Offset(130, 74),
      3.2,
      Paint()..color = Colors.white,
    );
    canvas.drawOval(
      const Rect.fromLTWH(156, 83, 30, 18),
      Paint()..color = ColoresApp.tinta,
    );
    canvas.drawPath(
      Path()
        ..moveTo(125, 103)
        ..quadraticBezierTo(142, 116, 161, 105),
      linea..strokeWidth = 4,
    );
    canvas.drawPath(
      Path()
        ..moveTo(42, 132)
        ..quadraticBezierTo(8, 118, 27, 90)
        ..quadraticBezierTo(36, 115, 42, 132),
      linea..strokeWidth = 6,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(106, 96, 58, 36),
        const Radius.circular(5),
      ),
      dinero,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(84, 112, 88, 52),
        const Radius.circular(10),
      ),
      billetera,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(84, 112, 88, 52),
        const Radius.circular(10),
      ),
      linea,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(142, 126, 36, 28),
        const Radius.circular(7),
      ),
      billetera,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(142, 126, 36, 28),
        const Radius.circular(7),
      ),
      linea,
    );
    canvas.drawCircle(
      const Offset(158, 140),
      8,
      Paint()..color = ColoresApp.amarillo,
    );
    canvas.drawCircle(const Offset(158, 140), 8, linea..strokeWidth = 3);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
