typedef Curry1<R, T0> = R Function(T0);
typedef Curried1<R, T0> = R Function(T0);
typedef Curry2<R, T0, T1> = R Function(T0, T1);
typedef Curried2<R, T0, T1> = R Function(T1) Function(T0);
typedef Curry3<R, T0, T1, T2> = R Function(T0, T1, T2);
typedef Curried3<R, T0, T1, T2> = R Function(T2) Function(T1) Function(T0);
typedef Curry4<R, T0, T1, T2, T3> = R Function(T0, T1, T2, T3);
typedef Curried4<R, T0, T1, T2, T3> = R Function(T3) Function(T2) Function(T1)
    Function(T0);
typedef Curry5<R, T0, T1, T2, T3, T4> = R Function(T0, T1, T2, T3, T4);
typedef Curried5<R, T0, T1, T2, T3, T4>
    = R Function(T4) Function(T3) Function(T2) Function(T1) Function(T0);
typedef Curry6<R, T0, T1, T2, T3, T4, T5> = R Function(T0, T1, T2, T3, T4, T5);
typedef Curried6<R, T0, T1, T2, T3, T4, T5>
    = R Function(T5) Function(T4) Function(T3) Function(T2) Function(T1)
        Function(T0);
typedef Curry7<R, T0, T1, T2, T3, T4, T5, T6> = R Function(
    T0, T1, T2, T3, T4, T5, T6);
typedef Curried7<R, T0, T1, T2, T3, T4, T5, T6>
    = R Function(T6) Function(T5) Function(T4) Function(T3) Function(T2)
            Function(T1)
        Function(T0);
typedef Curry8<R, T0, T1, T2, T3, T4, T5, T6, T7> = R Function(
    T0, T1, T2, T3, T4, T5, T6, T7);
typedef Curried8<R, T0, T1, T2, T3, T4, T5, T6, T7>
    = R Function(T7) Function(T6) Function(T5) Function(T4) Function(T3)
                Function(T2)
            Function(T1)
        Function(T0);
typedef Curry9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> = R Function(
    T0, T1, T2, T3, T4, T5, T6, T7, T8);
typedef Curried9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8>
    = R Function(T8) Function(T7) Function(T6) Function(T5) Function(T4)
                    Function(T3)
                Function(T2)
            Function(T1)
        Function(T0);
typedef Curry10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> = R Function(
    T0, T1, T2, T3, T4, T5, T6, T7, T8, T9);
typedef Curried10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    = R Function(T9) Function(T8) Function(T7) Function(T6) Function(T5)
                        Function(T4)
                    Function(T3)
                Function(T2)
            Function(T1)
        Function(T0);

Curried1<R, T0> toCurry1<R, T0>(Curry1<R, T0> fn) => (T0 a0) => fn(a0);
Curried2<R, T0, T1> toCurry2<R, T0, T1>(Curry2<R, T0, T1> fn) =>
    (T0 a0) => (T1 a1) => fn(a0, a1);
Curried3<R, T0, T1, T2> toCurry3<R, T0, T1, T2>(Curry3<R, T0, T1, T2> fn) =>
    (T0 a0) => (T1 a1) => (T2 a2) => fn(a0, a1, a2);
Curried4<R, T0, T1, T2, T3> toCurry4<R, T0, T1, T2, T3>(
        Curry4<R, T0, T1, T2, T3> fn) =>
    (T0 a0) => (T1 a1) => (T2 a2) => (T3 a3) => fn(a0, a1, a2, a3);
Curried5<R, T0, T1, T2, T3, T4> toCurry5<R, T0, T1, T2, T3, T4>(
        Curry5<R, T0, T1, T2, T3, T4> fn) =>
    (T0 a0) =>
        (T1 a1) => (T2 a2) => (T3 a3) => (T4 a4) => fn(a0, a1, a2, a3, a4);
Curried6<R, T0, T1, T2, T3, T4, T5> toCurry6<R, T0, T1, T2, T3, T4, T5>(
        Curry6<R, T0, T1, T2, T3, T4, T5> fn) =>
    (T0 a0) => (T1 a1) =>
        (T2 a2) => (T3 a3) => (T4 a4) => (T5 a5) => fn(a0, a1, a2, a3, a4, a5);
Curried7<R, T0, T1, T2, T3, T4, T5, T6> toCurry7<R, T0, T1, T2, T3, T4, T5, T6>(
        Curry7<R, T0, T1, T2, T3, T4, T5, T6> fn) =>
    (T0 a0) => (T1 a1) => (T2 a2) => (T3 a3) =>
        (T4 a4) => (T5 a5) => (T6 a6) => fn(a0, a1, a2, a3, a4, a5, a6);
Curried8<R, T0, T1, T2, T3, T4, T5, T6, T7>
    toCurry8<R, T0, T1, T2, T3, T4, T5, T6, T7>(
            Curry8<R, T0, T1, T2, T3, T4, T5, T6, T7> fn) =>
        (T0 a0) => (T1 a1) => (T2 a2) => (T3 a3) => (T4 a4) =>
            (T5 a5) => (T6 a6) => (T7 a7) => fn(a0, a1, a2, a3, a4, a5, a6, a7);
Curried9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> toCurry9<R, T0, T1, T2, T3, T4,
        T5, T6, T7, T8>(Curry9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> fn) =>
    (T0 a0) => (T1 a1) => (T2 a2) => (T3 a3) => (T4 a4) => (T5 a5) =>
        (T6 a6) => (T7 a7) => (T8 a8) => fn(a0, a1, a2, a3, a4, a5, a6, a7, a8);
Curried10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    toCurry10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(
            Curry10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> fn) =>
        (T0 a0) => (T1 a1) => (T2 a2) => (T3 a3) => (T4 a4) => (T5 a5) =>
            (T6 a6) => (T7 a7) => (T8 a8) =>
                (T9 a9) => fn(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9);

extension ToCurry1<R, T0> on Curry1<R, T0> {
  Curried1<R, T0> get curry => toCurry1(this);
}

extension ToCurry2<R, T0, T1> on Curry2<R, T0, T1> {
  Curried2<R, T0, T1> get curry => toCurry2(this);
}

extension ToCurry3<R, T0, T1, T2> on Curry3<R, T0, T1, T2> {
  Curried3<R, T0, T1, T2> get curry => toCurry3(this);
}

extension ToCurry4<R, T0, T1, T2, T3> on Curry4<R, T0, T1, T2, T3> {
  Curried4<R, T0, T1, T2, T3> get curry => toCurry4(this);
}

extension ToCurry5<R, T0, T1, T2, T3, T4> on Curry5<R, T0, T1, T2, T3, T4> {
  Curried5<R, T0, T1, T2, T3, T4> get curry => toCurry5(this);
}

extension ToCurry6<R, T0, T1, T2, T3, T4, T5>
    on Curry6<R, T0, T1, T2, T3, T4, T5> {
  Curried6<R, T0, T1, T2, T3, T4, T5> get curry => toCurry6(this);
}

extension ToCurry7<R, T0, T1, T2, T3, T4, T5, T6>
    on Curry7<R, T0, T1, T2, T3, T4, T5, T6> {
  Curried7<R, T0, T1, T2, T3, T4, T5, T6> get curry => toCurry7(this);
}

extension ToCurry8<R, T0, T1, T2, T3, T4, T5, T6, T7>
    on Curry8<R, T0, T1, T2, T3, T4, T5, T6, T7> {
  Curried8<R, T0, T1, T2, T3, T4, T5, T6, T7> get curry => toCurry8(this);
}

extension ToCurry9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8>
    on Curry9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> {
  Curried9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> get curry => toCurry9(this);
}

extension ToCurry10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on Curry10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> {
  Curried10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> get curry =>
      toCurry10(this);
}
