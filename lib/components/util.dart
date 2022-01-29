import 'package:flutter/material.dart';

class Util {
  int verificaTamanhoVetor(vetor){
    if(vetor.length>0)
      return vetor.length;
    else
      return 0;
  }

  String getNome(lista, int index, int tipo){
    switch(tipo) {
      case 1:
        return lista[index]['title'].toString();
      case 2:
        return lista[index]['name'].toString();
      default:
        return lista[index]['nome'].toString();
    }
  }

  getTipo(lista, index) {
    if (lista[index]['tipo'] == 1)
      return Colors.red;
    return Colors.green;
  }
}