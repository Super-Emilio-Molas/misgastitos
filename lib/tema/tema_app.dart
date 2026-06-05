import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colores_app.dart';

ThemeData crearTemaApp() {
  final textoBase = GoogleFonts.nunitoTextTheme();

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ColoresApp.fondo,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColoresApp.verde,
      primary: ColoresApp.verde,
      secondary: ColoresApp.durazno,
      surface: Colors.white,
    ),
    textTheme: textoBase.copyWith(
      headlineLarge: GoogleFonts.nunito(fontWeight: FontWeight.w900),
      headlineMedium: GoogleFonts.nunito(fontWeight: FontWeight.w900),
      headlineSmall: GoogleFonts.nunito(fontWeight: FontWeight.w900),
      titleLarge: GoogleFonts.nunito(fontWeight: FontWeight.w900),
      titleMedium: GoogleFonts.nunito(fontWeight: FontWeight.w800),
      bodyLarge: GoogleFonts.nunito(fontWeight: FontWeight.w700),
      bodyMedium: GoogleFonts.nunito(fontWeight: FontWeight.w600),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ColoresApp.verde,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColoresApp.verdeOscuro,
        textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w900),
      ),
    ),
  );
}
