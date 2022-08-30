library kalil_utils.type;

import 'package:collection/collection.dart';

export 'tuple.dart';

/// An monoid in the Category of Endofunctors. An abstraction that allows
/// structuring programs generically.
///
/// An [Monad] type is an type which:
/// * Has an single binary operation in the form of [bind], in which the result
///   is another [Monad] of the same type. (is a Magma)
/// * The binary operation has an [identity], which results in itself and has
///   the associative property. (is an Monoid)
/// * Can map (with [fmap<B>]) values from one category ([Monad<A>]) to another
///   category ([Monad<B>]). (is a Functor)
/// * Maps from one category, [Monad], to the same category, [Monad], in [fmap].
///   (is an Endofunctor)
/// * Additionally, it has [pure] and [lift] capability. (is an Applicative
///   functor)
abstract class Monad<A> implements Applicative<A> {
  const Monad();

  // Constructors

  /// Wraps the [value] with this [Monad] type.
  Monad<T> unit<T>(T value);

  /// The composition operation, which [fmap]s the value into an
  /// [Monad<Monad<B>>] value, and unwraps into an [Monad<B>], allowing for a
  /// pipeline of operations.
  Monad<B> bind<B>(covariant Monad<B> Function(A) fn);

  // Functor

  /// Maps the value contained in this [Monad] from [A] to [B] with [fn] and
  /// wraps the result in [Monad<B>].
  @override
  Monad<B> fmap<B>(B Function(A) fn);

  // Applicative

  @override
  Monad<T> pure<T>(T value) => unit<T>(value);
  @override
  Monad<B> lift<A1, B>(Monad<B Function(A1)> fn, Monad<A1> a);
}

/// An base class for classes which that represent an sum ( | ) or
/// product ( * ) type.
/// This DOES NOT provide any guarantees or safety, it only exists
/// for pretty printing and documentation!!
abstract class CompositeType {
  const CompositeType._();

  @override
  CompositeRuntimeType get runtimeType;
}

/// An base class for classes which that represent an sum ( | ) type.
abstract class SumType implements CompositeType {
  const SumType._();

  @override
  SumRuntimeType get runtimeType;
}

/// An base class for classes which that represent an sum ( | ) type.
abstract class ProductType implements CompositeType {
  const ProductType._();

  @override
  ProductRuntimeType get runtimeType;
}

/// An [Type] object which represents an either an sum ( | ) type
/// or an product ( * ) type.
/// This DOES NOT provide any guarantees or safety, it only exists
/// for pretty printing reasons!!
class CompositeRuntimeType<Self extends CompositeRuntimeType<Self>>
    implements Type {
  const CompositeRuntimeType._(this.arguments);

  final List<Type> arguments;

  static const _typeListEq = ListEquality<Type>();

  @override
  int get hashCode => _typeListEq.hash(arguments);

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is Self && _typeListEq.equals(arguments, other.arguments);

  @override
  String toString([String? op]) => arguments
      .map((e) => e is CompositeRuntimeType ? '($e)' : e.toString())
      .join(' $op ');
}

/// An [Type] object which represents an sum ( | ) type.
class SumRuntimeType extends CompositeRuntimeType<SumRuntimeType> {
  const SumRuntimeType(List<Type> options) : super._(options);

  @override
  String toString([String? nop]) => super.toString('|');
}

/// An [Type] object which represents an product ( * ) type.
class ProductRuntimeType extends CompositeRuntimeType<ProductRuntimeType> {
  const ProductRuntimeType(List<Type> options) : super._(options);

  @override
  String toString([String? nop]) => super.toString('*');
}

/// An [Functor] type is an type which can map (with [fmap<B>]) values from one
/// category ([Functor<A>]) to another category ([Functor<B>]).
///
/// Tecnically, as the [Functor] type wraps the value, this is an Endofunctor,
/// because it maps values from the same category ([Functor]).
abstract class Functor<A> {
  /// Maps the value contained in this [Functor] from the category [A] to the
  /// category [B] with [fn] and wraps the result inside an [Functor<B>].
  Functor<B> fmap<B>(B Function(A) fn);
}

/// An [Applicative] [Functor] is an intermediate structure between [Functor]s
/// and [Monad]s.
///
/// They allow for functorial computations to be sequenced (unlike plain
/// [Functor]s), but don't allow using results from prior computations in the
/// definition of subsequent ones (unlike [Monad]s).
///
/// This happens with the hability to wrap values in an [Applicative] with
/// [pure], and then to [lift] mappings to the context of a [Applicative].
///
/// Every implementer should create it's own [ApplicativeApply] extension!!
abstract class Applicative<A> implements Functor<A> {
  /// Wraps the [value] inside a [Applicative<T>]
  Applicative<T> pure<T>(T value);

  /// Perform the operation [fn] with the value in [a] and wrap with
  /// [Applicative<B>] for pipelining.
  Applicative<B> lift<A1, B>(
    covariant Applicative<B Function(A1)> fn,
    covariant Applicative<A1> a,
  );

  @override
  Applicative<B> fmap<B>(B Function(A) fn);
}

/// The [apply] operation for an [B Function(A)].
extension ApplicativeFnApply<A, B> on B Function(A) {
  /// Equivalent to `f <$> a`.
  Applicative<B> apply(Applicative<A> a) => a.fmap(this);

  /// Equivalent to `f <$> a`.
  Applicative<B> operator >>(Applicative<A> a) => apply(a);
}

/// The [apply] operation for an [Applicative<B Function(A)>].
///
/// Should be shadowed by every [Applicative] type!
extension ApplicativeApply<A, B> on Applicative<B Function(A)> {
  /// Equivalent to `f <*> a`
  Applicative<B> apply(Applicative<A> a) => a.lift<A, B>(this, a);

  /// Equivalent to `f <*> a`
  Applicative<B> operator >>(Applicative<A> a) => apply(a);
}

/// An [BiFunctor] type is an type which can map values from two categories into
/// two others.
abstract class BiFunctor<A, B> {
  /// Map the left [A] value into an [A1] with the [fn] mapper, while keeping
  /// the right value untouched.
  BiFunctor<A1, B> first<A1>(A1 Function(A) fn);

  /// Map the right [B] value into an [B1] with the [fn] mapper, while keeping
  /// the left value untouched.
  BiFunctor<A, B1> second<B1>(B1 Function(B) fn);

  /// Map the values [A] to [A1] and [B] to [B1] with the [a] and [b] mappers,
  /// respectively.
  BiFunctor<A1, B1> bimap<A1, B1>({
    required A1 Function(A) a,
    required B1 Function(B) b,
  });
}
