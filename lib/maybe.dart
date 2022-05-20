library utils.maybe;

import 'package:meta/meta.dart';
import 'either.dart';
import 'type.dart';

import 'src/maybe.dart';
export 'src/maybe.dart';

/// Extension for catamorphing an Iterable of [Maybe]s discarding [None]s.
extension MaybeIterableCatamorph<T> on Iterable<Maybe<T>> {
  /// Catamorph an iterable of [Maybe<T>]s into an iterable of [T], keeping the
  /// [Just] values and discarding the [None] values.
  Iterable<T> cataMaybes() => expand((e) => e.toList());
}

/// Extension for traversing any iterable and using [Maybe] to represent the
/// result.
extension MaybeIterableTraverse<T> on Iterable<T> {
  /// Traverses an iterable trying to map the elements with [tryMap], returning
  /// [None] if either the iterable was empty or the result of every mapping
  /// operation was [None].
  @Deprecated('Use mapMaybe')
  Maybe<List<U>> traverse<U>(Maybe<U> Function(T) tryMap) => mapMaybe(tryMap);

  /// Traverses an iterable trying to map the elements with [tryMap], returning
  /// [None] if either the iterable was empty or the result of every mapping
  /// operation was [None].
  Maybe<List<U>> mapMaybe<U>(Maybe<U> Function(T) tryMap) {
    final results = expand((e) => tryMap(e).toList());
    return results.isEmpty ? None<List<U>>() : Just(results.toList());
  }
}

extension MaybeFunctionApply<U, T> on U Function(T) {
  Maybe<U> apply(Maybe<T> arg) => arg.lift(just, arg);
  Maybe<U> operator >>(Maybe<T> arg) => apply(arg);
}

extension MaybeFunctionReturn1<U, T> on U Function(T) {
  Maybe<U> Function(T) get ret => (v) => Just(this(v));
}

/// Extension on [Maybe] [Function]s for applying them.
extension MaybeApply<U, T> on Maybe<U Function(T)> {
  /// Apply the arg [arg] to [this] [Function] only in case both the arg and
  /// Function are available.
  ///
  /// Example: ```dart
  /// void Function(String b) concatAndPrint(String a) => (b) => print(a + b);
  ///
  /// void main() {
  ///   final maybeA = 'Hello '.just;
  ///   final maybeB = 'World'.just;
  ///   final none = None<String>();
  ///   // Prints 'Hello World'
  ///   concatAndPrint.just.apply(maybeA).apply(maybeB);
  ///   // Returns None<void>
  ///   concatAndPrint.just.apply(maybeA).apply(none);
  /// }
  /// ```
  Maybe<U> apply(Maybe<T> arg) => arg.lift(this, arg);

  /// Apply the arg [arg] to [this] [Function] only in case both the arg and
  /// Function are available.
  ///
  /// Behaves like a compose right operator.
  ///
  /// Example: ```dart
  /// void Function(String b) concatAndPrint(String a) => (b) => print(a + b);
  ///
  /// void main() {
  ///   final maybeA = 'Hello '.just;
  ///   final maybeB = 'World'.just;
  ///   final none = None<String>();
  ///   // Prints 'Hello World'
  ///   concatAndPrint.just >> maybeA >> maybeB;
  ///   // Returns None<void>
  ///   concatAndPrint.just >> maybeA >> none;
  /// }
  /// ```
  Maybe<U> operator >>(Maybe<T> arg) => apply(arg);
}

// Extension for Maybe of nullable types
extension MaybeNullableE<T extends Object> on Maybe<T?> {
  /// In case theres a value, keep it only if it is not [null], otherwise
  /// return [None].
  Maybe<T> whereNotNull() => where((e) => e != null).cast();

  /// In case theres a value, keep it only if it is not [null], otherwise
  /// return [None].
  @Deprecated('Use whereNotNull, as it has an better name')
  Maybe<T> filterNonNullable() => whereNotNull();
}

// Extension for Maybe of non nullable types
extension MaybeNonNullableE<T extends Object> on Maybe<T> {
  /// Transforms [null] into [None]

  /// In case theres a value, keep it only if it is not [null], otherwise
  /// return [None].
  @Deprecated('Deprecated for non nullable types!')
  Maybe<T> whereNotNull() => this;

  /// In case theres a value, keep it only if it is not [null], otherwise
  /// return [None].
  @Deprecated('Use whereNotNull, as it has an better name')
  @Deprecated('Deprecated for non nullable types!')
  Maybe<T> filterNonNullable() => this;
}

// Extension for nullable types
extension MaybeNullableWrapping<T extends Object> on T? {
  /// Wrap [this] into an [Maybe<T>] with [null] representing [None].
  Maybe<T> get maybe => this == null ? None() : Just(this!);

  /// Wrap [this] with an [Just<T>].
  Maybe<T?> get just => Just<T?>(this);

  /// Maybe cast [this] as [T1], returning [None] in case of an invalid cast.
  Maybe<T1> maybeAs<T1>() => this is T1 ? Just<T1>(this as T1) : None<T1>();
}

// Extension for non nullable types
extension MaybeNonNullWrapping<T extends Object> on T {
  /// Wrap [this] into an [Maybe<T>] with [null] representing [None].
  @Deprecated('Deprecated for non nullable types! use just instead')
  Maybe<T> get maybe => Just(this);

  /// Wrap [this] with an [Just<T>].
  Maybe<T> get just => Just<T>(this);

  /// Maybe cast [this] as [T1], returning [None] in case of an invalid cast.
  Maybe<T1> maybeAs<T1>() => this is T1 ? Just<T1>(this as T1) : None<T1>();
}

// Extension for nullable and non nullable types
extension MaybeNullabeWrapping<T extends Object> on T? {
  /// Maybe cast [this] as [T1], returning [None] in case of an invalid cast.
  Maybe<T1> maybeAs<T1>() => this is T1 ? Just<T1>(this as T1) : None<T1>();
}

extension MaybeObjectWrapping<T extends Object> on T? {}

extension EitherToMaybe<T> on Either<Object, T> {
  Maybe<T> toMaybe() {
    return visit<Maybe<T>>(
      left: (Object _) => None<T>(),
      right: (r) => Just<T>(r),
    );
  }
}

T _identity<T>(T v) => v;
