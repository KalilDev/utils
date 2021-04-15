import 'package:utils/utils.dart';

void main() {
  patternExample(1);
  patternExample(1.0);
  patternExample('Hello');
}

void patternExample(dynamic value) => match(value)({
      type<int>().then((i) => print('int $i')),
      type<double>().then((d) => print('double $d')),
      any.then((v) => print('value $v')),
    });
