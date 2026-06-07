import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'aplicacion/mis_gastitos_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MisGastitosApp());
}
