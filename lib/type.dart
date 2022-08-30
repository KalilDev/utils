library kalil_utils.type;

import 'package:collection/collection.dart';

export 'tuple.dart';

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

// Required for cases where T? cannot be used, for example, type literals
typedef Nullable<T> = T?;
