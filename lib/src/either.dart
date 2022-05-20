import 'package:adt_annotation/adt_annotation.dart';

import '../maybe.dart';
import '../type.dart' hide Either, Left, Right;
part 'either.g.dart';

T _identity<T>(T v) => v;
T _notNull<T>(T? v) => ArgumentError.checkNotNull(v);

@data(
    #Either,
    [Tp(#a), Tp(#b)],
    Union({
      #Left: {
        #_value: T(#a),
      },
      #Right: {
        #_value: T(#b),
      },
    }),
    mixin: [
      T(#_EitherMonadOps, [T(#a), T(#b)]),
      T(#_EitherBiFunctorOps, [T(#a), T(#b)]),
      T(#_EitherExtraOps, [T(#a), T(#b)]),
    ])

/// An [Monad<B>] which contains either an [Left<A>] value or an [Right<B>]
/// value and performs the [bind] and [fmap] on the [Right] value.
///
/// The [Right] one is used in the [Functor], [Applicative] and [Monad]
/// operations because mnemonically "right" also means "correct".
///
/// Normally, an function that may fail may return an [Either]<[Exception], T>.
const Type _either = Either;

mixin _EitherBiFunctorOps<a, b> implements BiFunctor<a, b> {
  Either<a, b> get _self => this as Either<a, b>;

  @override
  Either<A1, b> first<A1>(A1 Function(a) fn) =>
      bimap<A1, b>(a: fn, b: _identity);

  @override
  Either<a, B1> second<B1>(B1 Function(b) fn) =>
      bimap<a, B1>(a: _identity, b: fn);

  @override
  Either<A1, B1> bimap<A1, B1>({
    required A1 Function(a) a,
    required B1 Function(b) b,
  }) =>
      _self.visit<Either<A1, B1>>(
        left: (v) => Left<A1, B1>(a(v)),
        right: (v) => Right<A1, B1>(b(v)),
      );
}
mixin _EitherMonadOps<a, b> implements Monad<b> {
  Either<a, b> get _self => this as Either<a, b>;

  @override
  Either<a, T> pure<T>(T value) => Right(value);

  @override
  Either<a, T> unit<T>(T value) => Right(value);

  /// Map the right value [B] into an [Either<A, B1>], while keeping
  /// the left value untouched.
  Either<a, B1> fmap<B1>(B1 Function(b p1) fn) => _self.second(fn);

  /// Flat map the right value [B] into an [Either<A, B1>], while keeping
  /// the left value untouched.
  @override
  Either<a, B1> bind<B1>(Either<a, B1> Function(b) fn) => _self.visit(
        left: (v) => Left<a, B1>(v),
        right: _notNull(fn),
      );

  @override
  Either<Exception, B> lift<A, B>(
          Either<Exception, B Function(A)> fn, Either<Exception, A> a) =>
      fn.bind<B>((fn) => a.fmap((a) => fn(a)));
}
mixin _EitherExtraOps<a, b> {
  Either<a, b> get _self => this as Either<a, b>;

  /// Handle the right value with [right] and return the left [A] value.
  a getL(a Function(b) right) => _self.visit(left: _identity, right: right);

  /// Handle the left value with [left] and return the right [B] value.
  b getR(b Function(a) left) => _self.visit(left: left, right: _identity);

  /// [Maybe] return the [Left] value, returning [None] in case [this] is
  /// [Right]
  Maybe<a> get maybeLeft =>
      _self.visit(left: Maybe.just, right: (_) => Maybe.none());

  /// [Maybe] return the [Right] value, returning [None] in case [this] is
  /// [Left]
  Maybe<b> get maybeRight =>
      _self.visit(left: (_) => Maybe.none(), right: Maybe.just);

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

  Either<b, a> swap() => _self.visit(left: Right.new, right: Left.new);
}
