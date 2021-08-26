import 'dart:async';

import 'maybe.dart';
import 'type.dart';

T _identity<T>(T v) => v;
T _notNull<T>(T? v) => ArgumentError.checkNotNull(v);

/// An [Monad<B>] which contains either an [Left<A>] value or an [Right<B>]
/// value and performs the [bind] and [fmap] on the [Right] value.
///
/// The [Right] one is used in the [Functor], [Applicative] and [Monad]
/// operations because mnemonically "right" also means "correct".
///
/// Normally, an function that may fail may return an [Either]<[Exception], T>.
abstract class Either<A, B> extends Monad<B> implements BiFunctor<A, B> {
  const Either._();

  static Either<E, T> fromComputation<E extends Exception, T>(T Function() fn) {
    try {
      return right<E, T>(fn());
    } on E catch (e) {
      return left<E, T>(e);
    }
  }

  static Future<Either<E, T>> fromAsyncComputation<E extends Exception, T>(
      Future<T> Function() fn) async {
    try {
      final f = fn();
      return right<E, T>(await f);
    } on E catch (e) {
      return left<E, T>(e);
    }
  }

  /// Construct an [Left] with [value]
  static Either<A, B> left<A, B>(A value) => Left(value);

  /// Construct an [Right] with [value]
  static Either<A, B> right<A, B>(B value) => Right(value);

  @override
  Either<A, T> unit<T>(T value) => right<A, T>(value);

  @override
  Either<A1, B> first<A1>(A1 Function(A) fn) =>
      bimap<A1, B>(a: fn, b: _identity);

  @override
  Either<A, B1> second<B1>(B1 Function(B) fn) =>
      bimap<A, B1>(a: _identity, b: fn);

  @override
  Either<A1, B1> bimap<A1, B1>({
    required A1 Function(A) a,
    required B1 Function(B) b,
  }) =>
      visit<Either<A1, B1>>(
        a: (v) => Either.left<A1, B1>(a(v)),
        b: (v) => Either.right<A1, B1>(b(v)),
      );

  @override

  /// Map the right value [B] into an [Either<A, B1>], while keeping
  /// the left value untouched.
  Either<A, B1> fmap<B1>(B1 Function(B) fn) => second(fn);

  /// Flat map the right value [B] into an [Either<A, B1>], while keeping
  /// the left value untouched.
  @override
  Either<A, B1> bind<B1>(Either<A, B1> Function(B) fn) => visit(
        a: (v) => Either.left<A, B1>(v),
        b: _notNull(fn),
      );

  /// Handle the right value with [right] and return the left [A] value.
  A getL(A Function(B) right) => visit(a: _identity, b: right);

  /// Handle the left value with [left] and return the right [B] value.
  B getR(B Function(A) left) => visit(a: left, b: _identity);

  /// Run the correct callback in case of left or right.
  T visit<T>({required T Function(A) a, required T Function(B) b});

  /// [Maybe] return the [Left] value, returning [None] in case [this] is
  /// [Right]
  Maybe<A> get maybeLeft => visit(a: Maybe.just, b: (_) => Maybe.none());

  /// [Maybe] return the [Right] value, returning [None] in case [this] is
  /// [Left]
  Maybe<B> get maybeRight => visit(a: (_) => Maybe.none(), b: Maybe.just);

  @override
  Either<Exception, B1> lift<A1, B1>(
    Either<Exception, B1 Function(A1)> fn,
    Either<Exception, A1> a,
  ) =>
      fn.bind((fn) => a.fmap(fn));

  /// Perform the operation [fn] with the value [A] in [a] and wrap with
  /// [Either<E1, B1>] for pipelining.
  ///
  /// This needs to exist because the [E1] type is needed for correct inference
  /// on [Either]
  Either<E1, B1> liftEither<A1, B1, E1>(
    Either<E1, B1 Function(A1)> fn,
    Either<E1, A1> a,
  ) =>
      fn.bind((fn) => a.fmap(fn));

  Either<B, A> swap() => visit(a: right, b: left);
}

extension MaybeToEither<T> on Maybe<T> {
  Either<L, T> toEither<L>({L? l, L Function()? get}) {
    assert((l != null) ^ (get != null));
    get ??= () => l!;
    return visit<Either<L, T>>(
      just: (v) => Right<L, T>(v),
      none: () => Left<L, T>(get!()),
    );
  }
}

/// The left [A] value in an [Either] type.
class Left<A, B> extends Either<A, B> {
  /// Create an [Left] [Either] with the [_value].
  const Left(this._value) : super._();
  final A _value;

  @override
  T visit<T>({required T Function(A p1) a, required T Function(B p1) b}) =>
      a.call(_value);
}

/// The right [B] value in an [Either] type.
class Right<A, B> extends Either<A, B> {
  /// Create an [Right] [Either] with the [_value].
  const Right(this._value) : super._();
  final B _value;

  @override
  T visit<T>({required T Function(A p1) a, required T Function(B) b}) =>
      b.call(_value);
}

/// Utils for extracting [Either] values from an [Iterable]
extension EitherIterableUtils<A, B> on Iterable<Either<A, B>> {
  /// Extract the [Left] values
  Iterable<A> lefts() =>
      whereType<Left<A, B>>().map((e) => e.getL((_) => throw 'Unreachable'));

  /// Extract the [Right] values
  Iterable<B> rights() =>
      whereType<Right<A, B>>().map((e) => e.getR((_) => throw 'Unreachable'));

  /// Partition into 2 [List]s, the first containing [Left] the values and the
  /// second containing the [Right] values.
  List<List<dynamic>> partitionEithers() => fold(
        [<A>[], <B>[]],
        (r, either) {
          either.visit(
            a: (r.first as List<A>).add,
            b: (r.last as List<B>).add,
          );
          return r;
        },
      );
}

/// Extension on [Either] [Function]s for applying them.
extension EitherApply<U, T, E> on Either<E, U Function(T)> {
  /// Apply the arg [arg] to [this] [Function] only in case both the arg and
  /// Function are available.
  Either<E, U> apply(Either<E, T> arg) => arg.liftEither<T, U, E>(this, arg);

  /// Apply the arg [arg] to [this] [Function] only in case both the arg and
  /// Function are available.
  ///
  /// Behaves like a compose right operator.
  Either<E, U> operator >>(Either<E, T> arg) => apply(arg);
}
