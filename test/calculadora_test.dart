import 'package:calculadora_corredor/calculadora.dart';
import 'package:test/test.dart';

void main() {
  Calculadora calc = new Calculadora();
  test('pace meia maratona', () {
    calc.withDistancia("21");
    calc.withPace("05:00");
    expect(calc.calculaTempo(), "1:45:00");
  });
  test('pace 5km', () {
    calc.withDistancia("5");
    calc.withPace("05:00");
    expect(calc.calculaTempo(), "25:00");
  });
}
