import 'package:flutter/material.dart';

import '../../modelos/usuario_sesion.dart';
import '../../servicios/preferencias_sesion.dart';
import '../../servicios/repositorio_movimientos.dart';
import '../../servicios/servicio_biometria.dart';
import '../../servicios/servicio_autenticacion.dart';
import '../inicio/pantalla_principal.dart';
import 'pantalla_login.dart';

class ControladorSesion extends StatefulWidget {
  const ControladorSesion({super.key, this.autenticacion, this.movimientos});

  final ServicioAutenticacion? autenticacion;
  final RepositorioMovimientos? movimientos;

  @override
  State<ControladorSesion> createState() => _ControladorSesionState();
}

class _ControladorSesionState extends State<ControladorSesion> {
  final _preferencias = PreferenciasSesion();
  final _biometria = ServicioBiometria();
  late final ServicioAutenticacion _autenticacion;
  late final RepositorioMovimientos _movimientos;

  bool _cargando = true;
  bool _recordarme = false;
  String _usuarioRecordado = '';

  @override
  void initState() {
    super.initState();
    _autenticacion = widget.autenticacion ?? ServicioAutenticacionFirebase();
    _movimientos = widget.movimientos ?? RepositorioMovimientosFirebase();
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

    return StreamBuilder<UsuarioSesion?>(
      stream: _autenticacion.cambiosSesion(),
      initialData: _autenticacion.usuarioActual,
      builder: (context, snapshot) {
        final usuario = snapshot.data;
        if (usuario != null) {
          return PantallaPrincipal(
            usuario: usuario,
            movimientos: _movimientos,
            alCerrarSesion: _autenticacion.cerrarSesion,
          );
        }

        return PantallaLogin(
          usuarioInicial: _usuarioRecordado,
          recordarmeInicial: _recordarme,
          alIngresar: (recordarme, usuario, clave) async {
            try {
              await _autenticacion.ingresar(usuario: usuario, clave: clave);
              await _preferencias.guardarRecordarme(
                activo: recordarme,
                usuario: usuario,
              );
              if (!mounted) return null;
              if (recordarme) {
                await _preferencias.guardarCredencialesRapidas(
                  usuario: usuario,
                  clave: clave,
                );
              }
              setState(() {
                _recordarme = recordarme;
                _usuarioRecordado = recordarme ? usuario : '';
              });
              return null;
            } catch (error) {
              return mensajeErrorAutenticacion(error);
            }
          },
          alRegistrar: (correo, usuario, clave) async {
            try {
              await _autenticacion.registrar(
                correo: correo,
                usuario: usuario,
                clave: clave,
              );
              await _preferencias.guardarRecordarme(
                activo: true,
                usuario: usuario,
              );
              await _preferencias.guardarCredencialesRapidas(
                usuario: usuario,
                clave: clave,
              );
              if (!mounted) return null;
              setState(() {
                _recordarme = true;
                _usuarioRecordado = usuario;
              });
              return null;
            } catch (error) {
              return mensajeErrorAutenticacion(error);
            }
          },
          alUsarBiometria: () async {
            try {
              if (_usuarioRecordado.trim().isEmpty) return false;
              final biometriaActiva = await _preferencias
                  .obtenerBiometriaActiva();
              if (!biometriaActiva) return false;
              final ok = await _biometria.autenticar();
              if (!ok) return false;
              if (_autenticacion.usuarioActual != null) return true;

              final credenciales = await _preferencias
                  .obtenerCredencialesRapidas(usuario: _usuarioRecordado);
              if (credenciales == null) return false;
              await _autenticacion.ingresar(
                usuario: credenciales.usuario,
                clave: credenciales.clave,
              );
              return true;
            } catch (_) {
              return false;
            }
          },
          alUsarCodigo: (usuario, codigo) async {
            try {
              final guardado = await _preferencias.obtenerCodigoRapido(
                usuario: usuario,
              );
              if (guardado.isEmpty || guardado != codigo) return false;
              return _entrarConAccesoRapido(usuario);
            } catch (_) {
              return false;
            }
          },
        );
      },
    );
  }

  Future<bool> _entrarConAccesoRapido(String usuario) async {
    if (_autenticacion.usuarioActual != null) return true;
    final credenciales = await _preferencias.obtenerCredencialesRapidas(
      usuario: usuario,
    );
    if (credenciales == null) return false;
    await _autenticacion.ingresar(
      usuario: credenciales.usuario,
      clave: credenciales.clave,
    );
    return true;
  }
}
