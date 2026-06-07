import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasSesion {
  PreferenciasSesion({FlutterSecureStorage? cajaSegura})
    : _cajaSegura = cajaSegura ?? const FlutterSecureStorage();

  static const _claveRecordarme = 'recordarme';
  static const _claveUsuario = 'usuario_recordado';
  static const _claveBiometria = 'biometria_activada';
  static const _prefijoClaveRapida = 'clave_acceso_rapido';
  static const _prefijoCodigo = 'codigo_rapido';

  final FlutterSecureStorage _cajaSegura;

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

  Future<void> guardarCredencialesRapidas({
    required String usuario,
    required String clave,
  }) async {
    final alias = _normalizarUsuario(usuario);
    await _cajaSegura.write(key: _claveClave(alias), value: clave);
  }

  Future<({String usuario, String clave})?> obtenerCredencialesRapidas({
    required String usuario,
  }) async {
    final alias = _normalizarUsuario(usuario);
    final clave = await _cajaSegura.read(key: _claveClave(alias));
    if (alias.isEmpty || clave == null || clave.isEmpty) {
      return null;
    }
    return (usuario: alias, clave: clave);
  }

  Future<void> guardarCodigoRapido({
    required String usuario,
    required String codigo,
  }) async {
    final alias = _normalizarUsuario(usuario);
    await _cajaSegura.write(key: _claveCodigo(alias), value: codigo);
  }

  Future<String> obtenerCodigoRapido({required String usuario}) async {
    final alias = _normalizarUsuario(usuario);
    return await _cajaSegura.read(key: _claveCodigo(alias)) ?? '';
  }

  String _normalizarUsuario(String usuario) {
    return usuario.trim().toLowerCase();
  }

  String _claveClave(String usuario) {
    return '${_prefijoClaveRapida}_$usuario';
  }

  String _claveCodigo(String usuario) {
    return '${_prefijoCodigo}_$usuario';
  }
}
