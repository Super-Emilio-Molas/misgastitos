# Seguridad de datos para Google Play

Resumen sugerido para completar la seccion "Seguridad de los datos" en Google
Play Console.

## Datos recopilados

- Informacion personal: correo electronico y usuario.
- Informacion financiera: gastos, ingresos, montos, categorias, fechas y
  descripciones ingresadas por el usuario.
- Identificadores: UID de Firebase Authentication.

## Finalidad

- Funcionalidad de la app.
- Administracion de cuenta.
- Seguridad y prevencion de acceso no autorizado.

## Compartido con terceros

Los datos se procesan con Firebase, usado como proveedor de autenticacion y base
de datos. No se venden datos ni se comparten con publicidad de terceros.

## Cifrado y seguridad

- Los datos se transmiten usando conexiones seguras de Firebase.
- Los accesos rapidos locales se guardan con almacenamiento seguro del
  dispositivo.
- La biometria se valida desde el sistema Android; la app no guarda huellas ni
  datos biometricos.

## Eliminacion de datos

El usuario puede solicitar eliminacion de datos contactando al desarrollador.

