import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tema/colores_app.dart';

class CampoSuave extends StatelessWidget {
  const CampoSuave({
    super.key,
    required this.controlador,
    required this.etiqueta,
    required this.pista,
    required this.icono,
    this.esSecreto = false,
    this.accion,
    this.teclado,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.activado = true,
    this.alEnviar,
  });

  final TextEditingController controlador;
  final String etiqueta;
  final String pista;
  final IconData icono;
  final bool esSecreto;
  final Widget? accion;
  final TextInputType? teclado;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool activado;
  final ValueChanged<String>? alEnviar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(
            color: ColoresApp.tinta,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controlador,
          enabled: activado,
          obscureText: esSecreto,
          keyboardType: teclado,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          onSubmitted: alEnviar,
          decoration: InputDecoration(
            hintText: pista,
            hintStyle: const TextStyle(
              color: ColoresApp.textoSuave,
              fontWeight: FontWeight.w700,
            ),
            prefixIcon: Icon(icono, color: ColoresApp.verde),
            suffixIcon: accion,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: ColoresApp.linea),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: ColoresApp.verde, width: 1.7),
            ),
          ),
        ),
      ],
    );
  }
}
