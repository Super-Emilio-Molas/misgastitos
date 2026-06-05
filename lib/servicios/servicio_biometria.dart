import 'package:local_auth/local_auth.dart';

class ServicioBiometria {
  ServicioBiometria({LocalAuthentication? autenticador})
    : _autenticador = autenticador ?? LocalAuthentication();

  final LocalAuthentication _autenticador;

  Future<bool> estaDisponible() async {
    final soportado = await _autenticador.isDeviceSupported();
    final puedeVerificar = await _autenticador.canCheckBiometrics;
    return soportado && puedeVerificar;
  }

  Future<bool> autenticar() async {
    if (!await estaDisponible()) return false;
    return _autenticador.authenticate(
      localizedReason: 'Confirmá que sos vos para entrar a Mis gastitos',
      biometricOnly: true,
      persistAcrossBackgrounding: true,
    );
  }
}
