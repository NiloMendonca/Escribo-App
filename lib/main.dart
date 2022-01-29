import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'components/menu.dart';
import 'services/http.dart';
import 'services/database.dart';
import 'components/util.dart';

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
      body: SafeArea(
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
                          height: MediaQuery.of(context).size.height-250,
                          child: TabBarView(children: <Widget>[
                            Container(
                              child: getTab(1),
                            ),
                            Container(
                              child: getTab(2),
                            ),
                            Container(
                              child: Center(
                                child: FutureBuilder(
                                    future: BancoDeDados().getFavoritos(),
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
                                            if(Util().verificaTamanhoVetor(lista) > 0) {
                                              return Container(
                                                child: ListView.builder(
                                                  itemCount: Util().verificaTamanhoVetor(
                                                      lista),
                                                  itemBuilder: (context, index) {
                                                    return Column(
                                                        children: <Widget>[
                                                          // getBotaoAtualiza(index),
                                                          ListTile(
                                                            title: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: Util().getNome(
                                                                          lista,
                                                                          index, 3),
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Util().getTipo(
                                                                            lista,
                                                                            index),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .delete),
                                                                      color: Util().getTipo(
                                                                          lista,
                                                                          index),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          BancoDeDados().deletarFavorito(
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

  Widget getTab(int tipo){
    return FutureBuilder(
        future: BancoDeDados().getFavoritos(),
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
                return getItens(tipo, listaFavoritos);
              }
              else {
                return getItens(tipo, null);
              }
          }
        }
    );
  }

  Widget getItens(int tipo, listaFavoritos){
    return FutureBuilder(
        future: HttpService().getDados(HttpService().getEndpoint(tipo), []),
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
                    itemCount: Util().verificaTamanhoVetor(lista),
                    itemBuilder: (context, index) {
                      return Column(children: <Widget>[
                        ListTile(
                          title: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: Util().getNome(
                                        lista, index, tipo),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: verificaIcone(
                                        lista, index, tipo,
                                        listaFavoritos),
                                    color: Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        BancoDeDados().adicionarFavorito(
                                            lista, index, tipo);
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

  verificaIcone(lista, index, tipo, listaFavoritos) {
    if(listaFavoritos == null)
      return Icon(Icons.favorite_border);
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
              BancoDeDados().getFavoritos();
            });
          }
      );
    }
    return Padding(
      padding: EdgeInsets.all(0.0),
    );
  }
}