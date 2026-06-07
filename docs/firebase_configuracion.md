# Configuracion de Firebase

Este proyecto no incluye los archivos locales de Firebase para no publicar datos
del proyecto original.

Para conectar tu propia base:

1. Crea un proyecto en Firebase.
2. Activa Authentication con correo y contrasena.
3. Crea Cloud Firestore.
4. Instala FlutterFire CLI:

```powershell
dart pub global activate flutterfire_cli
```

5. Desde la raiz del proyecto ejecuta:

```powershell
flutterfire configure --platforms=android --project=TU_PROJECT_ID
```

Ese comando genera:

- `android/app/google-services.json`
- `lib/firebase_options.dart`
- `firebase.json`

La app usa estas colecciones:

- `usuarios/{uid}`
- `usuarios_alias/{usuario}`
- `usuarios/{uid}/movimientos`

Trabajo realizado por Emilio Molas con asistencia de Codex.
