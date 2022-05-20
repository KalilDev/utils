// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'either.dart';

// **************************************************************************
// AdtGenerator
// **************************************************************************

abstract class Either<a extends Object?, b extends Object?>
    with _EitherMonadOps<a, b>, _EitherBiFunctorOps<a, b>, _EitherExtraOps<a, b>
    implements SumType {
  const Either._();
  const factory Either.left(a _value) = Left;
  const factory Either.right(b _value) = Right;

  @override
  SumRuntimeType get runtimeType => SumRuntimeType([Left<a, b>, Right<a, b>]);

  R visit<R extends Object?>(
      {required R Function(a _value) left,
      required R Function(b _value) right});

  @override
  int get hashCode => throw UnimplementedError(
      'Each case has its own implementation of hashCode');
  bool operator ==(other) =>
      throw UnimplementedError('Each case has its own implementation of ==');

  String toString() => throw UnimplementedError(
      'Each case has its own implementation of toString');
}

class Left<a extends Object?, b extends Object?> extends Either<a, b> {
  final a _value;

  const Left(this._value) : super._();

  @override
  int get hashCode => Object.hash((Left), a, b, _value);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Left<a, b> && true && this._value == other._value);

  @override
  String toString() => "Left<$a,$b> { $_value }";

  @override
  R visit<R extends Object?>(
          {required R Function(a _value) left,
          required R Function(b _value) right}) =>
      left(this._value);
}

class Right<a extends Object?, b extends Object?> extends Either<a, b> {
  final b _value;

  const Right(this._value) : super._();

  @override
  int get hashCode => Object.hash((Right), a, b, _value);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Right<a, b> && true && this._value == other._value);

  @override
  String toString() => "Right<$a,$b> { $_value }";

  @override
  R visit<R extends Object?>(
          {required R Function(a _value) left,
          required R Function(b _value) right}) =>
      right(this._value);
}
