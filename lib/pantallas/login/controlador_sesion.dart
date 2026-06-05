import 'package:flutter/material.dart';

import '../../servicios/preferencias_sesion.dart';
import '../../servicios/servicio_biometria.dart';
import '../inicio/pantalla_principal.dart';
import 'pantalla_login.dart';

class ControladorSesion extends StatefulWidget {
  const ControladorSesion({super.key});

  @override
  State<ControladorSesion> createState() => _ControladorSesionState();
}

class _ControladorSesionState extends State<ControladorSesion> {
  final _preferencias = PreferenciasSesion();
  final _biometria = ServicioBiometria();

  bool _cargando = true;
  bool _sesionIniciada = false;
  bool _recordarme = false;
  String _usuarioRecordado = '';

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final recordarme = await _preferencias.obtenerRecordarme();
    final usuario = await _preferencias.obtenerUsuarioRecordado();

    if (!mounted) return;
    setState(() {
      _recordarme = recordarme;
      _usuarioRecordado = usuario;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_sesionIniciada) {
      return PantallaPrincipal(
        alCerrarSesion: () => setState(() => _sesionIniciada = false),
      );
    }

    return PantallaLogin(
      usuarioInicial: _usuarioRecordado,
      recordarmeInicial: _recordarme,
      alIngresar: (recordarme, usuario) async {
        await _preferencias.guardarRecordarme(
          activo: recordarme,
          usuario: usuario,
        );
        if (!mounted) return;
        setState(() {
          _recordarme = recordarme;
          _usuarioRecordado = recordarme ? usuario : '';
          _sesionIniciada = true;
        });
      },
      alUsarBiometria: () async {
        final biometriaActiva = await _preferencias.obtenerBiometriaActiva();
        if (!biometriaActiva) return false;
        final ok = await _biometria.autenticar();
        if (ok && mounted) setState(() => _sesionIniciada = true);
        return ok;
      },
    );
  }
}
