library utils.pattern;

import 'package:meta/meta.dart';

const _reason = 'The library utils.pattern is being deprecated as it is really '
    'exotic, there are better ways of expressing the matches.';

/// Matches just the values contained in the [Iterable] [values].
@Deprecated(_reason)
_InertPattern<T> values<T>(Iterable<T> values) => _InertPattern<T>(
      (v) => values.contains(v),
    );

/// Matches just the value [value].
@Deprecated(_reason)
_InertPattern<T> value<T>(T value) => _InertPattern<T>(
      (v) => v == value,
    );

/// Matches when the predicate [matches] evaluates to true.
@Deprecated(_reason)
_InertPattern<T> when<T>(bool Function(T value) matches) => _InertPattern<T>(
      matches,
    );

/// Matches just values of the type [T].
@Deprecated(_reason)
_InertPattern<T> type<T>() => _InertPattern<T>(
      (_) => true,
    );

/// Calls the function [fn] [T] -> [R] if the pattern from the optional
/// parameters, with none being [type<T>], is matched.
@Deprecated(_reason)
_EvaluatablePattern<R, T> mapper<T, R>(
  R Function(T) fn, {
  T value,
  Iterable<T> values,
  bool Function(T value) matches,
}) {
  if (value == null && values == null && matches == null) {
    return type<T>().then<R>(fn);
  }

  // Only one of them is not null
  if (value != null) {
    matches =
        matches == null ? (T v) => v == value : _throwOnDuplicatedMatcher();
  }
  if (values != null) {
    // ignore: parameter_assignments
    matches = matches == null ? values.contains : _throwOnDuplicatedMatcher();
  }

  return _InertPattern<T>(matches).then<R>(fn);
}

Never _throwOnDuplicatedMatcher() => throw ArgumentError(
    'Only one of `value`, `values` or `matches` may be specified.');

/// Calls the endofunction [fn] [T] -> [T] if the pattern from the optional
/// parameters, with none being [type<T>], is matched.
@Deprecated(_reason)
_EvaluatablePattern<T, T> endoMap<T>(
  T Function(T) fn, {
  T value,
  Iterable<T> values,
  bool Function(T value) matches,
}) =>
    mapper<T, T>(
      fn,
      value: value,
      values: values,
      matches: matches,
    );

/// Calls the void callback [fn] [T] -> [void] if the pattern from the optional
/// parameters, with none being [type<T>], is matched.
@Deprecated(_reason)
_EvaluatablePattern<void, T> doWhen<T>(
  void Function(T) fn, {
  T value,
  Iterable<T> values,
  bool Function(T value) matches,
}) =>
    mapper<T, void>(
      fn,
      value: value,
      values: values,
      matches: matches,
    );

/// Matches anything that was not handled previously. Behaves like 'default' on
/// an switch.
@Deprecated(_reason)
final _InertPattern<Object /*?*/ > any = type<Object /*?*/ >();

/// Wraps an [value] for pattern matching.
///
/// Attemps to emulate the F# idiom in the Dart language.
///
/// Example:
/// ```dart
/// match<num>(value)([
///    values([1, 2, 3]).when((v) => v != 1).then(print), // Prints when value is 2 or 3
///    type<double>().then((d) => print(2 * d)),          // Prints 2*value when value is an double
///    any,                                               // Does not do anything otherwise
///  ]);
/// ```
// ignore: camel_case_types
@Deprecated(_reason)
// ignore: camel_case_types
class match<T> {
  /// Wrap the value with [match].
  const match(this._value);
  final T _value;

  /// Evaluate an [Iterable] of [_Pattern].
  ///
  /// This does not allow storing the [_Pattern]s into an variable. By design.
  /// They are an small DSL, and making them behave like an regular [Iterable]
  /// would be weird.
  /// An example of the patterns would be the following:
  /// ```dart
  /// [
  ///    values([1, 2, 3]).when((v) => v != 1).then(print), // Prints when value is 2 or 3
  ///    type<double>().then((d) => print(2 * d)),          // Prints 2*value when value is an double
  ///    any,                                               // Does not do anything otherwise
  /// ]
  /// ```
  ///
  /// Iterates in order, stops evaluating at the first match and if the first
  /// match is an [_EvaluatablePattern], evaluate it and return the result,
  /// else, return [null].
  @optionalTypeArgs
  R call<R>(Iterable<_Pattern> patterns) => eval<R>(patterns);

  void _validateBeforeEval<R>(Iterable<_Pattern> patterns) {
    for (final p in patterns) {
      if (p is! _EvaluatablePattern) {
        continue;
      }
      if (p is! _EvaluatablePattern<R, dynamic>) {
        throw StateError(
            'The pattern ${p.runtimeType} is invalid, as every pattern'
            ' in this evaluation needs to have the return type $R');
      }
    }
  }

  /// Evaluate an [Iterable] of [_Pattern].
  ///
  /// This does not allow storing the [_Pattern]s into an variable. By design.
  /// They are an small DSL, and making them behave like an regular [Iterable]
  /// would be weird.
  /// An example of the patterns would be the following:
  /// ```dart
  /// [
  ///    values([1, 2, 3]).when((v) => v != 1).then(print), // Prints when value is 2 or 3
  ///    type<double>().then((d) => print(2 * d)),          // Prints 2*value when value is an double
  ///    any,                                               // Does not do anything otherwise
  /// ]
  /// ```
  ///
  /// Iterates in order, stops evaluating at the first match and if the first
  /// match is an [_EvaluatablePattern], evaluate it and return the result,
  /// else, return [null].
  @optionalTypeArgs
  R /*?*/ eval<R>(Iterable<_Pattern> patterns) {
    _validateBeforeEval<R>(patterns);
    for (final p in patterns) {
      if (!p.matches(_value)) {
        continue;
      }
      if (p is! _EvaluatablePattern) {
        return null;
      }
      return (p as _EvaluatablePattern<R, dynamic>)._eval(_value);
    }
    return null;
  }
}

/// Allows using the [match] class without it being shadowed internally
match<T> _wrapWithMatch<T>(T value) => match<T>(value);

/// Allows using pattern matching without wrapping an object with the match
/// class before.
extension ObjectPatternMatching<T> on T {
  /// Evaluates the patterns in an object.
  @Deprecated(_reason)
  R match<R>(Iterable<_Pattern> patterns) =>
      _wrapWithMatch<T>(this).eval<R>(patterns);
}

abstract class _Pattern<T> {
  const _Pattern(this._match) : assert(_match != null);
  final bool Function(T) _match;

  bool matches(Object value) {
    if (value is! T) {
      return false;
    }
    return _match(value as T);
  }
}

class _InertPattern<T> extends _Pattern<T> {
  const _InertPattern(bool Function(T) match) : super(match);

  _InertPattern<T1> when<T1 extends T>(bool Function(T1 value) matches) =>
      _InertPattern<T1>((v) {
        if (!_match(v)) {
          return false;
        }
        return matches(v);
      });

  _EvaluatablePattern<R, T> then<R>(R Function(T) eval) =>
      _EvaluatablePattern<R, T>(_match, eval);
}

class _EvaluatablePattern<R, T> extends _Pattern<T> {
  const _EvaluatablePattern(bool Function(T) match, this.__eval)
      : assert(__eval != null),
        super(match);
  final R Function(T) __eval;

  R _eval(Object value) {
    if (!matches(value)) {
      throw StateError('Cannot eval an pattern that was not matched!');
    }
    return __eval(value as T);
  }

  R eval(Object value, [R Function() orElse]) {
    if (orElse != null) {
      return matches(value) ? _eval(value) : orElse();
    }
    return _eval(value);
  }
}
