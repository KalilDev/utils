// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:utils/utils.dart';

void main() {
  print(doNotationCodegen(10, 'Maybe'));
  print(doNotationCodegen(10, 'Future',
      typeTemplate: 'FutureOr<{{...arguments}}>', bind: 'then'));
  print(doNotationCodegen(10, 'Stream', bind: 'asyncExpand'));
  print(doNotationCodegen(10, 'Id'));
  print(doNotationCodegen(10, 'Either',
      typeArgumentsTemplate: '<Err, {{...arguments}}>',
      typeTemplate: 'Either<Err, {{...arguments}}>'));
}

const input = '{{Str1}} {{Fn1(a, b, c)}} {{...[,]It1}}'
    ' {{...It2}} {{...[;]FnIt1(a, b, c)}}';

final mappings = {
  'Str1': 'Hello World',
  'Fn1': (String a, String b, String c) => a + b + c,
  'It1': [1, 2, 3],
  'It2': [4, 5, 6],
  'FnIt1': (String a, String b, String c) => [a, b, c],
};

extension StringE on String {
  static int _INC(dynamic i) => i is int ? i + 1 : int.parse(i.toString()) + 1;
  static int _DEC(dynamic i) => i is int ? i - 1 : int.parse(i.toString()) - 1;
  static final _implicitState = <String, dynamic>{
    'INC': _INC,
    'DEC': _DEC,
  };
  String map(
    Map<String, dynamic> state, {
    String defaultSpreadSeparator = ',',
  }) {
    // ignore: parameter_assignments
    state = <String, dynamic>{
      ..._implicitState,
      ...state,
    };
    return splitMapJoin(
      RegExp(
          r'{{(?:(\.\.\.)(?:\[(.*?)\]|)|)([a-zA-Z0-9]+?)(?:\(([a-z, A-Z0-9]+)\)|)}}'),
      onMatch: (m) {
        dynamic result = state[m.group(3)!];
        if (m.group(4)?.isNotEmpty ?? false) {
          final arguments = m.group(4)!;
          final argList = arguments
              .split(',')
              .map((e) => e.trim())
              .map<dynamic>((e) => state[e] ?? e)
              .toList();
          final fn = result as Function;
          result = Function.apply(fn, argList);
        }
        if (m.group(1)?.isNotEmpty ?? false) {
          final separator = m.group(2)?.isEmpty ?? true
              ? defaultSpreadSeparator
              : m.group(2)!;
          return ((result ?? <dynamic>[]) as Iterable).join(separator);
        }
        return result.toString();
      },
    );
  }
}

String c(int charCode) => String.fromCharCode(charCode);

String doNotationCodegen(int count, String typeName,
    {String? typeTemplate,
    String bind = 'bind',
    String typeArgumentsTemplate = '<{{...arguments}}>'}) {
  // ignore: non_constant_identifier_names
  final AChar = 'A'.codeUnits.single;
  final aChar = 'a'.codeUnits.single;
  typeTemplate ??= '$typeName<{{...arguments}}>';
  String type(String arguments) =>
      typeTemplate!.replaceAll('{{...arguments}}', arguments);
  String parameters(int i) =>
      range(i - 1).map((e) => '${c(AChar + e)} ${c(aChar + e)}').join(',');
  String typeArguments(int i) => typeArgumentsTemplate.replaceAll(
      '{{...arguments}}', range(i).map((e) => c(AChar + e)).join(','));
  final bodySpecialCases = {1: 'a()', 2: 'a().$bind(b)'};
  Tuple<String, String> body(int i) {
    if (i == 2) return Tuple('a().$bind((a) => b(a)', ',)');
    final prev = body(i - 1);
    final arg = c(aChar + i - 2);
    final fn = c(aChar + i - 1);
    final argList = range(i - 2).map((i) => c(aChar + i)).join(',');
    return Tuple(
        prev.left + '.$bind(($arg) => $fn($argList)', ',)' + prev.right);
  }

  return variadicFunctionCodegen(
    range(count + 1, 1),
    '/// The do notation implementation for the Monad $typeName with {{i}} arguments.\n'
    '/// It is implemented using [$typeName.$bind]\n'
    '{{returnType}} {{name}}{{typeArguments}}({{{...arguments}}})=>{{body}};\n',
    {},
    (i) =>
        'required ' +
        type(c(AChar + i)) +
        ' Function(${parameters(i)}) ${c(aChar + i)}',
    (i) => 'do$typeName$i',
    typeArguments,
    (i) => type(c(AChar + i - 1)),
    (i) => bodySpecialCases[i] ?? body(i).pipe((e) => e.left + e.right),
  );
}

const String kDefaultClassTemplate = '''
class {{name}}{{i}}{{typeParams}} {{modifiers}} {
  {...members}
}''';
String variadicClassCodegen(
  range targetRange,
  String template,
  Map<int, String> specialCases,
  String Function(int i) name,
  String Function(int i) typeParams,
  String Function(int i) modifiers,
  Iterable<String> Function(int i) members,
) =>
    targetRange
        .map((i) =>
            specialCases[i] ??
            template.map(<String, dynamic>{
              'name': name(i),
              'typeParams': typeParams(i),
              'modifiers': modifiers(i),
              'members': members(i),
              'i': i,
            }))
        .join('\n');

const String kDefaultExtensionTemplate = '''
extension {{extensionName}}{{i}}{{extensionTypeParams}} on {{targetName}}{{targetTypeParams}} {
  {...members}
}''';
String variadicExtensionCodegen(
  range targetRange,
  String template,
  Map<int, String> specialCases,
  String Function(int i) extensionName,
  String Function(int i) extensionTypeParams,
  String Function(int i) targetName,
  String Function(int i) targetTypeParams,
  Iterable<String> Function(int i) members,
) =>
    targetRange
        .map((i) =>
            specialCases[i] ??
            template.map(<String, dynamic>{
              'extensionName': extensionName(i),
              'extensionTypeParams': extensionTypeParams(i),
              'targetName': targetName(i),
              'targetTypeParams': targetTypeParams(i),
              'members': members(i),
              'i': i,
            }))
        .join('\n');

const String kDefaultTypedefTemplate = '''
typedef {{typeName}}{{i}}{{typeParams}} = {{type}};''';
String variadicTypedefCodegen(
  range targetRange,
  String template,
  Map<int, String> specialCases,
  String Function(int i) typeName,
  String Function(int i) typeParams,
  String Function(int i) type,
) =>
    targetRange
        .map((i) =>
            specialCases[i] ??
            template.map(<String, dynamic>{
              'typeName': typeName(i),
              'typeParams': typeParams(i),
              'type': type(i),
              'i': i,
            }))
        .join('\n');

const String kDefaultFunctionTemplate = '''
{{returnType}} {{name}}{{i}}{{typeArguments}}({{...arguments}}) {{body}}''';
String variadicFunctionCodegen(
  range targetRange,
  String template,
  Map<int, String> specialCases,
  String Function(int i) arguments,
  String Function(int i) name,
  String Function(int i) typeArguments,
  String Function(int i) returnType,
  String Function(int i) body,
) =>
    targetRange
        .map((i) =>
            specialCases[i] ??
            template.map(<String, dynamic>{
              'returnType': returnType(i),
              'typeArguments': typeArguments(i),
              'name': name(i),
              'arguments': range(i).map(arguments),
              'body': body(i),
              'i': i,
            }))
        .join('\n');
