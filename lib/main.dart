import 'package:flutter/material.dart';
import 'package:desafio/paginas/tela_login.dart';
import 'package:desafio/paginas/cadastro.dart';
import 'package:desafio/paginas/bem_vindo.dart';

void main() {
 runApp(AppLogin());
}

class AppLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niten Kenjutsu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData (
        fontFamily:'Korean 0.2',
        primarySwatch:Colors.brown,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.red[900],
          height: 40,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home:TelaLogin(),
      routes: <String, WidgetBuilder> {
        '/telalogin': (BuildContext context) => TelaLogin(),
        '/cadastro': (BuildContext context) => Cadastro(),
        '/bemvindo': (BuildContext context) => Bemvindo(),
      },
    );   
  }
}
