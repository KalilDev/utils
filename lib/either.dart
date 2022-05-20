import 'dart:async';

import 'maybe.dart';
import 'type.dart';
import 'src/either.dart';
export 'src/either.dart';

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
            left: (r.first as List<A>).add,
            right: (r.last as List<B>).add,
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
