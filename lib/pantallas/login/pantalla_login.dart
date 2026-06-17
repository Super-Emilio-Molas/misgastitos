import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../componentes/campo_suave.dart';
import '../../componentes/fondo_huellitas.dart';
import '../../componentes/logo_app.dart';
import '../../tema/colores_app.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({
    super.key,
    required this.usuarioInicial,
    required this.recordarmeInicial,
    required this.alIngresar,
    required this.alRegistrar,
    required this.alUsarBiometria,
    required this.alUsarCodigo,
  });

  final String usuarioInicial;
  final bool recordarmeInicial;
  final Future<String?> Function(bool recordarme, String usuario, String clave)
  alIngresar;
  final Future<String?> Function(String correo, String usuario, String clave)
  alRegistrar;
  final Future<bool> Function() alUsarBiometria;
  final Future<bool> Function(String usuario, String codigo) alUsarCodigo;

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  late final TextEditingController _usuario;
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();
  final _confirmarContrasena = TextEditingController();
  late bool _recordarme;
  bool _modoRegistro = false;
  bool _mostrarContrasena = false;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _usuario = TextEditingController(text: widget.usuarioInicial);
    _recordarme = widget.recordarmeInicial;
  }

  @override
  void dispose() {
    _usuario.dispose();
    _correo.dispose();
    _contrasena.dispose();
    _confirmarContrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: FondoHuellitas(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final alto = constraints.maxHeight;
              final ancho = constraints.maxWidth;
              final compacto = alto < 760 || ancho < 370;
              final logo = _modoRegistro
                  ? (compacto ? 70.0 : 92.0)
                  : (compacto ? 96.0 : 132.0);
              final separacion = _modoRegistro ? 6.0 : (compacto ? 8.0 : 14.0);

              return Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    22,
                    compacto ? 8 : 16,
                    22,
                    compacto ? 12 : 20,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LogoApp(tamano: logo),
                        SizedBox(height: separacion),
                        Text(
                          'Mis gastitos',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                color: ColoresApp.tinta,
                                fontSize: _modoRegistro
                                    ? (compacto ? 28 : 32)
                                    : (compacto ? 32 : 38),
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _modoRegistro
                              ? 'Crea tu rinconcito financiero cute'
                              : 'Tus gastos cuidados con patitas y pastelitos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColoresApp.textoSuave,
                            fontSize: compacto ? 14 : 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          height: _modoRegistro ? 10 : (compacto ? 14 : 22),
                        ),
                        _PanelLogin(
                          modoRegistro: _modoRegistro,
                          correo: _correo,
                          usuario: _usuario,
                          contrasena: _contrasena,
                          confirmarContrasena: _confirmarContrasena,
                          recordarme: _recordarme,
                          mostrarContrasena: _mostrarContrasena,
                          cargando: _cargando,
                          alCambiarRecordarme: (valor) {
                            setState(() => _recordarme = valor);
                          },
                          alAlternarContrasena: () {
                            setState(
                              () => _mostrarContrasena = !_mostrarContrasena,
                            );
                          },
                          alCambiarModo: _cambiarModo,
                          alIngresar: _ingresar,
                          alRegistrar: _registrar,
                          alBiometria: _ingresarConBiometria,
                          alCodigo: _ingresarConCodigo,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _ingresar() async {
    if (_cargando) return;
    final usuario = _usuario.text.trim();
    final clave = _contrasena.text;
    if (usuario.isEmpty || clave.isEmpty) {
      _mostrarMensaje('Completa usuario y contrasena.');
      return;
    }

    final errorUsuario = _validarUsuario(usuario);
    if (errorUsuario != null) {
      _mostrarMensaje(errorUsuario);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _cargando = true);
    final error = await widget.alIngresar(_recordarme, usuario, clave);
    if (mounted) setState(() => _cargando = false);

    if (error != null && mounted) _mostrarMensaje(error);
  }

  Future<void> _registrar() async {
    if (_cargando) return;
    final correo = _correo.text.trim();
    final usuario = _usuario.text.trim();
    final clave = _contrasena.text;
    final confirmacion = _confirmarContrasena.text;

    if (correo.isEmpty || usuario.isEmpty || clave.isEmpty) {
      _mostrarMensaje('Completa todos los datos.');
      return;
    }

    if (!_correoValido(correo)) {
      _mostrarMensaje('Escribi un email valido.');
      return;
    }

    final errorUsuario = _validarUsuario(usuario);
    if (errorUsuario != null) {
      _mostrarMensaje(errorUsuario);
      return;
    }

    final errorClave = _validarContrasena(clave);
    if (errorClave != null) {
      _mostrarMensaje(errorClave);
      return;
    }

    if (clave != confirmacion) {
      _mostrarMensaje('Las contrasenas no coinciden.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _cargando = true);
    final error = await widget.alRegistrar(correo, usuario, clave);
    if (mounted) setState(() => _cargando = false);

    if (!mounted) return;
    if (error != null) {
      _mostrarMensaje(error);
      return;
    }

    _mostrarMensaje('Cuenta creada. Bienvenido a Mis gastitos.');
  }

  Future<void> _ingresarConBiometria() async {
    final ok = await widget.alUsarBiometria();
    if (!ok && mounted) {
      _mostrarMensaje(
        'Activa la biometria desde Configuracion y deja una sesion abierta.',
      );
    }
  }

  Future<void> _ingresarConCodigo() async {
    final usuario = _usuario.text.trim();
    if (usuario.isEmpty) {
      _mostrarMensaje('Escribi tu usuario antes de usar el codigo.');
      return;
    }

    final codigo = await _pedirAccesoRapido(
      titulo: 'Codigo rapido',
      pista: '4 digitos',
      icono: Icons.pin_outlined,
      maximo: 4,
    );
    if (codigo == null) return;
    final ok = await widget.alUsarCodigo(usuario, codigo);
    if (!ok && mounted) _mostrarMensaje('Codigo incorrecto o no configurado.');
  }

  void _cambiarModo(bool registro) {
    if (_cargando) return;
    setState(() {
      _modoRegistro = registro;
      _confirmarContrasena.clear();
    });
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<String?> _pedirAccesoRapido({
    required String titulo,
    required String pista,
    required IconData icono,
    required int maximo,
  }) async {
    final controlador = TextEditingController();
    final resultado = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: TextField(
          controller: controlador,
          keyboardType: TextInputType.number,
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
            child: const Text('Entrar'),
          ),
        ],
      ),
    );
    return resultado;
  }

  bool _correoValido(String correo) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(correo.trim());
  }

  String? _validarUsuario(String usuario) {
    final limpio = usuario.trim();
    if (limpio.length < 3) {
      return 'Tu usuario debe tener al menos 3 caracteres.';
    }
    if (limpio.length > 24) return 'Tu usuario no puede pasar 24 caracteres.';
    if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(limpio)) {
      return 'Usa solo letras, numeros, punto y guion bajo.';
    }
    if (limpio.startsWith('.') || limpio.endsWith('.')) {
      return 'El usuario no puede empezar ni terminar con punto.';
    }
    if (limpio.contains('..')) {
      return 'El usuario no puede tener dos puntos seguidos.';
    }
    return null;
  }

  String? _validarContrasena(String clave) {
    if (clave.length < 8) return 'La contrasena necesita minimo 8 caracteres.';
    if (!RegExp('[A-Za-z]').hasMatch(clave) || !RegExp(r'\d').hasMatch(clave)) {
      return 'Usa letras y numeros en tu contrasena.';
    }
    return null;
  }
}

class _PanelLogin extends StatelessWidget {
  const _PanelLogin({
    required this.modoRegistro,
    required this.correo,
    required this.usuario,
    required this.contrasena,
    required this.confirmarContrasena,
    required this.recordarme,
    required this.mostrarContrasena,
    required this.cargando,
    required this.alCambiarRecordarme,
    required this.alAlternarContrasena,
    required this.alCambiarModo,
    required this.alIngresar,
    required this.alRegistrar,
    required this.alBiometria,
    required this.alCodigo,
  });

  final bool modoRegistro;
  final TextEditingController correo;
  final TextEditingController usuario;
  final TextEditingController contrasena;
  final TextEditingController confirmarContrasena;
  final bool recordarme;
  final bool mostrarContrasena;
  final bool cargando;
  final ValueChanged<bool> alCambiarRecordarme;
  final VoidCallback alAlternarContrasena;
  final ValueChanged<bool> alCambiarModo;
  final VoidCallback alIngresar;
  final VoidCallback alRegistrar;
  final VoidCallback alBiometria;
  final VoidCallback alCodigo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(modoRegistro ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: ColoresApp.linea),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SelectorModo(
            modoRegistro: modoRegistro,
            alCambiarModo: alCambiarModo,
          ),
          const SizedBox(height: 16),
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 160),
              opacity: 1,
              child: Column(
                children: [
                  if (modoRegistro) ...[
                    CampoSuave(
                      controlador: correo,
                      etiqueta: 'Gmail',
                      pista: 'tuusuario@gmail.com',
                      icono: Icons.mail_outline,
                      teclado: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      activado: !cargando,
                    ),
                    const SizedBox(height: 14),
                  ],
                  CampoSuave(
                    controlador: usuario,
                    etiqueta: 'Usuario',
                    pista: 'Tu usuario',
                    icono: Icons.person_outline,
                    teclado: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    inputFormatters: const [_FormatoUsuarioInput()],
                    activado: !cargando,
                  ),
                  const SizedBox(height: 14),
                  CampoSuave(
                    controlador: contrasena,
                    etiqueta: 'Contrasena',
                    pista: modoRegistro
                        ? 'Minimo 6 caracteres'
                        : 'Tu contrasena',
                    icono: Icons.lock_outline,
                    teclado: TextInputType.visiblePassword,
                    textInputAction: modoRegistro
                        ? TextInputAction.next
                        : TextInputAction.done,
                    autofillHints: [
                      modoRegistro
                          ? AutofillHints.newPassword
                          : AutofillHints.password,
                    ],
                    activado: !cargando,
                    esSecreto: !mostrarContrasena,
                    alEnviar: (_) {
                      if (!modoRegistro) alIngresar();
                    },
                    accion: IconButton(
                      tooltip: mostrarContrasena
                          ? 'Ocultar contrasena'
                          : 'Mostrar contrasena',
                      onPressed: alAlternarContrasena,
                      icon: Icon(
                        mostrarContrasena
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColoresApp.verde,
                      ),
                    ),
                  ),
                  if (modoRegistro) ...[
                    const SizedBox(height: 14),
                    CampoSuave(
                      controlador: confirmarContrasena,
                      etiqueta: 'Confirmar contrasena',
                      pista: 'Repeti tu contrasena',
                      icono: Icons.verified_user_outlined,
                      teclado: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      activado: !cargando,
                      esSecreto: !mostrarContrasena,
                      alEnviar: (_) => alRegistrar(),
                    ),
                    const SizedBox(height: 8),
                    const _AyudaRegistro(),
                  ],
                ],
              ),
            ),
          ),
          if (!modoRegistro) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: recordarme,
                  activeColor: ColoresApp.verde,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onChanged: cargando
                      ? null
                      : (valor) => alCambiarRecordarme(valor ?? false),
                ),
                const Expanded(
                  child: Text(
                    'Recordarme en este telefono',
                    style: TextStyle(
                      color: ColoresApp.tinta,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: cargando
                  ? null
                  : modoRegistro
                  ? alRegistrar
                  : alIngresar,
              icon: cargando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(modoRegistro ? Icons.favorite : Icons.pets),
              label: Text(modoRegistro ? 'Crear cuenta' : 'Entrar'),
            ),
          ),
          if (!modoRegistro) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: cargando ? null : alBiometria,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Entrar con biometria'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColoresApp.verdeOscuro,
                  side: const BorderSide(color: ColoresApp.linea),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: cargando ? null : alCodigo,
                icon: const Icon(Icons.pin_outlined),
                label: const Text('Entrar con codigo'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AyudaRegistro extends StatelessWidget {
  const _AyudaRegistro();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'El usuario es para entrar. El Gmail queda para tu cuenta y recuperacion.',
        style: TextStyle(
          color: ColoresApp.textoSuave,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FormatoUsuarioInput extends TextInputFormatter {
  const _FormatoUsuarioInput();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final texto = newValue.text.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9._]'),
      '',
    );
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

class _SelectorModo extends StatelessWidget {
  const _SelectorModo({
    required this.modoRegistro,
    required this.alCambiarModo,
  });

  final bool modoRegistro;
  final ValueChanged<bool> alCambiarModo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColoresApp.verdeSuave.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _OpcionModo(
            texto: 'Entrar',
            activa: !modoRegistro,
            alTocar: () => alCambiarModo(false),
          ),
          _OpcionModo(
            texto: 'Registrarme',
            activa: modoRegistro,
            alTocar: () => alCambiarModo(true),
          ),
        ],
      ),
    );
  }
}

class _OpcionModo extends StatelessWidget {
  const _OpcionModo({
    required this.texto,
    required this.activa,
    required this.alTocar,
  });

  final String texto;
  final bool activa;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: activa ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: activa
              ? const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: alTocar,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: activa ? ColoresApp.verdeOscuro : ColoresApp.textoSuave,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
