import 'package:adt_annotation_base/adt_annotation_base.dart';

import '../type.dart';
part 'maybe.g.dart';

T _identity<T>(T v) => v;

@data(
    #Maybe,
    [Tp(#t)],
    Union({
      #Just: {
        #_value: T(#t),
      },
      #None: {},
    }),
    mixin: [
      T(#_MaybeMonadOps, args: [T(#t)]),
      T(#_MaybeExtraOps, args: [T(#t)]),
    ])

/// An opaque representation of either an value ([Just]) or the abscence of one
/// ([None]), while not allowing to grab it directly.
///
/// For an efective usage of this wrapped values, use [fmap] and [bind] to
/// perform multiple operations, and [valueOr], [valueOrGet] or [visit] for
/// using the value.
///
/// Using the native 'is' operator can be used for checking if [this] is [None],
/// but it's usage results in the arrow anti-pattern.
const Type _maybe = Maybe;
mixin _MaybeMonadOps<T> implements Monad<T> {
  Maybe<T> get _self => this as Maybe<T>;

  @override
  Maybe<T1> pure<T1>(T1 value) => Maybe<T1>.just(value);

  @override
  Maybe<T1> unit<T1>(T1 value) => Maybe<T1>.just(value);

  /// Executes an mapping operation in case an value is present and wraps it
  /// with [Just], otherwise returns [None].
  @Deprecated('Use fmap')
  Maybe<T1> map<T1>(T1 Function(T) f) => fmap<T1>(f);
  @override
  Maybe<B> fmap<B>(B Function(T p1) fn) => _self.visit<Maybe<B>>(
        just: (v) => Just<B>(fn(v)),
        none: () => None<B>(),
      );

  /// Executes an mapping operation which is partial in case an value is present
  /// and flattens the result into a single [Maybe].
  @override
  Maybe<T1> bind<T1>(Maybe<T1> Function(T) f) => _self.visit<Maybe<T1>>(
        just: f,
        none: () => None<T1>(),
      );

  @override
  Maybe<B> lift<A, B>(Maybe<B Function(A)> fn, Maybe<A> a) =>
      fn.bind<B>((fn) => a.fmap((a) => fn(a)));
}
mixin _MaybeExtraOps<T> {
  Maybe<T> get _self => this as Maybe<T>;

  /// In case theres a value, keep it in case the [predicate] is [true],
  /// otherwise return [None].
  @Deprecated('Use where, as it matches the function on Iterable')
  Maybe<T> filter(bool Function(T) predicate /*!*/) => where(predicate);

  /// In case theres a value, keep it in case the [predicate] is [true],
  /// otherwise return [None].
  Maybe<T> where(bool Function(T) predicate /*!*/) => _self.visit<Maybe<T>>(
        just: (v) => predicate(v) ? _self : None<T>(),
        none: () => _self,
      );

  /// In case this is [None], add the [value], resulting in a [Just], otherwise
  /// keep the current value.
  Maybe<T> fillWhenNone(T value) =>
      _self.visit<Maybe<T>>(just: (_) => _self, none: () => Just(value));

  /// In case this is [None], return [other], otherwise keep the current value.
  Maybe<T> maybeFill(Maybe<T> other) =>
      _self.visit<Maybe<T>>(just: (_) => _self, none: () => other);

  /// In case there is a value, retrieve it, otherwise return the [orElse]
  /// value.
  @Deprecated('Use valueOr instead')
  T valueOrElse(T orElse) => valueOrGet(() => orElse);

  /// In case there is a value, retrieve it, otherwise return the [orElse]
  /// value.
  T valueOr(T orElse) => valueOrGet(() => orElse);

  /// In case there is a value, retrieve it, otherwise return the result of the
  /// [get] callback.
  T valueOrGet(T Function() get) => _self.visit<T>(just: _identity, none: get);

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
  Maybe<T1> cast<T1>() => _self.fmap<T1>((v) => v as T1);

  /// Convert this [Maybe] to an [List], with [None] being an empty list and
  /// Just being an list that contains just the value.
  List<T> toList() => _self.visit(
        just: (v) => <T>[v],
        none: () => <T>[],
      );
}
