import 'package:flutter/material.dart';

import '../pantallas/login/controlador_sesion.dart';
import '../servicios/repositorio_movimientos.dart';
import '../servicios/servicio_autenticacion.dart';
import '../tema/tema_app.dart';

class MisGastitosApp extends StatelessWidget {
  const MisGastitosApp({super.key, this.autenticacion, this.movimientos});

  final ServicioAutenticacion? autenticacion;
  final RepositorioMovimientos? movimientos;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis gastitos',
      debugShowCheckedModeBanner: false,
      theme: crearTemaApp(),
      home: ControladorSesion(
        autenticacion: autenticacion,
        movimientos: movimientos,
      ),
    );
  }
}
