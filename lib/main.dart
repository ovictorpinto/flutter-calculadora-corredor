import 'package:flutter/material.dart';

import 'input.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
            appBar: AppBar(
              title: Text("Calculadora do Corredor"),
            ),
            body: new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new InputWidget()
              ],
            )));
  }
}
