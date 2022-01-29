import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import '../pages/perfil.dart';
import '../pages/web.dart';
import '../pages/main.dart';

class Menu {
  Widget menu(BuildContext context, bool isHome) {
    return Column(
        children: [
          SizedBox(
            height: 27,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20)
                      ),
                      onPressed: () {
                        if (isHome) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => WebPage())
                          );
                        }
                        else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp())
                          );
                        }
                      },
                      child: const Text('Site Oficial'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        if (isHome) {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => PerfilPage())
                          );
                        }
                        else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp())
                          );
                        }
                      },
                      child: FluttermojiCircleAvatar(
                        backgroundColor: Colors.grey[200],
                        radius: 40,
                      ),
                    ),
                  ]
              )
          )
        ]
    );
  }
}