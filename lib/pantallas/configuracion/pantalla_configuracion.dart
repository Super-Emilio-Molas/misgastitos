import 'package:flutter/material.dart';

import '../../componentes/fondo_huellitas.dart';
import '../../componentes/logo_app.dart';
import '../../componentes/tarjeta_suave.dart';
import '../../modelos/usuario_sesion.dart';
import '../../servicios/preferencias_sesion.dart';
import '../../servicios/servicio_biometria.dart';
import '../../tema/colores_app.dart';

class PantallaConfig extends StatefulWidget {
  const PantallaConfig({
    super.key,
    required this.usuario,
    required this.alCerrarSesion,
  });

  final UsuarioSesion usuario;
  final Future<void> Function() alCerrarSesion;

  @override
  State<PantallaConfig> createState() => _PantallaConfigState();
}

class _PantallaConfigState extends State<PantallaConfig> {
  final _preferencias = PreferenciasSesion();
  final _biometria = ServicioBiometria();

  bool _biometriaActiva = false;
  bool _codigoActivo = false;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final activa = await _preferencias.obtenerBiometriaActiva();
    final codigo = await _preferencias.obtenerCodigoRapido(
      usuario: widget.usuario.usuario,
    );
    if (!mounted) return;
    setState(() {
      _biometriaActiva = activa;
      _codigoActivo = codigo.isNotEmpty;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FondoHuellitas(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
        children: [
          const Center(child: LogoApp(tamano: 132)),
          const SizedBox(height: 18),
          Text(
            'Configuracion',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: ColoresApp.tinta),
          ),
          const SizedBox(height: 18),
          TarjetaSuave(
            child: Column(
              children: [
                _FilaConfig(
                  icono: Icons.fingerprint,
                  titulo: 'Acceso por biometria',
                  subtitulo: 'Usa huella o rostro disponible en Android.',
                  trailing: _cargando
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Switch(
                          value: _biometriaActiva,
                          activeThumbColor: ColoresApp.verde,
                          onChanged: _cambiarBiometria,
                        ),
                ),
                const Divider(color: ColoresApp.linea),
                _FilaConfig(
                  icono: Icons.pin_outlined,
                  titulo: 'Codigo de 4 digitos',
                  subtitulo: _codigoActivo
                      ? 'Activo solo para ${widget.usuario.nombre}.'
                      : 'Crea un PIN solo para esta cuenta.',
                  trailing: Switch(
                    value: _codigoActivo,
                    activeThumbColor: ColoresApp.verde,
                    onChanged: _cambiarCodigo,
                  ),
                ),
                const Divider(color: ColoresApp.linea),
                _FilaConfig(
                  icono: Icons.pets,
                  titulo: 'Modo cute',
                  subtitulo: 'Huellitas y colores pastel activados.',
                  trailing: const Icon(
                    Icons.check_circle,
                    color: ColoresApp.verde,
                  ),
                ),
                const Divider(color: ColoresApp.linea),
                _FilaConfig(
                  icono: Icons.logout,
                  titulo: 'Cerrar sesion',
                  subtitulo: 'Volver al login.',
                  trailing: const Icon(Icons.chevron_right),
                  alTocar: () {
                    widget.alCerrarSesion();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cambiarBiometria(bool valor) async {
    if (valor) {
      final disponible = await _biometria.estaDisponible();
      if (!disponible) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este dispositivo no tiene biometria disponible.'),
          ),
        );
        return;
      }

      final confirmado = await _biometria.autenticar();
      if (!confirmado) return;
    }

    await _preferencias.guardarBiometriaActiva(valor);
    if (!mounted) return;
    setState(() => _biometriaActiva = valor);
  }

  Future<void> _cambiarCodigo(bool valor) async {
    if (!valor) {
      await _preferencias.guardarCodigoRapido(
        usuario: widget.usuario.usuario,
        codigo: '',
      );
      if (mounted) setState(() => _codigoActivo = false);
      return;
    }

    final codigo = await _pedirTexto(
      titulo: 'Codigo rapido',
      pista: '4 digitos',
      icono: Icons.pin_outlined,
      teclado: TextInputType.number,
      maximo: 4,
    );
    if (codigo == null) return;
    if (!RegExp(r'^\d{4}$').hasMatch(codigo)) {
      _mostrarMensaje('El codigo debe tener 4 digitos.');
      return;
    }

    await _preferencias.guardarCodigoRapido(
      usuario: widget.usuario.usuario,
      codigo: codigo,
    );
    if (mounted) setState(() => _codigoActivo = true);
  }

  Future<String?> _pedirTexto({
    required String titulo,
    required String pista,
    required IconData icono,
    required TextInputType teclado,
    required int maximo,
  }) async {
    final controlador = TextEditingController();
    final resultado = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: TextField(
          controller: controlador,
          keyboardType: teclado,
          maxLength: maximo,
          obscureText: true,
          decoration: InputDecoration(hintText: pista, prefixIcon: Icon(icono)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controlador.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    return resultado;
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }
}

class _FilaConfig extends StatelessWidget {
  const _FilaConfig({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.trailing,
    this.alTocar,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final Widget trailing;
  final VoidCallback? alTocar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: alTocar,
      leading: CircleAvatar(
        backgroundColor: ColoresApp.verdeSuave,
        child: Icon(icono, color: ColoresApp.verde),
      ),
      title: Text(
        titulo,
        style: const TextStyle(
          color: ColoresApp.tinta,
          fontWeight: FontWeight.w900,
        ),
      ),
      subtitle: Text(
        subtitulo,
        style: const TextStyle(
          color: ColoresApp.textoSuave,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: trailing,
    );
  }
}
