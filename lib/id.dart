import 'type.dart';

/// An [Monad<A>] which embodies no computational strategy. Useful for
/// performing monadic composition operations on values, and for retrieving the
/// regular monad version of an monad transformer.
class Id<A> extends Monad<A> {
  const factory Id(A value) = Id._;
  const Id._(this._value);
  final A _value;

  /// Construct an [Id] with [value]
  static Id<A> ret<A>(A value) => Id(value);

  @override
  Id<A1/*!*/> identity<A1>([A1/*!*/ value]) => Id<A1/*!*/>(value);

  @override
  Id<A1> unit<A1>(A1 value) => Id(value);

  @override

  /// Map the right value [B] into an [Either<A, B1>], while keeping
  /// the left value untouched.
  Id<B> fmap<B>(B Function(A) fn) => Id<B>(fn(_value));

  /// Flat map the right value [B] into an [Either<A, B1>], while keeping
  /// the left value untouched.
  @override
  Id<B> bind<B>(Id<B> Function(A) fn) => fn(_value);

  /// Unraps this [Id<A>] into an [A]
  A unwrap() => _value;

  @override
  Id<B1> lift<A1, B1>(
    Id<B1 Function(A1)> fn,
    Id<A1> a,
  ) =>
      fn.bind((fn) => a.fmap(fn));
}

extension ToId<T> on T {
  Id<T> get id => Id<T>(this);
}

/// Extension on [Id] [Function]s for applying them.
extension IdApply<A, B> on Id<B Function(A)> {
  /// Apply the arg [arg] to [this] [Function] only in case both the arg and
  /// Function are available.
  Id<B> apply(Id<A> arg) => arg.lift<A, B>(this, arg);

  /// Apply the arg [arg] to [this] [Function] only in case both the arg and
  /// Function are available.
  ///
  /// Behaves like a compose right operator.
  Id<B> operator >>(Id<A> arg) => apply(arg);
}
