import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../modelos/usuario_sesion.dart';

abstract class ServicioAutenticacion {
  Stream<UsuarioSesion?> cambiosSesion();

  UsuarioSesion? get usuarioActual;

  Future<UsuarioSesion> ingresar({
    required String usuario,
    required String clave,
  });

  Future<UsuarioSesion> registrar({
    required String correo,
    required String usuario,
    required String clave,
  });

  Future<void> cerrarSesion();
}

class ServicioAutenticacionFirebase implements ServicioAutenticacion {
  ServicioAutenticacionFirebase({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Stream<UsuarioSesion?> cambiosSesion() {
    return _auth.authStateChanges().asyncMap(_crearUsuarioSesion);
  }

  @override
  UsuarioSesion? get usuarioActual =>
      _crearUsuarioSesionBasico(_auth.currentUser);

  @override
  Future<UsuarioSesion> ingresar({
    required String usuario,
    required String clave,
  }) async {
    _validarUsuario(_normalizarUsuario(usuario));
    final correo = await _resolverCorreo(usuario);
    final credencial = await _auth.signInWithEmailAndPassword(
      email: correo,
      password: clave,
    );
    final sesion = await _crearUsuarioSesion(credencial.user);
    if (sesion == null) {
      throw FirebaseAuthException(
        code: 'sin-usuario',
        message: 'No se pudo abrir la sesion.',
      );
    }
    return sesion;
  }

  @override
  Future<UsuarioSesion> registrar({
    required String correo,
    required String usuario,
    required String clave,
  }) async {
    final alias = _normalizarUsuario(usuario);
    final correoLimpio = correo.trim().toLowerCase();
    _validarUsuario(alias);

    final aliasRef = _firestore.collection('usuarios_alias').doc(alias);
    await _reservarAlias(aliasRef, alias, correoLimpio);

    User? userCreado;
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: correoLimpio,
        password: clave,
      );
      final user = credencial.user;
      userCreado = user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'sin-usuario',
          message: 'No se pudo crear tu cuenta.',
        );
      }

      await user.updateDisplayName(alias);
      await _guardarPerfil(
        uid: user.uid,
        nombre: alias,
        correo: correoLimpio,
        usuario: alias,
        aliasRef: aliasRef,
      );

      return UsuarioSesion(
        uid: user.uid,
        usuario: alias,
        nombre: _capitalizar(alias),
        correo: correoLimpio,
      );
    } catch (error) {
      await _liberarAliasReservado(aliasRef, alias);
      await userCreado?.delete();
      rethrow;
    }
  }

  @override
  Future<void> cerrarSesion() => _auth.signOut();

  Future<void> _reservarAlias(
    DocumentReference<Map<String, dynamic>> aliasRef,
    String alias,
    String correo,
  ) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final existente = await transaction.get(aliasRef);
        if (existente.exists) {
          throw FirebaseAuthException(
            code: 'usuario-en-uso',
            message: 'Ese usuario ya esta usado.',
          );
        }
        transaction.set(aliasRef, {
          'usuario': alias,
          'correo': correo,
          'estado': 'reservado',
          'creadoEn': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseAuthException {
      rethrow;
    } on FirebaseException catch (error) {
      if (error.code == 'already-exists' || error.code == 'aborted') {
        throw FirebaseAuthException(
          code: 'usuario-en-uso',
          message: 'Ese usuario ya esta usado.',
        );
      }
      rethrow;
    }
  }

  Future<void> _liberarAliasReservado(
    DocumentReference<Map<String, dynamic>> aliasRef,
    String alias,
  ) async {
    try {
      final doc = await aliasRef.get();
      final datos = doc.data();
      if (datos?['estado'] == 'reservado' && datos?['usuario'] == alias) {
        await aliasRef.delete();
      }
    } catch (_) {
      // La limpieza es defensiva; el error original es mas importante.
    }
  }

  Future<String> _resolverCorreo(String usuario) async {
    final alias = _normalizarUsuario(usuario);
    final documento = await _firestore
        .collection('usuarios_alias')
        .doc(alias)
        .get();
    final datos = documento.data();
    final correo = datos?['correo'] ?? datos?['email'];

    if (correo is String && correo.trim().contains('@')) {
      return correo.trim();
    }

    throw FirebaseAuthException(
      code: 'usuario-no-encontrado',
      message: 'No encontramos ese usuario.',
    );
  }

  Future<void> _guardarPerfil({
    required String uid,
    required String nombre,
    required String correo,
    required String usuario,
    required DocumentReference<Map<String, dynamic>> aliasRef,
  }) async {
    final usuarioRef = _firestore.collection('usuarios').doc(uid);
    final ahora = FieldValue.serverTimestamp();
    final batch = _firestore.batch();

    batch.set(usuarioRef, {
      'uid': uid,
      'nombre': nombre,
      'correo': correo,
      'usuario': usuario,
      'creadoEn': ahora,
      'actualizadoEn': ahora,
    });
    batch.set(aliasRef, {
      'uid': uid,
      'correo': correo,
      'usuario': usuario,
      'estado': 'activo',
      'creadoEn': ahora,
      'actualizadoEn': ahora,
    });

    await batch.commit();
  }

  String _normalizarUsuario(String usuario) {
    return usuario.trim().toLowerCase();
  }

  void _validarUsuario(String usuario) {
    if (usuario.length < 3) {
      throw FirebaseAuthException(
        code: 'usuario-corto',
        message: 'El usuario debe tener al menos 3 caracteres.',
      );
    }
    if (usuario.length > 24) {
      throw FirebaseAuthException(
        code: 'usuario-largo',
        message: 'El usuario no puede pasar 24 caracteres.',
      );
    }

    final permitido = RegExp(r'^[a-z0-9._]+$');
    if (!permitido.hasMatch(usuario)) {
      throw FirebaseAuthException(
        code: 'usuario-invalido',
        message:
            'El usuario solo puede usar letras, numeros, punto y guion bajo.',
      );
    }

    if (usuario.startsWith('.') ||
        usuario.endsWith('.') ||
        usuario.contains('..')) {
      throw FirebaseAuthException(
        code: 'usuario-invalido',
        message: 'El usuario no puede empezar o terminar con punto.',
      );
    }
  }

  Future<UsuarioSesion?> _crearUsuarioSesion(User? user) async {
    if (user == null) return null;
    try {
      final doc = await _firestore.collection('usuarios').doc(user.uid).get();
      final datos = doc.data();
      final nombre = datos?['usuario'] ?? datos?['nombre'];
      if (nombre is String && nombre.trim().isNotEmpty) {
        final usuario =
            (datos?['usuario'] as String?)?.trim().isNotEmpty == true
            ? datos!['usuario'] as String
            : nombre;
        return UsuarioSesion(
          uid: user.uid,
          usuario: _normalizarUsuario(usuario),
          nombre: _capitalizar(nombre),
          correo: user.email ?? '',
        );
      }
    } catch (_) {
      // Si el perfil aun no esta disponible, usamos los datos de Auth.
    }

    return _crearUsuarioSesionBasico(user);
  }

  UsuarioSesion? _crearUsuarioSesionBasico(User? user) {
    if (user == null) return null;
    final correo = user.email ?? '';
    final nombreBase = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : correo.split('@').first;

    return UsuarioSesion(
      uid: user.uid,
      usuario: _normalizarUsuario(nombreBase),
      nombre: _capitalizar(nombreBase),
      correo: correo,
    );
  }

  String _capitalizar(String texto) {
    final limpio = texto.trim();
    if (limpio.isEmpty) return 'Usuario';
    return limpio[0].toUpperCase() + limpio.substring(1);
  }
}

String mensajeErrorAutenticacion(Object error) {
  if (error is FirebaseException && error is! FirebaseAuthException) {
    return switch (error.code) {
      'permission-denied' =>
        'No pudimos guardar tu perfil. Revisa las reglas de la base de datos.',
      'unavailable' =>
        'El servicio no esta disponible ahora. Intenta de nuevo.',
      _ => error.message ?? 'No pudimos iniciar sesion. Intenta de nuevo.',
    };
  }

  if (error is! FirebaseAuthException) {
    return 'No pudimos iniciar sesion. Intenta de nuevo.';
  }

  return switch (error.code) {
    'invalid-email' => 'El correo no tiene un formato valido.',
    'email-already-in-use' => 'Ese correo ya tiene una cuenta.',
    'weak-password' => 'La contrasena necesita al menos 6 caracteres.',
    'usuario-corto' => 'Tu usuario debe tener al menos 3 caracteres.',
    'usuario-largo' => 'Tu usuario no puede pasar 24 caracteres.',
    'usuario-invalido' =>
      'Tu usuario solo puede tener letras, numeros, punto y guion bajo.',
    'usuario-en-uso' => 'Ese usuario ya esta usado. Proba con otro.',
    'user-not-found' || 'usuario-no-encontrado' =>
      'No encontramos ese usuario. Registrate primero o revisa como lo escribiste.',
    'wrong-password' ||
    'invalid-credential' => 'Usuario o contrasena incorrectos.',
    'too-many-requests' =>
      'Demasiados intentos. Espera un poco y volve a probar.',
    'network-request-failed' => 'Revisa tu conexion a internet.',
    'permission-denied' =>
      'No pudimos guardar tu perfil. Revisa las reglas de la base de datos.',
    _ => error.message ?? 'No pudimos iniciar sesion. Intenta de nuevo.',
  };
}
