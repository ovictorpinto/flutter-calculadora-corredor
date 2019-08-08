import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calculadora.dart';
import 'persistencia.dart';

class InputWidget extends StatefulWidget {
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<InputWidget> {

  _ListWidgetState() {
    _refresh();
  }

  final TextEditingController textFieldDistanciaController =
      TextEditingController();
  final TextEditingController textFieldTempoController =
      TextEditingController();
  final TextEditingController textFieldRitmoController =
      TextEditingController();

  List<Map<String, dynamic>> itens = new List();

  @override
  Widget build(BuildContext context) {
    var textFieldDistancia = new TextField(
      decoration: const InputDecoration(
          icon: const Icon(Icons.room), labelText: 'Distância(km)'),
      keyboardType: TextInputType.number,
      controller: textFieldDistanciaController,
    );

    var textFieldRitmo = new TextField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[_PaceFormatter()],
        controller: textFieldRitmoController,
        decoration: const InputDecoration(
            icon: const Icon(Icons.directions_run),
            hintText: "mm:ss",
            labelText: 'Pace(min/km)'));

    var textFieldTempo = new TextField(
        keyboardType: TextInputType.number,
        controller: textFieldTempoController,
        decoration: const InputDecoration(
            icon: const Icon(Icons.timer), labelText: 'Tempo'));

    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Expanded(child: textFieldDistancia),
              new RaisedButton(
                onPressed: _calcularDistancia,
                child: Text("Calcular"),
              ),
            ],
          ),
          Container(
            height: 16.0,
          ),
          new Row(
            children: <Widget>[
              new Expanded(child: textFieldRitmo),
              new RaisedButton(
                onPressed: _calcularRitmo,
                child: Text("Calcular"),
              ),
            ],
          ),
          new Container(
            height: 16.0,
          ),
          new Row(
            children: <Widget>[
              new Expanded(child: textFieldTempo),
              new RaisedButton(
                onPressed: _calcularTempo,
                child: Text("Calcular"),
              ),
            ],
          ),
          new Container(
            height: 16.0,
          ),
          new Row(
            children: <Widget>[
              Expanded(
                  child: ListView(shrinkWrap: true, children: _getListData())),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: _limparResultados,
              )
            ],
          )
        ],
      ),
    );
  }

  _refresh() {
    Future<List<Map<String, dynamic>>> maps = Persistencia().findAll();
    maps.then((list) {
      setState(() {
        itens = list;
      });
    });
  }

  _calcularRitmo() {
    var calc = Calculadora()
        .withDistancia(textFieldDistanciaController.text)
        .withTempo(textFieldTempoController.text);
    var novoPace = calc.calculaPace();
    textFieldRitmoController.text = novoPace;
    calc.withPace(novoPace);
    Persistencia().insert(calc);
    _refresh();
  }

  _calcularDistancia() {
    var calc = Calculadora()
        .withPace(textFieldRitmoController.text)
        .withTempo(textFieldTempoController.text);
    var novaDistancia = calc.calculaDistancia();
    textFieldDistanciaController.text = novaDistancia.toString();
    calc.withDistancia(novaDistancia.toString());
    Persistencia().insert(calc);
    _refresh();
  }

  _calcularTempo() {
    var calc = Calculadora()
        .withPace(textFieldRitmoController.text)
        .withDistancia(textFieldDistanciaController.text);

    var novoTempo = calc.calculaTempo();
    textFieldTempoController.text = novoTempo;
    calc.withTempo(novoTempo);
    Persistencia().insert(calc);
    _refresh();
  }

  _limparResultados() {
    Persistencia().deleteAll();
    _refresh();
  }

  _getListData() {
    List<Widget> widgets = [];
    widgets.add(Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(child: Text('DISTANCIA')),
        Expanded(child: Text('PACE')),
        Expanded(child: Text('TEMPO'))
      ],
    ));
    for (int i = 0; i < min(itens.length, 5); i++) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: Text('${itens[i][Persistencia.COL_DISTANCIA]}')),
            Expanded(child: Text('${itens[i][Persistencia.COL_PACE]}')),
            Expanded(child: Text('${itens[i][Persistencia.COL_TEMPO]}'))
          ],
        ),
      ));
    }
    return widgets;
  }
}

class _PaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = new StringBuffer();
    if (newValue.text.length < oldValue.text.length) {
      //apagando
      newText.write(newValue.text);
    } else if (newValue.text.length > 5) {
      //limite
      newText.write(oldValue.text);
    } else {
      String unmasked = newValue.text.replaceAll(":", "");
      if (unmasked.length > 2) {
        newText.write(unmasked.substring(0, 2));
        newText.write(":");
        newText.write(unmasked.substring(2, unmasked.length));
      } else {
        newText.write(unmasked);
      }
    }
    int selectionIndex = newText.length;

    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
