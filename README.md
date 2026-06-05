# Mis gastitos

App Flutter para llevar gastos, entradas, reportes y presupuestos personales.

## Plataformas objetivo

- Android, optimizada para pantallas tipo Huawei P30.
- Web, para pruebas rápidas desde navegador.

## Funcionalidades incluidas

- Login visual de muestra.
- Dashboard con saldo, resumen mensual y transacciones recientes.
- Alta rápida de gastos y entradas.
- Reportes con entradas, gastos y saldo.
- Presupuestos por categoría.
- Logo/mascota dibujado en Flutter para evitar assets pesados.

## Ejecutar

```bash
flutter pub get
flutter run -d web-server --web-port 8080
```

Para Android:

```bash
flutter run -d android
```

## Builds verificados

```bash
flutter analyze
flutter test
flutter build web
flutter build apk --debug
```

El APK debug queda en:

```text
build/app/outputs/flutter-apk/app-debug.apk
```
