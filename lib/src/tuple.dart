import 'package:adt_annotation/adt_annotation.dart';
part 'tuple.g.dart';

abstract class TupleN {
  TupleN._();
}

@data(
  #Tuple0,
  [],
  Tuple([]),
  mixin: [T(#TupleN0)],
)
const Type _tuple0 = Tuple0;

abstract class TupleN0 implements TupleN {
  const factory TupleN0() = Tuple0;
}

@data(#Tuple1, [Tp(#E0)], Tuple([T(#E0)]),
    mixin: [
      T(#TupleN1, args: [T(#E0)])
    ])
const Type _tuple1 = Tuple1;

abstract class TupleN1<E0> implements TupleN0 {
  const factory TupleN1(E0 e0) = Tuple1<E0>;
  E0 get e0;
}

/// GENERATED PART

@data(
  #Tuple2,
  [Tp(#E0), Tp(#E1)],
  Tuple([T(#E0), T(#E1)]),
  mixin: [
    T(#TupleN2, args: [T(#E0), T(#E1)])
  ],
)
const Type _Tuple2 = Tuple2;

abstract class TupleN2<E0, E1> implements TupleN1<E0> {
  const factory TupleN2(E0 e0, E1 e1) = Tuple2<E0, E1>;
  E1 get e1;
}

@data(
  #Tuple3,
  [Tp(#E0), Tp(#E1), Tp(#E2)],
  Tuple([T(#E0), T(#E1), T(#E2)]),
  mixin: [
    T(#TupleN3, args: [T(#E0), T(#E1), T(#E2)])
  ],
)
const Type _Tuple3 = Tuple3;

abstract class TupleN3<E0, E1, E2> implements TupleN2<E0, E1> {
  const factory TupleN3(E0 e0, E1 e1, E2 e2) = Tuple3<E0, E1, E2>;
  E2 get e2;
}

@data(
  #Tuple4,
  [Tp(#E0), Tp(#E1), Tp(#E2), Tp(#E3)],
  Tuple([T(#E0), T(#E1), T(#E2), T(#E3)]),
  mixin: [
    T(#TupleN4, args: [T(#E0), T(#E1), T(#E2), T(#E3)])
  ],
)
const Type _Tuple4 = Tuple4;

abstract class TupleN4<E0, E1, E2, E3> implements TupleN3<E0, E1, E2> {
  const factory TupleN4(E0 e0, E1 e1, E2 e2, E3 e3) = Tuple4<E0, E1, E2, E3>;
  E3 get e3;
}

@data(
  #Tuple5,
  [Tp(#E0), Tp(#E1), Tp(#E2), Tp(#E3), Tp(#E4)],
  Tuple([T(#E0), T(#E1), T(#E2), T(#E3), T(#E4)]),
  mixin: [
    T(#TupleN5, args: [T(#E0), T(#E1), T(#E2), T(#E3), T(#E4)])
  ],
)
const Type _Tuple5 = Tuple5;

abstract class TupleN5<E0, E1, E2, E3, E4> implements TupleN4<E0, E1, E2, E3> {
  const factory TupleN5(E0 e0, E1 e1, E2 e2, E3 e3, E4 e4) =
      Tuple5<E0, E1, E2, E3, E4>;
  E4 get e4;
}

@data(
  #Tuple6,
  [Tp(#E0), Tp(#E1), Tp(#E2), Tp(#E3), Tp(#E4), Tp(#E5)],
  Tuple([T(#E0), T(#E1), T(#E2), T(#E3), T(#E4), T(#E5)]),
  mixin: [
    T(#TupleN6, args: [T(#E0), T(#E1), T(#E2), T(#E3), T(#E4), T(#E5)])
  ],
)
const Type _Tuple6 = Tuple6;

abstract class TupleN6<E0, E1, E2, E3, E4, E5>
    implements TupleN5<E0, E1, E2, E3, E4> {
  const factory TupleN6(E0 e0, E1 e1, E2 e2, E3 e3, E4 e4, E5 e5) =
      Tuple6<E0, E1, E2, E3, E4, E5>;
  E5 get e5;
}

@data(
  #Tuple7,
  [Tp(#E0), Tp(#E1), Tp(#E2), Tp(#E3), Tp(#E4), Tp(#E5), Tp(#E6)],
  Tuple([T(#E0), T(#E1), T(#E2), T(#E3), T(#E4), T(#E5), T(#E6)]),
  mixin: [
    T(#TupleN7, args: [T(#E0), T(#E1), T(#E2), T(#E3), T(#E4), T(#E5), T(#E6)])
  ],
)
const Type _Tuple7 = Tuple7;

abstract class TupleN7<E0, E1, E2, E3, E4, E5, E6>
    implements TupleN6<E0, E1, E2, E3, E4, E5> {
  const factory TupleN7(E0 e0, E1 e1, E2 e2, E3 e3, E4 e4, E5 e5, E6 e6) =
      Tuple7<E0, E1, E2, E3, E4, E5, E6>;
  E6 get e6;
}

@data(
  #Tuple8,
  [Tp(#E0), Tp(#E1), Tp(#E2), Tp(#E3), Tp(#E4), Tp(#E5), Tp(#E6), Tp(#E7)],
  Tuple([T(#E0), T(#E1), T(#E2), T(#E3), T(#E4), T(#E5), T(#E6), T(#E7)]),
  mixin: [
    T(#TupleN8,
        args: [T(#E0), T(#E1), T(#E2), T(#E3), T(#E4), T(#E5), T(#E6), T(#E7)])
  ],
)
const Type _Tuple8 = Tuple8;

abstract class TupleN8<E0, E1, E2, E3, E4, E5, E6, E7>
    implements TupleN7<E0, E1, E2, E3, E4, E5, E6> {
  const factory TupleN8(
          E0 e0, E1 e1, E2 e2, E3 e3, E4 e4, E5 e5, E6 e6, E7 e7) =
      Tuple8<E0, E1, E2, E3, E4, E5, E6, E7>;
  E7 get e7;
}

@data(
  #Tuple9,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8)
  ],
  Tuple(
      [T(#E0), T(#E1), T(#E2), T(#E3), T(#E4), T(#E5), T(#E6), T(#E7), T(#E8)]),
  mixin: [
    T(#TupleN9, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8)
    ])
  ],
)
const Type _Tuple9 = Tuple9;

abstract class TupleN9<E0, E1, E2, E3, E4, E5, E6, E7, E8>
    implements TupleN8<E0, E1, E2, E3, E4, E5, E6, E7> {
  const factory TupleN9(
          E0 e0, E1 e1, E2 e2, E3 e3, E4 e4, E5 e5, E6 e6, E7 e7, E8 e8) =
      Tuple9<E0, E1, E2, E3, E4, E5, E6, E7, E8>;
  E8 get e8;
}

@data(
  #Tuple10,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9)
  ]),
  mixin: [
    T(#TupleN10, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9)
    ])
  ],
)
const Type _Tuple10 = Tuple10;

abstract class TupleN10<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9>
    implements TupleN9<E0, E1, E2, E3, E4, E5, E6, E7, E8> {
  const factory TupleN10(E0 e0, E1 e1, E2 e2, E3 e3, E4 e4, E5 e5, E6 e6, E7 e7,
      E8 e8, E9 e9) = Tuple10<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9>;
  E9 get e9;
}

@data(
  #Tuple11,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9),
    Tp(#E10)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9),
    T(#E10)
  ]),
  mixin: [
    T(#TupleN11, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9),
      T(#E10)
    ])
  ],
)
const Type _Tuple11 = Tuple11;

abstract class TupleN11<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10>
    implements TupleN10<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9> {
  const factory TupleN11(
      E0 e0,
      E1 e1,
      E2 e2,
      E3 e3,
      E4 e4,
      E5 e5,
      E6 e6,
      E7 e7,
      E8 e8,
      E9 e9,
      E10 e10) = Tuple11<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10>;
  E10 get e10;
}

@data(
  #Tuple12,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9),
    Tp(#E10),
    Tp(#E11)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9),
    T(#E10),
    T(#E11)
  ]),
  mixin: [
    T(#TupleN12, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9),
      T(#E10),
      T(#E11)
    ])
  ],
)
const Type _Tuple12 = Tuple12;

abstract class TupleN12<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11>
    implements TupleN11<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10> {
  const factory TupleN12(
      E0 e0,
      E1 e1,
      E2 e2,
      E3 e3,
      E4 e4,
      E5 e5,
      E6 e6,
      E7 e7,
      E8 e8,
      E9 e9,
      E10 e10,
      E11 e11) = Tuple12<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11>;
  E11 get e11;
}

@data(
  #Tuple13,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9),
    Tp(#E10),
    Tp(#E11),
    Tp(#E12)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9),
    T(#E10),
    T(#E11),
    T(#E12)
  ]),
  mixin: [
    T(#TupleN13, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9),
      T(#E10),
      T(#E11),
      T(#E12)
    ])
  ],
)
const Type _Tuple13 = Tuple13;

abstract class TupleN13<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12>
    implements TupleN12<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11> {
  const factory TupleN13(
      E0 e0,
      E1 e1,
      E2 e2,
      E3 e3,
      E4 e4,
      E5 e5,
      E6 e6,
      E7 e7,
      E8 e8,
      E9 e9,
      E10 e10,
      E11 e11,
      E12 e12) = Tuple13<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12>;
  E12 get e12;
}

@data(
  #Tuple14,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9),
    Tp(#E10),
    Tp(#E11),
    Tp(#E12),
    Tp(#E13)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9),
    T(#E10),
    T(#E11),
    T(#E12),
    T(#E13)
  ]),
  mixin: [
    T(#TupleN14, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9),
      T(#E10),
      T(#E11),
      T(#E12),
      T(#E13)
    ])
  ],
)
const Type _Tuple14 = Tuple14;

abstract class TupleN14<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
        E13>
    implements TupleN13<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12> {
  const factory TupleN14(E0 e0, E1 e1, E2 e2, E3 e3, E4 e4, E5 e5, E6 e6, E7 e7,
          E8 e8, E9 e9, E10 e10, E11 e11, E12 e12, E13 e13) =
      Tuple14<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13>;
  E13 get e13;
}

@data(
  #Tuple15,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9),
    Tp(#E10),
    Tp(#E11),
    Tp(#E12),
    Tp(#E13),
    Tp(#E14)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9),
    T(#E10),
    T(#E11),
    T(#E12),
    T(#E13),
    T(#E14)
  ]),
  mixin: [
    T(#TupleN15, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9),
      T(#E10),
      T(#E11),
      T(#E12),
      T(#E13),
      T(#E14)
    ])
  ],
)
const Type _Tuple15 = Tuple15;

abstract class TupleN15<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
        E13, E14>
    implements
        TupleN14<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13> {
  const factory TupleN15(E0 e0, E1 e1, E2 e2, E3 e3, E4 e4, E5 e5, E6 e6, E7 e7,
          E8 e8, E9 e9, E10 e10, E11 e11, E12 e12, E13 e13, E14 e14) =
      Tuple15<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14>;
  E14 get e14;
}

@data(
  #Tuple16,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9),
    Tp(#E10),
    Tp(#E11),
    Tp(#E12),
    Tp(#E13),
    Tp(#E14),
    Tp(#E15)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9),
    T(#E10),
    T(#E11),
    T(#E12),
    T(#E13),
    T(#E14),
    T(#E15)
  ]),
  mixin: [
    T(#TupleN16, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9),
      T(#E10),
      T(#E11),
      T(#E12),
      T(#E13),
      T(#E14),
      T(#E15)
    ])
  ],
)
const Type _Tuple16 = Tuple16;

abstract class TupleN16<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
        E13, E14, E15>
    implements
        TupleN15<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14> {
  const factory TupleN16(E0 e0, E1 e1, E2 e2, E3 e3, E4 e4, E5 e5, E6 e6, E7 e7,
          E8 e8, E9 e9, E10 e10, E11 e11, E12 e12, E13 e13, E14 e14, E15 e15) =
      Tuple16<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14,
          E15>;
  E15 get e15;
}

@data(
  #Tuple17,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9),
    Tp(#E10),
    Tp(#E11),
    Tp(#E12),
    Tp(#E13),
    Tp(#E14),
    Tp(#E15),
    Tp(#E16)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9),
    T(#E10),
    T(#E11),
    T(#E12),
    T(#E13),
    T(#E14),
    T(#E15),
    T(#E16)
  ]),
  mixin: [
    T(#TupleN17, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9),
      T(#E10),
      T(#E11),
      T(#E12),
      T(#E13),
      T(#E14),
      T(#E15),
      T(#E16)
    ])
  ],
)
const Type _Tuple17 = Tuple17;

abstract class TupleN17<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
        E13, E14, E15, E16>
    implements
        TupleN16<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14, E15> {
  const factory TupleN17(
          E0 e0,
          E1 e1,
          E2 e2,
          E3 e3,
          E4 e4,
          E5 e5,
          E6 e6,
          E7 e7,
          E8 e8,
          E9 e9,
          E10 e10,
          E11 e11,
          E12 e12,
          E13 e13,
          E14 e14,
          E15 e15,
          E16 e16) =
      Tuple17<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14,
          E15, E16>;
  E16 get e16;
}

@data(
  #Tuple18,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9),
    Tp(#E10),
    Tp(#E11),
    Tp(#E12),
    Tp(#E13),
    Tp(#E14),
    Tp(#E15),
    Tp(#E16),
    Tp(#E17)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9),
    T(#E10),
    T(#E11),
    T(#E12),
    T(#E13),
    T(#E14),
    T(#E15),
    T(#E16),
    T(#E17)
  ]),
  mixin: [
    T(#TupleN18, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9),
      T(#E10),
      T(#E11),
      T(#E12),
      T(#E13),
      T(#E14),
      T(#E15),
      T(#E16),
      T(#E17)
    ])
  ],
)
const Type _Tuple18 = Tuple18;

abstract class TupleN18<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
        E13, E14, E15, E16, E17>
    implements
        TupleN17<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14, E15, E16> {
  const factory TupleN18(
          E0 e0,
          E1 e1,
          E2 e2,
          E3 e3,
          E4 e4,
          E5 e5,
          E6 e6,
          E7 e7,
          E8 e8,
          E9 e9,
          E10 e10,
          E11 e11,
          E12 e12,
          E13 e13,
          E14 e14,
          E15 e15,
          E16 e16,
          E17 e17) =
      Tuple18<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14,
          E15, E16, E17>;
  E17 get e17;
}

@data(
  #Tuple19,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9),
    Tp(#E10),
    Tp(#E11),
    Tp(#E12),
    Tp(#E13),
    Tp(#E14),
    Tp(#E15),
    Tp(#E16),
    Tp(#E17),
    Tp(#E18)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9),
    T(#E10),
    T(#E11),
    T(#E12),
    T(#E13),
    T(#E14),
    T(#E15),
    T(#E16),
    T(#E17),
    T(#E18)
  ]),
  mixin: [
    T(#TupleN19, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9),
      T(#E10),
      T(#E11),
      T(#E12),
      T(#E13),
      T(#E14),
      T(#E15),
      T(#E16),
      T(#E17),
      T(#E18)
    ])
  ],
)
const Type _Tuple19 = Tuple19;

abstract class TupleN19<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
        E13, E14, E15, E16, E17, E18>
    implements
        TupleN18<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14, E15, E16, E17> {
  const factory TupleN19(
          E0 e0,
          E1 e1,
          E2 e2,
          E3 e3,
          E4 e4,
          E5 e5,
          E6 e6,
          E7 e7,
          E8 e8,
          E9 e9,
          E10 e10,
          E11 e11,
          E12 e12,
          E13 e13,
          E14 e14,
          E15 e15,
          E16 e16,
          E17 e17,
          E18 e18) =
      Tuple19<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14,
          E15, E16, E17, E18>;
  E18 get e18;
}

@data(
  #Tuple20,
  [
    Tp(#E0),
    Tp(#E1),
    Tp(#E2),
    Tp(#E3),
    Tp(#E4),
    Tp(#E5),
    Tp(#E6),
    Tp(#E7),
    Tp(#E8),
    Tp(#E9),
    Tp(#E10),
    Tp(#E11),
    Tp(#E12),
    Tp(#E13),
    Tp(#E14),
    Tp(#E15),
    Tp(#E16),
    Tp(#E17),
    Tp(#E18),
    Tp(#E19)
  ],
  Tuple([
    T(#E0),
    T(#E1),
    T(#E2),
    T(#E3),
    T(#E4),
    T(#E5),
    T(#E6),
    T(#E7),
    T(#E8),
    T(#E9),
    T(#E10),
    T(#E11),
    T(#E12),
    T(#E13),
    T(#E14),
    T(#E15),
    T(#E16),
    T(#E17),
    T(#E18),
    T(#E19)
  ]),
  mixin: [
    T(#TupleN20, args: [
      T(#E0),
      T(#E1),
      T(#E2),
      T(#E3),
      T(#E4),
      T(#E5),
      T(#E6),
      T(#E7),
      T(#E8),
      T(#E9),
      T(#E10),
      T(#E11),
      T(#E12),
      T(#E13),
      T(#E14),
      T(#E15),
      T(#E16),
      T(#E17),
      T(#E18),
      T(#E19)
    ])
  ],
)
const Type _Tuple20 = Tuple20;

abstract class TupleN20<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12,
        E13, E14, E15, E16, E17, E18, E19>
    implements
        TupleN19<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13,
            E14, E15, E16, E17, E18> {
  const factory TupleN20(
          E0 e0,
          E1 e1,
          E2 e2,
          E3 e3,
          E4 e4,
          E5 e5,
          E6 e6,
          E7 e7,
          E8 e8,
          E9 e9,
          E10 e10,
          E11 e11,
          E12 e12,
          E13 e13,
          E14 e14,
          E15 e15,
          E16 e16,
          E17 e17,
          E18 e18,
          E19 e19) =
      Tuple20<E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14,
          E15, E16, E17, E18, E19>;
  E19 get e19;
}
