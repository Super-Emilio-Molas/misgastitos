class UsuarioPrueba {
  static const nombreVisible = 'Luz Valeria';
  static const usuario = 'luz';
  static const codigo = '123456';

  static bool validar(String usuarioIngresado, String codigoIngresado) {
    return usuarioIngresado.trim().toLowerCase() == usuario &&
        codigoIngresado.trim() == codigo;
  }
}
