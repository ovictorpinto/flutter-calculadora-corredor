import 'package:intl/intl.dart';

class Calculadora {
  double _distancia;
  int _pace;
  int _tempo;

  Calculadora withDistancia(String distancia) {
    _distancia = double.parse(distancia);
    return this;
  }

  Calculadora withPace(String pace) {
    assert(pace.length == 5);
    int min = int.parse(pace.substring(0, 2));
    int sec = int.parse(pace.substring(3, 5));
    _pace = min * 60 + sec;
    return this;
  }

  ///
  /// mm:ss
  /// h:mm:ss
  ///
  Calculadora withTempo(String tempo) {
    List<String> splited = tempo.split("\.");
    assert(splited.length >= 2 && splited.length <= 3);
    int hor = 0;
    int min;
    int sec;
    if (splited.length == 2) {
      min = int.parse(splited[0]);
      sec = int.parse(splited[1]);
    } else {
      hor = int.parse(splited[0]);
      min = int.parse(splited[1]);
      sec = int.parse(splited[2]);
    }
    _tempo = hor * 60 * 60 + min * 60 + sec;
    return this;
  }

  double calculaDistancia() {
    return _tempo / _pace;
  }

  String calculaTempo() {
    var segundosTotal = _pace * _distancia;
    int hor = (segundosTotal / (60 * 60)).floor();
    int min = ((segundosTotal % (60 * 60)) / 60).floor();
    int sec = ((segundosTotal % (60 * 60)) % 60).floor();

    StringBuffer retorno = new StringBuffer();
    if (hor > 0) {
      retorno.write(NumberFormat("####").format(hor));
      retorno.write(":");
    }
    retorno.write(NumberFormat("00").format(min));
    retorno.write(":");
    retorno.write(NumberFormat("00").format(sec));
    return retorno.toString();
  }
}
