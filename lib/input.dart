import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calculadora.dart';

class InputWidget extends StatelessWidget {
  TextEditingController textFieldDistanciaController = TextEditingController();
  TextEditingController textFieldTempoController = TextEditingController();
  TextEditingController textFieldRitmoController = TextEditingController();

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
          Container(
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
          )
        ],
      ),
    );
  }

  _calcularRitmo() {
    print("Clicou pra achar o ritmo ${textFieldRitmoController.text}");
  }

  _calcularDistancia() {
    var novaDistancia = Calculadora()
        .withPace(textFieldRitmoController.text)
        .withTempo(textFieldTempoController.text)
        .calculaDistancia();
    textFieldDistanciaController.text = novaDistancia.toString();
  }

  _calcularTempo() {
    var novoTempo = Calculadora()
        .withPace(textFieldRitmoController.text)
        .withDistancia(textFieldDistanciaController.text)
        .calculaTempo();
    textFieldTempoController.text = novoTempo;
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
