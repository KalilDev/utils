// ignore_for_file: avoid_print

import 'dart:collection';

import 'package:utils/utils.dart';

class Token extends DoubleLinkedQueueEntry<Token> {
  Token(this.content, this.location) : super(null) {
    element = this;
  }
  Token? get next => nextEntry()?.element;
  Token? get prev => previousEntry()?.element;
  factory Token.fromMatch(RegExpMatch match) => Token(
        match.input.substring(match.start, match.end),
        SourceLocation(match.start, match.end - match.start),
      );

  final String content;
  final SourceLocation location;
  TokenKind get kind {
    switch (content.trim()) {
      case '...':
        return TokenKind.tripleDot;
      case '[':
        return TokenKind.openSquareBracket;
      case ']':
        return TokenKind.closeSquareBracket;
      case '(':
        return TokenKind.openParens;
      case ')':
        return TokenKind.closeParens;
      case ',':
        return TokenKind.comma;
      case '=':
        return TokenKind.equals;
      case '=>':
        return TokenKind.equalsGreater;
    }
    if (content[0] == "'" && content[content.length - 1] == "'") {
      return TokenKind.stringLiteral;
    }
    if (content[0] == '"' && content[content.length - 1] == '"') {
      return TokenKind.stringLiteral;
    }

    if (content.codeUnits
        .every((e) => e >= '0'.codeUnits.single && e <= '9'.codeUnits.single)) {
      return TokenKind.intLiteral;
    }
    if (doubleRegex.hasMatch(content)) {
      return TokenKind.doubleLiteral;
    }
    return TokenKind.identifier;
  }

  static final doubleRegex = RegExp('[0-9]+\.[0-9]+');

  @override
  String toString() => 'T{$content;$location}';
}

enum TokenKind {
  doubleLiteral,
  intLiteral,
  stringLiteral,
  identifier,
  tripleDot,
  openSquareBracket,
  closeSquareBracket,
  openParens,
  closeParens,
  comma,
  equals,
  equalsGreater,
}

class SourceLocation {
  const SourceLocation(this.offset, this.length);

  final int offset;
  final int length;

  @override
  String toString() => '$offset:$length';
}

class Scanner {
  static final tokenRegex = RegExp(
      r'''[0-9]+\.[0-9]+|".*?"|'.*?'|[a-zA-Z0-9]+|\.\.\.|\[|\]|\(|\)|,|=>|=''');
  // Returns the tail and the head of the token list
  Maybe<Tuple<Token, Token>> scan(String source) =>
      tokenRegex.allMatches(source).fold<Maybe<Tuple<Token, Token>>>(
          const None(),
          (state, match) => state
              .visit<Tuple<Token, Token>>(
                just: (prevs) => prevs.second((right) {
                  final token = Token.fromMatch(match);
                  right.append(token);
                  return token;
                }),
                none: () {
                  final token = Token.fromMatch(match);
                  return Tuple(token, token);
                },
              )
              .just);
}

class Parser {
  Expression parse(Token start) => parseExpression(start).left;

  Tuple<Literal, Token?> parseLiteral(Token start) {
    switch (start.kind) {
      case TokenKind.doubleLiteral:
        return Tuple(
            Literal()
              ..value = double.parse(start.content)
              ..kind = LiteralKind.double,
            start.next);
      case TokenKind.intLiteral:
        return Tuple(
            Literal()
              ..value = int.parse(start.content)
              ..kind = LiteralKind.int,
            start.next);
      case TokenKind.stringLiteral:
        return Tuple(
            Literal()
              ..value = start.content
              ..kind = LiteralKind.String,
            start.next);
      case TokenKind.identifier:
        return Tuple(
            Literal()
              ..value = Identifier(start.content)
              ..kind = LiteralKind.Identifier,
            start.next);
      default:
        throw StateError('Invalid literal token kind');
    }
  }

  Tuple<Spread, Token?> parseSpread(Token start) {
    assert(start.kind == TokenKind.tripleDot);
    final result = Spread()..tripleDots = start;
    var next = start.next!;
    if (next.kind == TokenKind.openSquareBracket) {
      final expr = parseExpression(next.next!);
      result.separator = expr.left;
      next = expr.right!;
      assert(next.kind == TokenKind.closeSquareBracket);
      next = next.next!;
    } else {
      result.separator = null;
    }
    final target = parseExpression(next);
    result.target = target.left;
    return Tuple(result, target.right);
  }

  Tuple<Call, Token?> parseCall(Expression target, Token start) {
    assert(start.kind == TokenKind.openParens);
    final args = <Expression>[];
    Token? next = start.next;
    while (next != null && next.kind != TokenKind.closeParens) {
      if (args.isNotEmpty) {
        // The next token should be an comma
        assert(next.kind == TokenKind.comma);
        next = next.next!;
      }
      final expr = parseExpression(next);
      args.add(expr.left);
      next = expr.right;
    }
    // Ensure we finished at an close parens
    assert(next != null);
    return Tuple(
        Call()
          ..target = target
          ..arguments = args,
        next!.next);
  }

  Tuple<Expression, Token?> parseCallOrIdentifier(Token start) {
    Tuple<Expression, Token?> targetExpr = parseLiteral(start);
    // Handle higher order functions
    while (targetExpr.right?.kind == TokenKind.openParens) {
      targetExpr = parseCall(targetExpr.left, targetExpr.right!);
    }
    return targetExpr;
  }

  Tuple<FunctionParam, Token?> parseFunctionParam(Token start) {
    final id = parseLiteral(start);
    assert(id.left.kind == LiteralKind.Identifier);

    final param = FunctionParam()..name = id.left.kind as Identifier;

    var next = id.right;
    if (next!.kind != TokenKind.equals) {
      return Tuple(param, next);
    }
    next = next.next;
    final initialization = parseExpression(next!);
    return Tuple(
      param..initialization = initialization.left,
      initialization.right,
    );
  }

  Tuple<FunctionDeclaration, Token?> parseFunctionDeclaration(Token start) {
    assert(start.kind == TokenKind.openParens);
    final params = <FunctionParam>[];
    var next = start.next;
    while (next != null && next.kind != TokenKind.closeParens) {
      final param = parseFunctionParam(start);
      params.add(param.left);
      next = param.right;
    }
    // ignore: unnecessary_null_checks
    next = next!.next!;
    assert(next.kind == TokenKind.equalsGreater);
    final body = parseExpression(next.next!);
    return Tuple(
        FunctionDeclaration()
          ..params = params
          ..body = body.left,
        body.right);
  }

  Tuple<Expression, Token?> parseExpression(Token start) {
    if (start.kind == TokenKind.tripleDot) {}
    switch (start.kind) {
      case TokenKind.tripleDot:
        return parseSpread(start);
      case TokenKind.doubleLiteral:
      case TokenKind.intLiteral:
      case TokenKind.stringLiteral:
        return parseLiteral(start);
      case TokenKind.openParens:
        return parseFunctionDeclaration(start);
      case TokenKind.openSquareBracket:
      case TokenKind.closeSquareBracket:
      case TokenKind.closeParens:
      case TokenKind.comma:
      case TokenKind.equals:
      case TokenKind.equalsGreater:
        throw StateError('Invalid start token');
      case TokenKind.identifier:
        return parseCallOrIdentifier(start);
    }
  }
}

abstract class ASTNode {
  ASTNode? parent;
}

enum LiteralKind {
  String,
  int,
  double,
  Identifier,
}

class Identifier {
  const Identifier(this.content);

  final String content;

  int get hashCode => content.hashCode;
  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Identifier) {
      return other.content == content;
    }
    return false;
  }

  @override
  String toString() => '#$content';
}

/// Literal ::= stringLiteral
///           | intLiteral
///           | doubleLiteral
///           | identifier
class Literal extends Expression {
  late dynamic value;
  late LiteralKind kind;
  @override
  String toString() => 'Lit{$value}';
}

/// Expression ::= [Literal]
///              | [Spread]
///              | [Call]
abstract class Expression extends ASTNode {}

/// Spread ::= `...` separator? [Expression]
///
/// separator ::= `[` [Expression] `]`
class Spread extends Expression {
  late Token tripleDots;
  late Expression? separator;
  late Expression target;
  @override
  String toString() => 'Spr{$tripleDots \"$separator\" $target}';
}

/// Call := [Expression] `(` args `)`
/// args := [Expression] (',' [Expression])*
class Call extends Expression {
  late Expression target;
  late List<Expression> arguments;
  @override
  String toString() => "Cal{$target (\"${arguments.join(', ')}\")}";
}

/// FunctionDeclaration := `(` params `)` `=>` [Expression]
///             params := [FunctionParam] (',' [FunctionParam])*
class FunctionDeclaration extends Expression {
  late List<FunctionParam> params;
  late Expression body;
  @override
  String toString() => "Def{(\"${params.join(', ')}\") => $body}";
}

/// FunctionParam := [Identifier] initialization?
/// initialization := `=` [Expression]
class FunctionParam extends ASTNode {
  late Identifier name;
  Expression? initialization;
  @override
  String toString() =>
      "Param{$name ${initialization == null ? '' : '= $initialization'}}";
}

abstract class InteropOrInterpretedOrEvaluatedFunction {
  const InteropOrInterpretedOrEvaluatedFunction();
  dynamic call(List<dynamic> args);
}

class InteropFunction extends InteropOrInterpretedOrEvaluatedFunction {
  const InteropFunction(this.fn);

  final Function fn;
  @override
  dynamic call(List<dynamic> args) => Function.apply(fn, args);
}

class InterpretedFunction extends InteropOrInterpretedOrEvaluatedFunction {
  const InterpretedFunction(this.interpreter, this.definition);

  final Interpreter interpreter;
  final FunctionDeclaration definition;

  dynamic call(List args) => interpreter.interpretFunction(definition, args);
}

class EvaluatedFunction extends InteropOrInterpretedOrEvaluatedFunction {
  const EvaluatedFunction(
    this.scanner,
    this.parser,
    this.interpreter,
    this.body,
  );

  final Scanner scanner;
  final Parser parser;
  final Interpreter interpreter;
  final String body;

  @override
  dynamic call(List args) {
    final tokens = scanner.scan(body);
    return tokens
        .fmap((tokens) => parser.parseFunctionDeclaration(tokens.left).left)
        .fmap<dynamic>((decl) => interpreter.interpretFunction(decl, args))
        .valueOr(null);
  }
}

class InterpreterCall {
  const InterpreterCall(this.functionName, this.arguments);

  final Identifier functionName;
  final List<dynamic> arguments;
}

class Interpreter {
  Interpreter._(this._state);
  factory Interpreter(Map<String, dynamic> state) =>
      Interpreter._(state.map<Identifier, dynamic>((k, dynamic v) =>
          MapEntry<Identifier, dynamic>(
              Identifier(k), v is Function ? InteropFunction(v) : v)));

  final Map<Identifier, dynamic> _state;

  dynamic interpretFunction(
    FunctionDeclaration definition,
    List<dynamic> args, [
    Map<Identifier, dynamic>? scope,
  ]) {
    scope ??= _state;
    final neededArgCount = definition.params //
        .takeWhile((e) => e.initialization == null)
        .length;
    if (args.length < neededArgCount ||
        args.length > definition.params.length) {
      throw StateError('Invalid arg count!');
    }
    final values = definition.params
        .zipAll<dynamic>(args)
        .map((e) => MapEntry<Identifier, dynamic>(
              e.left!.name,
              e.right ?? interpret(e.left!.initialization!),
            ));
    final newScope = <Identifier, dynamic>{
      ...scope,
      ...Map<Identifier, dynamic>.fromEntries(values)
    };
    return interpret(definition.body, newScope);
  }

  dynamic _call(Identifier function, List<dynamic> arguments) {
    final fn = _fetchIdentifierOrCallResult(function, _state)
        as InteropOrInterpretedOrEvaluatedFunction;
    return fn(arguments);
  }

  dynamic _fetchIdentifierOrCallResult(
      dynamic result, Map<Identifier, dynamic> scope) {
    if (result is Identifier) {
      return scope[result];
    }
    if (result is InterpreterCall) {
      return _fetchIdentifierOrCallResult(
        _call(result.functionName, result.arguments),
        scope,
      );
    }
    return result;
  }

  dynamic interpret(Expression expr, [Map<Identifier, dynamic>? scope]) {
    scope ??= _state;
    if (expr is Literal) {
      return _fetchIdentifierOrCallResult(expr.value, scope);
    }
    if (expr is Call) {
      final fn =
          interpret(expr.target) as InteropOrInterpretedOrEvaluatedFunction;
      return _fetchIdentifierOrCallResult(
          fn(
            expr.arguments.map<dynamic>(interpret).toList(),
          ),
          scope);
    }
    if (expr is Spread) {
      final source = interpret(expr.target) as Iterable;
      return source.join(
        expr.separator == null ? "," : interpret(expr.separator!).toString(),
      );
    }
    throw TypeError();
  }

  dynamic fetchProperty(Identifier identifier) => _state[identifier];
  bool hasProperty(Identifier identifier) => _state.containsKey(identifier);
  void setProperty(Identifier identifier, dynamic value) =>
      _state[identifier] = value;
}

void main(List<String> arguments) {
  final scanner = Scanner();
  final tokens =
      scanner.scan("...[espacador()]higherOrder('123')('piru', 123, 456, 3.0)");
  print(tokens);
  final parser = Parser();
  final result = tokens.fmap((e) => e.left).fmap(parser.parse);
  print(result);
  final interpreter = Interpreter(<String, dynamic>{
    'interop': (dynamic a) =>
        InterpreterCall(Identifier('mamaMeu'), <dynamic>[a, a, a, a]),
    'higherOrder': (dynamic a) => Identifier('mamaMeu'),
    'mamaMeu': (dynamic a, dynamic b, dynamic c, dynamic d) =>
        ['Hello World!', 'Caralho'],
    'espacador': () => '; ',
  });
  print(result.fmap<dynamic>(interpreter.interpret));
}
