import 'package:flutter/material.dart';

import 'input.dart';
import 'records.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<MyApp> {
  var _currentIndex = 0;

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
            bottomNavigationBar: new BottomNavigationBar(
                onTap: _onItemTapped,
                currentIndex: _currentIndex,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.alarm),
                    title: Text('Calculadora'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.star),
                    title: Text('Records'),
                  )
                ]),
            body: _getCurrent()));
  }

  void _onItemTapped(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  Widget _getCurrent() {
    if (_currentIndex == 0) {
      return new Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[new InputWidget()]);
    }

    return new RecordWidget();
  }
}
