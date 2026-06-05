import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasSesion {
  static const _claveRecordarme = 'recordarme';
  static const _claveUsuario = 'usuario_recordado';
  static const _claveBiometria = 'biometria_activada';

  Future<bool> obtenerRecordarme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveRecordarme) ?? false;
  }

  Future<String> obtenerUsuarioRecordado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveUsuario) ?? '';
  }

  Future<void> guardarRecordarme({
    required bool activo,
    required String usuario,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_claveRecordarme, activo);
    if (activo) {
      await prefs.setString(_claveUsuario, usuario.trim());
    } else {
      await prefs.remove(_claveUsuario);
    }
  }

  Future<bool> obtenerBiometriaActiva() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveBiometria) ?? false;
  }

  Future<void> guardarBiometriaActiva(bool activo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_claveBiometria, activo);
  }
}
