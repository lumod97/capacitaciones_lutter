  Future<String> descifradoSanJuan(String cadenaADescifrar) async {
    // PASO 0: CREACION DE VARIABLES
    int maximoIndiceCadena = cadenaADescifrar.length - 3;
    List<int> aCadena = List.filled(maximoIndiceCadena + 1, 0);
    int sumaA = 0, sumaB = 0;
    int claveA, claveB;
    bool claveAEsPar;
    int desplazamientoADerecha;
    String cadenaIzquierda = "";
    String cadenaDerecha = "";
    String cadenaFinal = "";

    // PASO 1: OBTENER CLAVES A, B Y LA CADENA SEPARADA
    claveA = int.parse(cadenaADescifrar[maximoIndiceCadena + 1]);
    claveB = int.parse(cadenaADescifrar[maximoIndiceCadena + 2]);
    cadenaFinal = cadenaADescifrar.substring(0, maximoIndiceCadena + 1);

    // PASO 2: VALIDAR SUMA B
    for (int i = 0; i < cadenaFinal.length; i++) {
      sumaB += int.parse(cadenaFinal[i]);
    }
    if (claveB != sumaB % 10) {
      throw Exception("Código no coincide con estructura San Juan.");
    }

    // PASO 3: DESPLAZAR
    desplazamientoADerecha = maximoIndiceCadena - ((maximoIndiceCadena < claveA) ? claveA - maximoIndiceCadena : claveA);
    cadenaIzquierda = "";
    cadenaDerecha = "";

    for (int i = 0; i <= maximoIndiceCadena; i++) {
      if (i <= desplazamientoADerecha) {
        cadenaIzquierda += cadenaFinal[i];
      } else {
        cadenaDerecha += cadenaFinal[i];
      }
    }

    cadenaFinal = cadenaDerecha + cadenaIzquierda;
    print(cadenaFinal);

    // PASO 4: INDIZAR CADENA EN ARRAY DE ENTEROS
    for (int i = 0; i <= maximoIndiceCadena; i++) {
      aCadena[i] = int.parse(cadenaFinal[i]);
    }

    // PASO 5: DETERMINAR SI LA CLAVE A ES PAR
    claveAEsPar = claveA % 2 == 0;

    // PASO 6: HALLAR EL COMPLEMENTO A DECENA DE CADA DIGITO Y REEMPLAZAR LOS DIGITOS ORIGINALES POR LOS COMPLEMENTOS
    for (int i = 0; i <= maximoIndiceCadena; i++) {
      if (aCadena[i] != 0) {
        aCadena[i] = 10 - aCadena[i];
      }
    }

    // PASO 7: OPERAR SOBRE LOS DIGITOS PARES SI LA CLAVE A ES PAR O VICEVERSA
    for (int i = 1; i <= maximoIndiceCadena; i++) {
      if ((claveAEsPar && i % 2 == 0) || (!claveAEsPar && i % 2 != 0)) {
        if (aCadena[i] < claveA) {
          aCadena[i] += 10;
        }
        aCadena[i] -= claveA;
      }
    }

    // PASO 8: VALIDAR CLAVE A CON SUMA A
    for (int i = 0; i < aCadena.length; i++) {
      sumaA += aCadena[i];
    }

    if (claveA != sumaA % 10) {
      throw Exception("Código no coincide con estructura San Juan.");
    }

    // PASO 9: CONVERTIR RESULTADO A CADENA
    StringBuffer resultado = StringBuffer();
    for (int i = 0; i < aCadena.length; i++) {
      resultado.write(aCadena[i]);
    }

    return resultado.toString();
  }