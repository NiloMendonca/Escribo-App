import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BancoDeDados {

  var db;

  connectDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "escribo_db.db");

    Database db;
    return await openDatabase(path, readOnly: false);
  }

  Future<List> getFavoritos() async {
    if (db == null)
      db = await connectDatabase();

    var lista = await db.rawQuery('SELECT * FROM Favorito');

    if (lista != null)
      return lista;
    return [];
  }

  void deletarFavorito(lista, index, tipo) async {
    if(db == null)
      db = await connectDatabase();

    await db
          .rawDelete(
          'DELETE FROM Favorito WHERE nome = "${getNome(lista, index, tipo)}"');
      List<Map> list = await db.rawQuery('SELECT * FROM Favorito');
  }

  void adicionarFavorito(lista, int index, int tipo) async {
    if (db == null)
      db = await connectDatabase();

    await db.execute(
        "CREATE TABLE IF NOT EXISTS Favorito (nome TEXT PRIMARY KEY, tipo INTEGER)");

    var a = await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Favorito (nome, tipo) VALUES("${getNome(
              lista, index, tipo)}", ${tipo})');
    });
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
}