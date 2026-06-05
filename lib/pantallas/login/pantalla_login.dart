import 'package:flutter/material.dart';

import '../../componentes/campo_suave.dart';
import '../../componentes/fondo_huellitas.dart';
import '../../componentes/logo_app.dart';
import '../../datos/usuario_prueba.dart';
import '../../tema/colores_app.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({
    super.key,
    required this.usuarioInicial,
    required this.recordarmeInicial,
    required this.alIngresar,
    required this.alUsarBiometria,
  });

  final String usuarioInicial;
  final bool recordarmeInicial;
  final Future<void> Function(bool recordarme, String usuario) alIngresar;
  final Future<bool> Function() alUsarBiometria;

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  late final TextEditingController _usuario;
  final _codigo = TextEditingController();
  late bool _recordarme;
  bool _mostrarCodigo = false;
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
    _codigo.dispose();
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
              final compacto = alto < 740 || ancho < 370;
              final logo = compacto ? 116.0 : 148.0;
              final separacion = compacto ? 12.0 : 18.0;

              return Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    24,
                    compacto ? 10 : 18,
                    24,
                    compacto ? 14 : 22,
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
                                fontSize: compacto ? 34 : 40,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tus gastos cuidados con patitas y pastelitos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColoresApp.textoSuave,
                            fontSize: compacto ? 15 : 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: compacto ? 18 : 28),
                        _PanelLogin(
                          usuario: _usuario,
                          codigo: _codigo,
                          recordarme: _recordarme,
                          mostrarCodigo: _mostrarCodigo,
                          cargando: _cargando,
                          alCambiarRecordarme: (valor) {
                            setState(() => _recordarme = valor);
                          },
                          alAlternarCodigo: () {
                            setState(() => _mostrarCodigo = !_mostrarCodigo);
                          },
                          alIngresar: _ingresar,
                          alBiometria: _ingresarConBiometria,
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
    setState(() => _cargando = true);

    final valido = UsuarioPrueba.validar(_usuario.text, _codigo.text);
    if (!valido) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos.')),
      );
      return;
    }

    await widget.alIngresar(_recordarme, _usuario.text);
    if (mounted) setState(() => _cargando = false);
  }

  Future<void> _ingresarConBiometria() async {
    final ok = await widget.alUsarBiometria();
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activá la biometria desde Configuracion primero.'),
        ),
      );
    }
  }
}

class _PanelLogin extends StatelessWidget {
  const _PanelLogin({
    required this.usuario,
    required this.codigo,
    required this.recordarme,
    required this.mostrarCodigo,
    required this.cargando,
    required this.alCambiarRecordarme,
    required this.alAlternarCodigo,
    required this.alIngresar,
    required this.alBiometria,
  });

  final TextEditingController usuario;
  final TextEditingController codigo;
  final bool recordarme;
  final bool mostrarCodigo;
  final bool cargando;
  final ValueChanged<bool> alCambiarRecordarme;
  final VoidCallback alAlternarCodigo;
  final VoidCallback alIngresar;
  final VoidCallback alBiometria;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
          CampoSuave(
            controlador: usuario,
            etiqueta: 'Usuario',
            pista: 'Tu usuario',
            icono: Icons.person_outline,
          ),
          const SizedBox(height: 14),
          CampoSuave(
            controlador: codigo,
            etiqueta: 'Contraseña',
            pista: 'Tu contraseña',
            icono: Icons.lock_outline,
            teclado: TextInputType.number,
            esSecreto: !mostrarCodigo,
            accion: IconButton(
              tooltip: mostrarCodigo
                  ? 'Ocultar contraseña'
                  : 'Mostrar contraseña',
              onPressed: alAlternarCodigo,
              icon: Icon(
                mostrarCodigo
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: ColoresApp.verde,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: recordarme,
                activeColor: ColoresApp.verde,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged: (valor) => alCambiarRecordarme(valor ?? false),
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
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: cargando ? null : alIngresar,
              icon: cargando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.pets),
              label: const Text('Entrar'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: alBiometria,
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
        ],
      ),
    );
  }
}
