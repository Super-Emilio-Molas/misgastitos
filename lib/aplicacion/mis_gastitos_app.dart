import 'package:flutter/material.dart';

import '../pantallas/login/controlador_sesion.dart';
import '../tema/tema_app.dart';

class MisGastitosApp extends StatelessWidget {
  const MisGastitosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis gastitos',
      debugShowCheckedModeBanner: false,
      theme: crearTemaApp(),
      home: const ControladorSesion(),
    );
  }
}
