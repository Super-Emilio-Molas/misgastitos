String formatoGuaranies(int valor) {
  final signo = valor < 0 ? '-' : '';
  final digitos = valor.abs().toString();
  final buffer = StringBuffer();

  for (var indice = 0; indice < digitos.length; indice++) {
    final desdeFinal = digitos.length - indice;
    buffer.write(digitos[indice]);
    if (desdeFinal > 1 && desdeFinal % 3 == 1) buffer.write('.');
  }

  return '${signo}Gs. $buffer';
}
