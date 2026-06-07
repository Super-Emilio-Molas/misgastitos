import 'package:cloud_firestore/cloud_firestore.dart';

import '../modelos/movimiento.dart';

abstract class RepositorioMovimientos {
  Stream<List<Movimiento>> escucharMovimientos(String uid);

  Future<void> agregarMovimiento({
    required String uid,
    required Movimiento movimiento,
  });
}

class RepositorioMovimientosFirebase implements RepositorioMovimientos {
  RepositorioMovimientosFirebase({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<Movimiento>> escucharMovimientos(String uid) {
    return _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('movimientos')
        .orderBy('fecha', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Movimiento.desdeMapa(_normalizarFecha(doc.data())))
              .toList(),
        );
  }

  @override
  Future<void> agregarMovimiento({
    required String uid,
    required Movimiento movimiento,
  }) async {
    await _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('movimientos')
        .add({...movimiento.aMapa(), 'creadoEn': FieldValue.serverTimestamp()});
  }

  Map<String, dynamic> _normalizarFecha(Map<String, dynamic> datos) {
    final fecha = datos['fecha'];
    if (fecha is Timestamp) {
      return {...datos, 'fecha': fecha.toDate()};
    }
    return datos;
  }
}
