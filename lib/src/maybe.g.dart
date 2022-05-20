// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maybe.dart';

// **************************************************************************
// AdtGenerator
// **************************************************************************

abstract class Maybe<t extends Object?>
    with _MaybeMonadOps<t>, _MaybeExtraOps<t>
    implements SumType {
  const Maybe._();
  const factory Maybe.just(t _value) = Just;
  const factory Maybe.none() = None;

  @override
  SumRuntimeType get runtimeType => SumRuntimeType([Just<t>, None<t>]);

  R visit<R extends Object?>(
      {required R Function(t _value) just, required R Function() none});

  @override
  int get hashCode => throw UnimplementedError(
      'Each case has its own implementation of hashCode');
  bool operator ==(other) =>
      throw UnimplementedError('Each case has its own implementation of ==');

  String toString() => throw UnimplementedError(
      'Each case has its own implementation of toString');
}

class Just<t extends Object?> extends Maybe<t> {
  final t _value;

  const Just(this._value) : super._();

  @override
  int get hashCode => Object.hash((Just), t, _value);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Just<t> && true && this._value == other._value);

  @override
  String toString() => "Just<$t> { $_value }";

  @override
  R visit<R extends Object?>(
          {required R Function(t _value) just, required R Function() none}) =>
      just(this._value);
}

class None<t extends Object?> extends Maybe<t> {
  const None() : super._();

  @override
  int get hashCode => Object.hash((None), t);
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is None<t> && true);

  @override
  String toString() => "None<$t>";

  @override
  R visit<R extends Object?>(
          {required R Function(t _value) just, required R Function() none}) =>
      none();
}
