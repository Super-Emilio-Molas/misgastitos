class UsuarioPrueba {
  static const usuario = 'luz';
  static const contrasena = '123456';

  static bool validar(String usuarioIngresado, String contrasenaIngresada) {
    return usuarioIngresado.trim().toLowerCase() == usuario &&
        contrasenaIngresada.trim() == contrasena;
  }
}
