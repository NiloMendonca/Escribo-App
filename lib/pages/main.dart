import 'package:flutter/material.dart';
import 'dart:async';
import '../components/menu.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../services/http.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Escribo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  connectDatabase() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "escribo_db.db");

    Database db;
    return await openDatabase(path, readOnly: false);
  }

  var db;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 25),
              Menu().menu(context, true),
              DefaultTabController(
                  length: 3,
                  initialIndex: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(text: 'Filmes'),
                            Tab(text: 'Personagens'),
                            Tab(text: 'Favoritos'),
                          ],
                        ),
                      ),
                      Container(
                        height: 400, //height of TabBarView
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                        ),
                        child: TabBarView(children: <Widget>[
                          Container(
                            child: FutureBuilder(
                                future: getDados(),
                                builder: (context, snapshotFavoritos) {
                                  switch (snapshotFavoritos.connectionState) {
                                    case (ConnectionState.none):
                                    case (ConnectionState.waiting):
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    default:
                                      if (snapshotFavoritos.hasData) {
                                        var listaFavoritos = snapshotFavoritos.data;
                                        print(listaFavoritos);
                                        return FutureBuilder(
                                            future: HttpService().getDados(getEndpoint(1), []),
                                            builder: (context, snapshot) {
                                              switch (snapshot.connectionState) {
                                                case (ConnectionState.none):
                                                case (ConnectionState.waiting):
                                                  return Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: CircularProgressIndicator(),
                                                    ),
                                                  );
                                                default:
                                                  if (snapshot.hasData) {
                                                    var lista = snapshot.data;
                                                    return Container(
                                                      child: ListView.builder(
                                                        itemCount: verificaTamanhoVetor(lista),
                                                        itemBuilder: (context, index) {
                                                          return Column(children: <Widget>[
                                                            ListTile(
                                                              title: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    RichText(
                                                                      text: TextSpan(
                                                                        text: getNome(
                                                                            lista, index, 1),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                        icon: verificaIcone(
                                                                            lista, index, 1,
                                                                            listaFavoritos),
                                                                        color: Colors.black,
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            adicionarFavorito(
                                                                                lista, index, 1);
                                                                          });
                                                                        }
                                                                    ),
                                                                  ]
                                                              ),
                                                              contentPadding: EdgeInsets.symmetric(
                                                                  vertical: 0.0, horizontal: 16.0),
                                                              horizontalTitleGap: 0.0,
                                                              minVerticalPadding: 5.0,
                                                            ),
                                                            Divider(color: Colors.black26, height: 3.0),
                                                          ]);
                                                        },
                                                      ),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  }
                                              }
                                            }
                                        );
                                      }
                                      else {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                  }
                                }
                            ),
                          ),
                          Container(
                            child: FutureBuilder(
                                future: getDados(),
                                builder: (context, snapshotFavoritos) {
                                  switch (snapshotFavoritos.connectionState) {
                                    case (ConnectionState.none):
                                    case (ConnectionState.waiting):
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    default:
                                      if (snapshotFavoritos.hasData) {
                                        var listaFavoritos = snapshotFavoritos.data;
                                        print(listaFavoritos);
                                        return FutureBuilder(
                                            future: HttpService().getDados(getEndpoint(2), []),
                                            builder: (context, snapshot) {
                                              switch (snapshot.connectionState) {
                                                case (ConnectionState.none):
                                                case (ConnectionState.waiting):
                                                  return Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: CircularProgressIndicator(),
                                                    ),
                                                  );
                                                default:
                                                  if (snapshot.hasData) {
                                                    var lista = snapshot.data;
                                                    return Container(
                                                      child: ListView.builder(
                                                        itemCount: verificaTamanhoVetor(lista),
                                                        itemBuilder: (context, index) {
                                                          return Column(children: <Widget>[
                                                            ListTile(
                                                              title: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    RichText(
                                                                      text: TextSpan(
                                                                        text: getNome(
                                                                            lista, index, 2),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                        icon: verificaIcone(
                                                                            lista, index, 2,
                                                                            listaFavoritos),
                                                                        color: Colors.black,
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            adicionarFavorito(
                                                                                lista, index, 2);
                                                                          });
                                                                        }
                                                                    ),
                                                                  ]
                                                              ),
                                                              contentPadding: EdgeInsets.symmetric(
                                                                  vertical: 0.0, horizontal: 16.0),
                                                              horizontalTitleGap: 0.0,
                                                              minVerticalPadding: 5.0,
                                                            ),
                                                            Divider(color: Colors.black26, height: 3.0),
                                                          ]);
                                                        },
                                                      ),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  }
                                              }
                                            }
                                        );
                                      }
                                      else {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                  }
                                }
                            ),
                          ),
                          Container(
                            child: Center(
                              child: FutureBuilder(
                                  future: getDados(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case (ConnectionState.none):
                                      case (ConnectionState.waiting):
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      default:
                                        if (snapshot.hasData) {
                                          var lista = snapshot.data;
                                          if(verificaTamanhoVetor(lista) > 0) {
                                            return Container(
                                              child: ListView.builder(
                                                itemCount: verificaTamanhoVetor(
                                                    lista),
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                      children: <Widget>[
                                                        getBotaoAtualiza(index),
                                                        ListTile(
                                                          title: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                RichText(
                                                                  text: TextSpan(
                                                                    text: getNome(
                                                                        lista,
                                                                        index, 3),
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color: getTipo(
                                                                          lista,
                                                                          index),
                                                                    ),
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .delete),
                                                                    color: getTipo(
                                                  lista,
                                                  index),
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        deletarDado(
                                                                            lista,
                                                                            index);
                                                                      });
                                                                    }
                                                                ),
                                                              ]
                                                          ),
                                                          contentPadding: EdgeInsets
                                                              .symmetric(
                                                              vertical: 0.0,
                                                              horizontal: 16.0),
                                                          horizontalTitleGap: 0.0,
                                                          minVerticalPadding: 5.0,
                                                        ),
                                                        Divider(color: Colors
                                                            .black26,
                                                            height: 3.0),
                                                      ]);
                                                },
                                              ),
                                            );
                                          }
                                          return getBotaoAtualiza(0);
                                        }
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Sem dados'),
                                                getBotaoAtualiza(0)
                                              ]
                                            )
                                          ),
                                        );
                                    }
                                  }
                              ),
                            ),
                          ),
                        ]
                      )
                    )
                  ]
                ),
              ),
          ]
        ),
      ),
    );
  }

  verificaIcone(lista, index, tipo, listaFavoritos) {
    for(int i=0; i<listaFavoritos.length; i++){
      if(tipo == 1) {
        if (listaFavoritos[i]['nome'] == lista[index]['title'])
          return Icon(Icons.favorite);
      }
      else {
        if (listaFavoritos[i]['nome'] == lista[index]['name'])
          return Icon(Icons.favorite);
      }
    }
    return Icon(Icons.favorite_border);
  }

  Widget getBotaoAtualiza(int index){
    if(index == 0) {
      return IconButton(
          icon: Icon(Icons.refresh),
          color: Colors.black,
          onPressed: () {
            setState(() {
              getDados();
            });
          }
      );
    }
    return Padding(
      padding: EdgeInsets.all(0.0),
    );
  }

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

  void deletarDado(lista, index) async {
    if(db == null)
      db = await connectDatabase();
    await db
        .rawDelete('DELETE FROM Favorito WHERE nome = "${getNome(lista, index, 3)}"');
    List<Map> list = await db.rawQuery('SELECT * FROM Favorito');
  }

  Future<List> getDados() async {
    if(db == null)
      db = await connectDatabase();

    var lista = await db.rawQuery('SELECT * FROM Favorito');
    // await db.close();
    if(lista != null)
      return lista;
    return [];
  }

  String getEndpoint(int tipo){
    switch(tipo){
      case 1:
        return 'https://swapi.dev/api/films/';
      default:
        return 'https://swapi.dev/api/people/';
    }
  }

  void adicionarFavorito(lista, int index, int tipo) async {
    if(db == null)
      db = await connectDatabase();

    await db.execute("CREATE TABLE IF NOT EXISTS Favorito (nome TEXT PRIMARY KEY, tipo INTEGER)");


    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Favorito (nome, tipo) VALUES("${getNome(lista, index, tipo)}", ${tipo})');
    });
  }
}