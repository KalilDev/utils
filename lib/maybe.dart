library utils.maybe;

import 'package:meta/meta.dart';
import 'either.dart';
import 'type.dart';

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

/// Extensions on [Object] for seamless usage with [Maybe<T>].
extension MaybeObjectWrapping<T> on T {
  /// Wrap [this] into an [Maybe<T>] with [null] representing [None].
  Maybe<T> get maybe => Maybe.fromNullable<T>(this);

  /// Wrap [this] with an [Just<T>].
  Maybe<T> get just => Just<T>(this);

  /// Maybe cast [this] as [T1], returning [None] in case of an invalid cast.
  Maybe<T1> maybeAs<T1>() => this is T1 ? Just<T1>(this as T1) : None<T1>();
}

extension EitherToMaybe<T> on Either<Object, T> {
  Maybe<T> toMaybe() {
    return visit<Maybe<T>>(
      a: (Object _) => None<T>(),
      b: (r) => Just<T>(r),
    );
  }
}

T _identity<T>(T v) => v;

/// An opaque representation of either an value ([Just]) or the abscence of one
/// ([None]), while not allowing to grab it directly.
///
/// For an efective usage of this wrapped values, use [fmap] and [bind] to
/// perform multiple operations, and [valueOr], [valueOrGet] or [visit] for
/// using the value.
///
/// Using the native 'is' operator can be used for checking if [this] is [None],
/// but it's usage results in the arrow anti-pattern.
abstract class Maybe<T> extends Monad<T> {
  /// Create only an private constructor so that no classes other than [None]
  /// and [Just] can extend [Maybe].
  const Maybe._();

  /// Wrap [value] with an [Just<T>].
  static Maybe<T> just<T>(T value) => Just<T>(value);

  @override
  Maybe<T1> unit<T1>(T1 value) => Maybe.just<T1>(value);

  /// Create an [None<T>].
  static Maybe<T> none<T>() => None<T>();

  /// Construct an non nullable [Maybe] from an nullable value, with [null]
  /// representing [None].
  static Maybe<T> fromNullable<T>(T? value) {
    return value == null ? None<T>() : Just<T>(value);
  }

  /// Construct an non nullable [Maybe] from the result of an synchronous
  /// operation, with [null] or [Exception]s representing [None].
  static Maybe<T> fromOperation<T>(T? Function() operation) {
    try {
      return Maybe.fromNullable<T>(operation());
    } on Exception {
      return None<T>();
    }
  }

  /// Construct an nullable [Maybe] from the result of an synchronous operation,
  /// with only [Exception]s representing [None].
  static Maybe<T?> nullableFromOperation<T>(
    T? Function() operation,
  ) {
    try {
      return Just<T?>(operation());
    } on Exception {
      return None<T>();
    }
  }

  /// Construct an non nullable [Maybe] from the result of an asynchronous
  /// operation, with [null] or [Exception]s representing [None].
  ///
  /// [Error]s and [Object]s are deliberately not catched. If the user wants to
  /// have behavior attached to these, he should reimplement this function.
  static Future<Maybe<T>> fromAsyncOperation<T>(
    Future<T?> Function() operation,
  ) async {
    try {
      return Maybe.fromNullable<T>(await operation());
    } on Exception {
      return None<T>();
    }
  }

  /// Construct an nullable [Maybe] from the result of an asynchronous
  /// operation, with only [Exception]s representing [None].
  ///
  /// [Error]s and [Object]s are deliberately not catched. If the user wants to
  /// have behavior attached to these, he should reimplement this function.
  static Future<Maybe<T?>> nullableFromAsyncOperation<T>(
    Future<T?> Function() operation,
  ) async {
    try {
      return Just<T?>(await operation());
    } on Exception {
      return None<T>();
    }
  }

  /// Executes an mapping operation in case an value is present and wraps it
  /// with [Just], otherwise returns [None].
  @Deprecated('Use fmap')
  Maybe<T1> map<T1>(T1 Function(T) f) => fmap<T1>(f);

  @override
  Maybe<B> fmap<B>(B Function(T p1) fn) => visit<Maybe<B>>(
        just: (v) => just<B>(fn(v)),
        none: () => none<B>(),
      );

  /// Executes an mapping operation which is partial in case an value is present
  /// and flattens the result into a single [Maybe].
  @override
  Maybe<T1> bind<T1>(Maybe<T1> Function(T) f) => visit<Maybe<T1>>(
        just: f,
        none: () => none<T1>(),
      );

  /// In case theres a value, keep it in case the [predicate] is [true],
  /// otherwise return [None].
  @Deprecated('Use where, as it matches the function on Iterable')
  Maybe<T> filter(bool Function(T) predicate /*!*/) => where(predicate);

  /// In case theres a value, keep it in case the [predicate] is [true],
  /// otherwise return [None].
  Maybe<T> where(bool Function(T) predicate /*!*/) => visit<Maybe<T>>(
        just: (v) => predicate(v) ? this : none<T>(),
        none: () => this,
      );

  /// In case theres a value, keep it only if it is not [null], otherwise
  /// return [None].
  @Deprecated('Use whereNotNull, as it has an better name')
  Maybe<T> filterNonNullable() => whereNotNull();

  /// In case theres a value, keep it only if it is not [null], otherwise
  /// return [None].
  Maybe<T> whereNotNull() => where((v) => v != null);

  /// In case this is [None], add the [value], resulting in a [Just], otherwise
  /// keep the current value.
  Maybe<T> fillWhenNone(T value) =>
      visit<Maybe<T>>(just: (_) => this, none: () => just(value));

  /// In case this is [None], return [other], otherwise keep the current value.
  Maybe<T> maybeFill(Maybe<T> other) =>
      visit<Maybe<T>>(just: (_) => this, none: () => other);

  /// In case there is a value, retrieve it, otherwise return the [orElse]
  /// value.
  @Deprecated('Use valueOr instead')
  T valueOrElse(T orElse) => valueOrGet(() => orElse);

  /// In case there is a value, retrieve it, otherwise return the [orElse]
  /// value.
  T valueOr(T orElse) => valueOrGet(() => orElse);

  /// In case there is a value, retrieve it, otherwise return the result of the
  /// [get] callback.
  T valueOrGet(T Function() get) => visit<T>(just: _identity, none: get);

  /// Apply the visitor callbacks for the respective type if they are present.
  T1 visit<T1>({required T1 Function(T) just, required T1 Function() none});

  @override
  Maybe<B> lift<A, B>(Maybe<B Function(A)> fn, Maybe<A> a) =>
      fn.bind<B>((fn) => a.fmap((a) => fn(a)));

  /// Cast this [Maybe<T>] into an [Maybe<T1>], throwing an [TypeError] if not
  /// possible.
  ///
  /// This should be used only in cases where variance would get messed up, for
  /// example: ```
  /// abstract class A {}
  ///
  /// class B extends A {
  ///   B getB() => this;
  /// }
  ///
  /// class C extends A {}
  ///
  /// A function(A a) => (a is B ? a.getB().just : None<C>()).valueOr(a);
  /// ```
  /// In this case the code would compile but not run.
  ///
  /// So, this is needed:
  /// ```A function(A a) =>
  ///      (a is B ? a.getB().just : None<C>()).cast().valueOr(a);```
  Maybe<T1> cast<T1>() => fmap<T1>((v) => v as T1);

  /// Convert this [Maybe] to an [List], with [None] being an empty list and
  /// Just being an list that contains just the value.
  List<T> toList() => visit(
        just: (v) => <T>[v],
        none: () => <T>[],
      );
}

/// An [Maybe] type that represents an value. It cannot be retrieved directly.
@immutable
class Just<T> extends Maybe<T> {
  /// Construct an [Just] with an value.
  const Just(this._value) : super._();

  final T _value;

  @override
  String toString() => 'Just<$T> $_value';

  @override
  int get hashCode {
    var hash = 7;
    hash = 31 * hash + runtimeType.hashCode;
    hash = 31 * hash + _value.hashCode;
    return hash;
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Just<T>) {
      return other._value == _value;
    }
    return false;
  }

  @override
  T1 visit<T1>(
          {required T1 Function(T p1) just, required T1 Function() none}) =>
      just.call(_value);
}

/// An [Maybe] type that represents the abscence of an value.
@immutable
class None<T> extends Maybe<T> {
  /// Construct an [None] value.
  const None() : super._();

  @override
  String toString() => 'None<$T>';

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  bool operator ==(dynamic other) => other is None<T>;

  @override
  T1 visit<T1>(
          {required T1 Function(T p1) just, required T1 Function() none}) =>
      none.call();
}
