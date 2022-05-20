// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuple.dart';

// **************************************************************************
// AdtGenerator
// **************************************************************************

class Tuple0 with TupleN0 implements ProductType {
  const Tuple0() : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([]);

  @override
  int get hashCode => (Tuple0).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is Tuple0 && true);

  @override
  String toString() => "Tuple0 ()";
}

class Tuple1<E0 extends Object?> with TupleN1<E0> implements ProductType {
  final E0 e0;

  const Tuple1(this.e0) : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([E0]);

  @override
  int get hashCode => Object.hash((Tuple1), E0, e0);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple1<E0> && true && this.e0 == other.e0);

  @override
  String toString() => "Tuple1<$E0> ($e0)";
}

class Tuple2<E0 extends Object?, E1 extends Object?>
    with TupleN2<E0, E1>
    implements ProductType {
  final E0 e0;
  final E1 e1;

  const Tuple2(this.e0, this.e1) : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([E0, E1]);

  @override
  int get hashCode => Object.hash((Tuple2), E0, E1, e0, e1);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple2<E0, E1> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1);

  @override
  String toString() => "Tuple2<$E0,$E1> ($e0, $e1)";
}

class Tuple3<E0 extends Object?, E1 extends Object?, E2 extends Object?>
    with TupleN3<E0, E1, E2>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;

  const Tuple3(this.e0, this.e1, this.e2) : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([E0, E1, E2]);

  @override
  int get hashCode => Object.hash((Tuple3), E0, E1, E2, e0, e1, e2);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple3<E0, E1, E2> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2);

  @override
  String toString() => "Tuple3<$E0,$E1,$E2> ($e0, $e1, $e2)";
}

class Tuple4<E0 extends Object?, E1 extends Object?, E2 extends Object?,
    E3 extends Object?> with TupleN4<E0, E1, E2, E3> implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;

  const Tuple4(this.e0, this.e1, this.e2, this.e3) : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([E0, E1, E2, E3]);

  @override
  int get hashCode => Object.hash((Tuple4), E0, E1, E2, E3, e0, e1, e2, e3);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple4<E0, E1, E2, E3> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3);

  @override
  String toString() => "Tuple4<$E0,$E1,$E2,$E3> ($e0, $e1, $e2, $e3)";
}

class Tuple5<E0 extends Object?, E1 extends Object?, E2 extends Object?,
        E3 extends Object?, E4 extends Object?>
    with TupleN5<E0, E1, E2, E3, E4>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;

  const Tuple5(this.e0, this.e1, this.e2, this.e3, this.e4) : super();

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([E0, E1, E2, E3, E4]);

  @override
  int get hashCode =>
      Object.hash((Tuple5), E0, E1, E2, E3, E4, e0, e1, e2, e3, e4);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple5<E0, E1, E2, E3, E4> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4);

  @override
  String toString() => "Tuple5<$E0,$E1,$E2,$E3,$E4> ($e0, $e1, $e2, $e3, $e4)";
}

class Tuple6<E0 extends Object?, E1 extends Object?, E2 extends Object?,
        E3 extends Object?, E4 extends Object?, E5 extends Object?>
    with TupleN6<E0, E1, E2, E3, E4, E5>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;

  const Tuple6(this.e0, this.e1, this.e2, this.e3, this.e4, this.e5) : super();

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([E0, E1, E2, E3, E4, E5]);

  @override
  int get hashCode =>
      Object.hash((Tuple6), E0, E1, E2, E3, E4, E5, e0, e1, e2, e3, e4, e5);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple6<E0, E1, E2, E3, E4, E5> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5);

  @override
  String toString() =>
      "Tuple6<$E0,$E1,$E2,$E3,$E4,$E5> ($e0, $e1, $e2, $e3, $e4, $e5)";
}

class Tuple7<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?>
    with TupleN7<E0, E1, E2, E3, E4, E5, E6>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;

  const Tuple7(this.e0, this.e1, this.e2, this.e3, this.e4, this.e5, this.e6)
      : super();

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([E0, E1, E2, E3, E4, E5, E6]);

  @override
  int get hashCode => Object.hash(
      (Tuple7), E0, E1, E2, E3, E4, E5, E6, e0, e1, e2, e3, e4, e5, e6);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple7<E0, E1, E2, E3, E4, E5, E6> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6);

  @override
  String toString() =>
      "Tuple7<$E0,$E1,$E2,$E3,$E4,$E5,$E6> ($e0, $e1, $e2, $e3, $e4, $e5, $e6)";
}

class Tuple8<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?>
    with TupleN8<E0, E1, E2, E3, E4, E5, E6, E7>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;

  const Tuple8(
      this.e0, this.e1, this.e2, this.e3, this.e4, this.e5, this.e6, this.e7)
      : super();

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([E0, E1, E2, E3, E4, E5, E6, E7]);

  @override
  int get hashCode => Object.hash(
      (Tuple8), E0, E1, E2, E3, E4, E5, E6, E7, e0, e1, e2, e3, e4, e5, e6, e7);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple8<E0, E1, E2, E3, E4, E5, E6, E7> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7);

  @override
  String toString() =>
      "Tuple8<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7)";
}

class Tuple9<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?>
    with TupleN9<E0, E1, E2, E3, E4, E5, E6, E7, E8>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;

  const Tuple9(this.e0, this.e1, this.e2, this.e3, this.e4, this.e5, this.e6,
      this.e7, this.e8)
      : super();

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([E0, E1, E2, E3, E4, E5, E6, E7, E8]);

  @override
  int get hashCode => Object.hash((Tuple9), E0, E1, E2, E3, E4, E5, E6, E7, E8,
      e0, e1, e2, e3, e4, e5, e6, e7, e8);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple9<E0, E1, E2, E3, E4, E5, E6, E7, E8> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8);

  @override
  String toString() =>
      "Tuple9<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8)";
}

class Tuple10<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?>
    with TupleN10<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;

  const Tuple10(this.e0, this.e1, this.e2, this.e3, this.e4, this.e5, this.e6,
      this.e7, this.e8, this.e9)
      : super();

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([E0, E1, E2, E3, E4, E5, E6, E7, E8, E9]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple10),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple10<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9);

  @override
  String toString() =>
      "Tuple10<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9)";
}

class Tuple11<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?,
        E10 extends Object?>
    with TupleN11<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;
  final E10 e10;

  const Tuple11(this.e0, this.e1, this.e2, this.e3, this.e4, this.e5, this.e6,
      this.e7, this.e8, this.e9, this.e10)
      : super();

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple11),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9,
        e10
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple11<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9 &&
          this.e10 == other.e10);

  @override
  String toString() =>
      "Tuple11<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$E10> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $e10)";
}

class Tuple12<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?,
        E10 extends Object?,
        E11 extends Object?>
    with TupleN12<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;
  final E10 e10;
  final E11 e11;

  const Tuple12(this.e0, this.e1, this.e2, this.e3, this.e4, this.e5, this.e6,
      this.e7, this.e8, this.e9, this.e10, this.e11)
      : super();

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple12),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9,
        e10,
        e11
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple12<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9 &&
          this.e10 == other.e10 &&
          this.e11 == other.e11);

  @override
  String toString() =>
      "Tuple12<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$E10,$E11> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $e10, $e11)";
}

class Tuple13<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?,
        E10 extends Object?,
        E11 extends Object?,
        E12 extends Object?>
    with TupleN13<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;
  final E10 e10;
  final E11 e11;
  final E12 e12;

  const Tuple13(this.e0, this.e1, this.e2, this.e3, this.e4, this.e5, this.e6,
      this.e7, this.e8, this.e9, this.e10, this.e11, this.e12)
      : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType(
      [E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple13),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9,
        e10,
        e11,
        e12
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple13<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11,
              E12> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9 &&
          this.e10 == other.e10 &&
          this.e11 == other.e11 &&
          this.e12 == other.e12);

  @override
  String toString() =>
      "Tuple13<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$E10,$E11,$E12> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $e10, $e11, $e12)";
}

class Tuple14<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?,
        E10 extends Object?,
        E11 extends Object?,
        E12 extends Object?,
        E13 extends Object?>
    with TupleN14<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13>
    implements ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;
  final E10 e10;
  final E11 e11;
  final E12 e12;
  final E13 e13;

  const Tuple14(this.e0, this.e1, this.e2, this.e3, this.e4, this.e5, this.e6,
      this.e7, this.e8, this.e9, this.e10, this.e11, this.e12, this.e13)
      : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType(
      [E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple14),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9,
        e10,
        e11,
        e12,
        e13
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple14<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
              E13> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9 &&
          this.e10 == other.e10 &&
          this.e11 == other.e11 &&
          this.e12 == other.e12 &&
          this.e13 == other.e13);

  @override
  String toString() =>
      "Tuple14<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$E10,$E11,$E12,$E13> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $e10, $e11, $e12, $e13)";
}

class Tuple15<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?,
        E10 extends Object?,
        E11 extends Object?,
        E12 extends Object?,
        E13 extends Object?,
        E14 extends Object?>
    with
        TupleN15<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14>
    implements
        ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;
  final E10 e10;
  final E11 e11;
  final E12 e12;
  final E13 e13;
  final E14 e14;

  const Tuple15(
      this.e0,
      this.e1,
      this.e2,
      this.e3,
      this.e4,
      this.e5,
      this.e6,
      this.e7,
      this.e8,
      this.e9,
      this.e10,
      this.e11,
      this.e12,
      this.e13,
      this.e14)
      : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType(
      [E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple15),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        E14,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9,
        e10,
        e11,
        e12,
        e13,
        e14
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple15<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
              E13, E14> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9 &&
          this.e10 == other.e10 &&
          this.e11 == other.e11 &&
          this.e12 == other.e12 &&
          this.e13 == other.e13 &&
          this.e14 == other.e14);

  @override
  String toString() =>
      "Tuple15<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$E10,$E11,$E12,$E13,$E14> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $e10, $e11, $e12, $e13, $e14)";
}

class Tuple16<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?,
        E10 extends Object?,
        E11 extends Object?,
        E12 extends Object?,
        E13 extends Object?,
        E14 extends Object?,
        E15 extends Object?>
    with
        TupleN16<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14, E15>
    implements
        ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;
  final E10 e10;
  final E11 e11;
  final E12 e12;
  final E13 e13;
  final E14 e14;
  final E15 e15;

  const Tuple16(
      this.e0,
      this.e1,
      this.e2,
      this.e3,
      this.e4,
      this.e5,
      this.e6,
      this.e7,
      this.e8,
      this.e9,
      this.e10,
      this.e11,
      this.e12,
      this.e13,
      this.e14,
      this.e15)
      : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType(
      [E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple16),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        E14,
        E15,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9,
        e10,
        e11,
        e12,
        e13,
        e14,
        e15
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple16<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
              E13, E14, E15> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9 &&
          this.e10 == other.e10 &&
          this.e11 == other.e11 &&
          this.e12 == other.e12 &&
          this.e13 == other.e13 &&
          this.e14 == other.e14 &&
          this.e15 == other.e15);

  @override
  String toString() =>
      "Tuple16<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$E10,$E11,$E12,$E13,$E14,$E15> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $e10, $e11, $e12, $e13, $e14, $e15)";
}

class Tuple17<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?,
        E10 extends Object?,
        E11 extends Object?,
        E12 extends Object?,
        E13 extends Object?,
        E14 extends Object?,
        E15 extends Object?,
        E16 extends Object?>
    with
        TupleN17<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14, E15, E16>
    implements
        ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;
  final E10 e10;
  final E11 e11;
  final E12 e12;
  final E13 e13;
  final E14 e14;
  final E15 e15;
  final E16 e16;

  const Tuple17(
      this.e0,
      this.e1,
      this.e2,
      this.e3,
      this.e4,
      this.e5,
      this.e6,
      this.e7,
      this.e8,
      this.e9,
      this.e10,
      this.e11,
      this.e12,
      this.e13,
      this.e14,
      this.e15,
      this.e16)
      : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        E14,
        E15,
        E16
      ]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple17),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        E14,
        E15,
        E16,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9,
        e10,
        e11,
        e12,
        e13,
        e14,
        e15,
        e16
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple17<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
              E13, E14, E15, E16> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9 &&
          this.e10 == other.e10 &&
          this.e11 == other.e11 &&
          this.e12 == other.e12 &&
          this.e13 == other.e13 &&
          this.e14 == other.e14 &&
          this.e15 == other.e15 &&
          this.e16 == other.e16);

  @override
  String toString() =>
      "Tuple17<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$E10,$E11,$E12,$E13,$E14,$E15,$E16> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $e10, $e11, $e12, $e13, $e14, $e15, $e16)";
}

class Tuple18<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?,
        E10 extends Object?,
        E11 extends Object?,
        E12 extends Object?,
        E13 extends Object?,
        E14 extends Object?,
        E15 extends Object?,
        E16 extends Object?,
        E17 extends Object?>
    with
        TupleN18<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14, E15, E16, E17>
    implements
        ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;
  final E10 e10;
  final E11 e11;
  final E12 e12;
  final E13 e13;
  final E14 e14;
  final E15 e15;
  final E16 e16;
  final E17 e17;

  const Tuple18(
      this.e0,
      this.e1,
      this.e2,
      this.e3,
      this.e4,
      this.e5,
      this.e6,
      this.e7,
      this.e8,
      this.e9,
      this.e10,
      this.e11,
      this.e12,
      this.e13,
      this.e14,
      this.e15,
      this.e16,
      this.e17)
      : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        E14,
        E15,
        E16,
        E17
      ]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple18),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        E14,
        E15,
        E16,
        E17,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9,
        e10,
        e11,
        e12,
        e13,
        e14,
        e15,
        e16,
        e17
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple18<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
              E13, E14, E15, E16, E17> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9 &&
          this.e10 == other.e10 &&
          this.e11 == other.e11 &&
          this.e12 == other.e12 &&
          this.e13 == other.e13 &&
          this.e14 == other.e14 &&
          this.e15 == other.e15 &&
          this.e16 == other.e16 &&
          this.e17 == other.e17);

  @override
  String toString() =>
      "Tuple18<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$E10,$E11,$E12,$E13,$E14,$E15,$E16,$E17> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $e10, $e11, $e12, $e13, $e14, $e15, $e16, $e17)";
}

class Tuple19<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?,
        E10 extends Object?,
        E11 extends Object?,
        E12 extends Object?,
        E13 extends Object?,
        E14 extends Object?,
        E15 extends Object?,
        E16 extends Object?,
        E17 extends Object?,
        E18 extends Object?>
    with
        TupleN19<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14, E15, E16, E17, E18>
    implements
        ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;
  final E10 e10;
  final E11 e11;
  final E12 e12;
  final E13 e13;
  final E14 e14;
  final E15 e15;
  final E16 e16;
  final E17 e17;
  final E18 e18;

  const Tuple19(
      this.e0,
      this.e1,
      this.e2,
      this.e3,
      this.e4,
      this.e5,
      this.e6,
      this.e7,
      this.e8,
      this.e9,
      this.e10,
      this.e11,
      this.e12,
      this.e13,
      this.e14,
      this.e15,
      this.e16,
      this.e17,
      this.e18)
      : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        E14,
        E15,
        E16,
        E17,
        E18
      ]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple19),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        E14,
        E15,
        E16,
        E17,
        E18,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9,
        e10,
        e11,
        e12,
        e13,
        e14,
        e15,
        e16,
        e17,
        e18
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple19<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
              E13, E14, E15, E16, E17, E18> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9 &&
          this.e10 == other.e10 &&
          this.e11 == other.e11 &&
          this.e12 == other.e12 &&
          this.e13 == other.e13 &&
          this.e14 == other.e14 &&
          this.e15 == other.e15 &&
          this.e16 == other.e16 &&
          this.e17 == other.e17 &&
          this.e18 == other.e18);

  @override
  String toString() =>
      "Tuple19<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$E10,$E11,$E12,$E13,$E14,$E15,$E16,$E17,$E18> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $e10, $e11, $e12, $e13, $e14, $e15, $e16, $e17, $e18)";
}

class Tuple20<
        E0 extends Object?,
        E1 extends Object?,
        E2 extends Object?,
        E3 extends Object?,
        E4 extends Object?,
        E5 extends Object?,
        E6 extends Object?,
        E7 extends Object?,
        E8 extends Object?,
        E9 extends Object?,
        E10 extends Object?,
        E11 extends Object?,
        E12 extends Object?,
        E13 extends Object?,
        E14 extends Object?,
        E15 extends Object?,
        E16 extends Object?,
        E17 extends Object?,
        E18 extends Object?,
        E19 extends Object?>
    with
        TupleN20<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14, E15, E16, E17, E18, E19>
    implements
        ProductType {
  final E0 e0;
  final E1 e1;
  final E2 e2;
  final E3 e3;
  final E4 e4;
  final E5 e5;
  final E6 e6;
  final E7 e7;
  final E8 e8;
  final E9 e9;
  final E10 e10;
  final E11 e11;
  final E12 e12;
  final E13 e13;
  final E14 e14;
  final E15 e15;
  final E16 e16;
  final E17 e17;
  final E18 e18;
  final E19 e19;

  const Tuple20(
      this.e0,
      this.e1,
      this.e2,
      this.e3,
      this.e4,
      this.e5,
      this.e6,
      this.e7,
      this.e8,
      this.e9,
      this.e10,
      this.e11,
      this.e12,
      this.e13,
      this.e14,
      this.e15,
      this.e16,
      this.e17,
      this.e18,
      this.e19)
      : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        E14,
        E15,
        E16,
        E17,
        E18,
        E19
      ]);

  @override
  int get hashCode => Object.hashAll([
        (Tuple20),
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7,
        E8,
        E9,
        E10,
        E11,
        E12,
        E13,
        E14,
        E15,
        E16,
        E17,
        E18,
        E19,
        e0,
        e1,
        e2,
        e3,
        e4,
        e5,
        e6,
        e7,
        e8,
        e9,
        e10,
        e11,
        e12,
        e13,
        e14,
        e15,
        e16,
        e17,
        e18,
        e19
      ]);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Tuple20<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
              E13, E14, E15, E16, E17, E18, E19> &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2 &&
          this.e3 == other.e3 &&
          this.e4 == other.e4 &&
          this.e5 == other.e5 &&
          this.e6 == other.e6 &&
          this.e7 == other.e7 &&
          this.e8 == other.e8 &&
          this.e9 == other.e9 &&
          this.e10 == other.e10 &&
          this.e11 == other.e11 &&
          this.e12 == other.e12 &&
          this.e13 == other.e13 &&
          this.e14 == other.e14 &&
          this.e15 == other.e15 &&
          this.e16 == other.e16 &&
          this.e17 == other.e17 &&
          this.e18 == other.e18 &&
          this.e19 == other.e19);

  @override
  String toString() =>
      "Tuple20<$E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$E10,$E11,$E12,$E13,$E14,$E15,$E16,$E17,$E18,$E19> ($e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $e10, $e11, $e12, $e13, $e14, $e15, $e16, $e17, $e18, $e19)";
}
