library kalil_utils.tuple;

import 'type.dart';
import 'src/tuple.dart';
export 'src/tuple.dart';

T _identity<T>(T v) => v;

@Deprecated('Use either an generated tuple or Tuple`N`')
class Tuple<A, B> = Tuple2<A, B> with _DeprecatedTupleStuff<A, B>;
mixin _DeprecatedTupleStuff<A, B> implements BiFunctor<A, B> {
  A get left => (this as Tuple2<A, B>).e0;
  B get right => (this as Tuple2<A, B>).e1;

  @override
  Tuple<A1, B1> bimap<A1, B1>({
    required A1 Function(A) a,
    required B1 Function(B) b,
  }) =>
      Tuple(a(left), b(right));

  @override
  Tuple<A1, B> first<A1>(A1 Function(A) fn) => bimap(a: fn, b: _identity);

  @override
  Tuple<A, B1> second<B1>(B1 Function(B p1) fn) => bimap(a: _identity, b: fn);
  T visit<T>(T Function(A, B) fn) => fn(left, right);

  Tuple<B, A> swap() => Tuple(right, left);
}
