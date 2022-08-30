library utils.curry;
/*
   Function typedefs to use instead of the regular Function type notation.
*/

typedef Fn0<R> = R Function();
typedef Fn1<R, T0> = R Function(T0);
typedef Fn2<R, T0, T1> = R Function(T0, T1);
typedef Fn3<R, T0, T1, T2> = R Function(T0, T1, T2);
typedef Fn4<R, T0, T1, T2, T3> = R Function(T0, T1, T2, T3);
typedef Fn5<R, T0, T1, T2, T3, T4> = R Function(T0, T1, T2, T3, T4);
typedef Fn6<R, T0, T1, T2, T3, T4, T5> = R Function(T0, T1, T2, T3, T4, T5);
typedef Fn7<R, T0, T1, T2, T3, T4, T5, T6> = R Function(
    T0, T1, T2, T3, T4, T5, T6);
typedef Fn8<R, T0, T1, T2, T3, T4, T5, T6, T7> = R Function(
    T0, T1, T2, T3, T4, T5, T6, T7);
typedef Fn9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> = R Function(
    T0, T1, T2, T3, T4, T5, T6, T7, T8);
typedef Fn10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> = R Function(
    T0, T1, T2, T3, T4, T5, T6, T7, T8, T9);
/*
   Higher order function typedefs to use instead of the regular Function type
   notation.
*/
typedef HigherFn1<R, T0> = R Function() Function(T0);
typedef HigherFn2<R, T0, T1> = R Function(T1) Function(T0);
typedef HigherFn3<R, T0, T1, T2> = R Function(T2) Function(T1) Function(T0);
typedef HigherFn4<R, T0, T1, T2, T3> = R Function(T3) Function(T2) Function(T1)
    Function(T0);
typedef HigherFn5<R, T0, T1, T2, T3, T4>
    = R Function(T4) Function(T3) Function(T2) Function(T1) Function(T0);
typedef HigherFn6<R, T0, T1, T2, T3, T4, T5>
    = R Function(T5) Function(T4) Function(T3) Function(T2) Function(T1)
        Function(T0);
typedef HigherFn7<R, T0, T1, T2, T3, T4, T5, T6>
    = R Function(T6) Function(T5) Function(T4) Function(T3) Function(T2)
            Function(T1)
        Function(T0);
typedef HigherFn8<R, T0, T1, T2, T3, T4, T5, T6, T7>
    = R Function(T7) Function(T6) Function(T5) Function(T4) Function(T3)
                Function(T2)
            Function(T1)
        Function(T0);
typedef HigherFn9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8>
    = R Function(T8) Function(T7) Function(T6) Function(T5) Function(T4)
                    Function(T3)
                Function(T2)
            Function(T1)
        Function(T0);
typedef HigherFn10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    = R Function(T9) Function(T8) Function(T7) Function(T6) Function(T5)
                        Function(T4)
                    Function(T3)
                Function(T2)
            Function(T1)
        Function(T0);

/*
   Curry functions. Useful for applying one argument at a time to an function.
   example:
   ```final powCurried = toCurry2(pow);
   final twoToThe = powCurried(2);
   assert(8 == twoToThe(3));```
*/

HigherFn1<R, T0> toCurry1<R, T0>(Fn1<R, T0> fn) => (a0) => () => fn(a0);
HigherFn2<R, T0, T1> toCurry2<R, T0, T1>(Fn2<R, T0, T1> fn) =>
    (a0) => (a1) => fn(a0, a1);
HigherFn3<R, T0, T1, T2> toCurry3<R, T0, T1, T2>(Fn3<R, T0, T1, T2> fn) =>
    (a0) => (a1) => (a2) => fn(a0, a1, a2);
HigherFn4<R, T0, T1, T2, T3> toCurry4<R, T0, T1, T2, T3>(
        Fn4<R, T0, T1, T2, T3> fn) =>
    (a0) => (a1) => (a2) => (a3) => fn(a0, a1, a2, a3);
HigherFn5<R, T0, T1, T2, T3, T4> toCurry5<R, T0, T1, T2, T3, T4>(
        Fn5<R, T0, T1, T2, T3, T4> fn) =>
    (a0) => (a1) => (a2) => (a3) => (a4) => fn(a0, a1, a2, a3, a4);
HigherFn6<R, T0, T1, T2, T3, T4, T5> toCurry6<R, T0, T1, T2, T3, T4, T5>(
        Fn6<R, T0, T1, T2, T3, T4, T5> fn) =>
    (T0 a0) =>
        (T1 a1) => (a2) => (a3) => (a4) => (a5) => fn(a0, a1, a2, a3, a4, a5);
HigherFn7<R, T0, T1, T2, T3, T4, T5, T6>
    toCurry7<R, T0, T1, T2, T3, T4, T5, T6>(
            Fn7<R, T0, T1, T2, T3, T4, T5, T6> fn) =>
        (a0) => (a1) => (a2) =>
            (a3) => (a4) => (a5) => (a6) => fn(a0, a1, a2, a3, a4, a5, a6);
HigherFn8<R, T0, T1, T2, T3, T4, T5, T6, T7>
    toCurry8<R, T0, T1, T2, T3, T4, T5, T6, T7>(
            Fn8<R, T0, T1, T2, T3, T4, T5, T6, T7> fn) =>
        (a0) => (a1) => (a2) => (a3) =>
            (a4) => (a5) => (a6) => (a7) => fn(a0, a1, a2, a3, a4, a5, a6, a7);
HigherFn9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8>
    toCurry9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8>(
            Fn9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> fn) =>
        (a0) => (a1) => (a2) => (a3) => (a4) => (a5) =>
            (a6) => (a7) => (a8) => fn(a0, a1, a2, a3, a4, a5, a6, a7, a8);
HigherFn10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    toCurry10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(
            Fn10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> fn) =>
        (a0) => (a1) => (a2) => (a3) => (a4) => (a5) => (a6) =>
            (a7) => (a8) => (a9) => fn(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9);
/*
   Apply left functions. Useful for applying the first argument of an function
   before using it.
   example:
   ```final twoToThe = applyLeft2(pow, 2);
   assert(8 == twoToThe(3));```
*/

Fn0<R> applyLeft1<R, T0>(Fn1<R, T0> fn, T0 arg) => () => fn(arg);
Fn1<R, T1> applyLeft2<R, T0, T1>(Fn2<R, T0, T1> fn, T0 arg) =>
    (a1) => fn(arg, a1);
Fn2<R, T1, T2> applyLeft3<R, T0, T1, T2>(Fn3<R, T0, T1, T2> fn, T0 arg) =>
    (a1, a2) => fn(arg, a1, a2);
Fn3<R, T1, T2, T3> applyLeft4<R, T0, T1, T2, T3>(
        Fn4<R, T0, T1, T2, T3> fn, T0 arg) =>
    (a1, a2, a3) => fn(arg, a1, a2, a3);
Fn4<R, T1, T2, T3, T4> applyLeft5<R, T0, T1, T2, T3, T4>(
        Fn5<R, T0, T1, T2, T3, T4> fn, T0 arg) =>
    (a1, a2, a3, a4) => fn(arg, a1, a2, a3, a4);
Fn5<R, T1, T2, T3, T4, T5> applyLeft6<R, T0, T1, T2, T3, T4, T5>(
        Fn6<R, T0, T1, T2, T3, T4, T5> fn, T0 arg) =>
    (a1, a2, a3, a4, a5) => fn(arg, a1, a2, a3, a4, a5);
Fn6<R, T1, T2, T3, T4, T5, T6> applyLeft7<R, T0, T1, T2, T3, T4, T5, T6>(
        Fn7<R, T0, T1, T2, T3, T4, T5, T6> fn, T0 arg) =>
    (a1, a2, a3, a4, a5, a6) => fn(arg, a1, a2, a3, a4, a5, a6);
Fn7<R, T1, T2, T3, T4, T5, T6, T7>
    applyLeft8<R, T0, T1, T2, T3, T4, T5, T6, T7>(
            Fn8<R, T0, T1, T2, T3, T4, T5, T6, T7> fn, T0 arg) =>
        (a1, a2, a3, a4, a5, a6, a7) => fn(arg, a1, a2, a3, a4, a5, a6, a7);
Fn8<R, T1, T2, T3, T4, T5, T6, T7, T8> applyLeft9<R, T0, T1, T2, T3, T4, T5, T6,
        T7, T8>(Fn9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> fn, T0 arg) =>
    (a1, a2, a3, a4, a5, a6, a7, a8) => fn(arg, a1, a2, a3, a4, a5, a6, a7, a8);
Fn9<R, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    applyLeft10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(
            Fn10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> fn, T0 arg) =>
        (a1, a2, a3, a4, a5, a6, a7, a8, a9) =>
            fn(arg, a1, a2, a3, a4, a5, a6, a7, a8, a9);

/*
   Apply right functions. Useful for applying the last argument of an function
   before using it.
   example:
   ```final toTheThird = applyRight2(pow, 3);
   assert(8 == toTheThird(2));```
*/

Fn0<R> applyRight1<R, T0>(Fn1<R, T0> fn, T0 arg) => () => fn(arg);
Fn1<R, T0> applyRight2<R, T0, T1>(Fn2<R, T0, T1> fn, T1 arg) =>
    (a0) => fn(a0, arg);
Fn2<R, T0, T1> applyRight3<R, T0, T1, T2>(Fn3<R, T0, T1, T2> fn, T2 arg) =>
    (a0, a1) => fn(a0, a1, arg);
Fn3<R, T0, T1, T2> applyRight4<R, T0, T1, T2, T3>(
        Fn4<R, T0, T1, T2, T3> fn, T3 arg) =>
    (a0, a1, a2) => fn(a0, a1, a2, arg);
Fn4<R, T0, T1, T2, T3> applyRight5<R, T0, T1, T2, T3, T4>(
        Fn5<R, T0, T1, T2, T3, T4> fn, T4 arg) =>
    (a0, a1, a2, a3) => fn(a0, a1, a2, a3, arg);
Fn5<R, T0, T1, T2, T3, T4> applyRight6<R, T0, T1, T2, T3, T4, T5>(
        Fn6<R, T0, T1, T2, T3, T4, T5> fn, T5 arg) =>
    (a0, a1, a2, a3, a4) => fn(a0, a1, a2, a3, a4, arg);
Fn6<R, T0, T1, T2, T3, T4, T5> applyRight7<R, T0, T1, T2, T3, T4, T5, T6>(
        Fn7<R, T0, T1, T2, T3, T4, T5, T6> fn, T6 arg) =>
    (a0, a1, a2, a3, a4, a5) => fn(a0, a1, a2, a3, a4, a5, arg);
Fn7<R, T0, T1, T2, T3, T4, T5, T6>
    applyRight8<R, T0, T1, T2, T3, T4, T5, T6, T7>(
            Fn8<R, T0, T1, T2, T3, T4, T5, T6, T7> fn, T7 arg) =>
        (a0, a1, a2, a3, a4, a5, a6) => fn(a0, a1, a2, a3, a4, a5, a6, arg);
Fn8<R, T0, T1, T2, T3, T4, T5, T6, T7> applyRight9<R, T0, T1, T2, T3, T4, T5,
        T6, T7, T8>(Fn9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> fn, T8 arg) =>
    (a0, a1, a2, a3, a4, a5, a6, a7) => fn(a0, a1, a2, a3, a4, a5, a6, a7, arg);
Fn9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8>
    applyRight10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(
            Fn10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> fn, T9 arg) =>
        (a0, a1, a2, a3, a4, a5, a6, a7, a8) =>
            fn(a0, a1, a2, a3, a4, a5, a6, a7, a8, arg);

/*
   Function extensions for easy Currying and applying.
*/

extension Fn1E<R, T0> on Fn1<R, T0> {
  HigherFn1<R, T0> get curry => toCurry1(this);
  Fn0<R> apR(T0 arg) => applyRight1(this, arg);
  Fn0<R> apL(T0 arg) => applyLeft1(this, arg);
}

extension Fn2E<R, T0, T1> on Fn2<R, T0, T1> {
  HigherFn2<R, T0, T1> get curry => toCurry2(this);
  Fn1<R, T0> apR(T1 arg) => applyRight2(this, arg);
  Fn1<R, T1> apL(T0 arg) => applyLeft2(this, arg);
}

extension Fn3E<R, T0, T1, T2> on Fn3<R, T0, T1, T2> {
  HigherFn3<R, T0, T1, T2> get curry => toCurry3(this);
  Fn2<R, T0, T1> apR(T2 arg) => applyRight3(this, arg);
  Fn2<R, T1, T2> apL(T0 arg) => applyLeft3(this, arg);
}

extension Fn4E<R, T0, T1, T2, T3> on Fn4<R, T0, T1, T2, T3> {
  HigherFn4<R, T0, T1, T2, T3> get curry => toCurry4(this);
  Fn3<R, T0, T1, T2> apR(T3 arg) => applyRight4(this, arg);
  Fn3<R, T1, T2, T3> apL(T0 arg) => applyLeft4(this, arg);
}

extension Fn5E<R, T0, T1, T2, T3, T4> on Fn5<R, T0, T1, T2, T3, T4> {
  HigherFn5<R, T0, T1, T2, T3, T4> get curry => toCurry5(this);
  Fn4<R, T0, T1, T2, T3> apR(T4 arg) => applyRight5(this, arg);
  Fn4<R, T1, T2, T3, T4> apL(T0 arg) => applyLeft5(this, arg);
}

extension Fn6E<R, T0, T1, T2, T3, T4, T5> on Fn6<R, T0, T1, T2, T3, T4, T5> {
  HigherFn6<R, T0, T1, T2, T3, T4, T5> get curry => toCurry6(this);
  Fn5<R, T0, T1, T2, T3, T4> apR(T5 arg) => applyRight6(this, arg);
  Fn5<R, T1, T2, T3, T4, T5> apL(T0 arg) => applyLeft6(this, arg);
}

extension Fn7E<R, T0, T1, T2, T3, T4, T5, T6>
    on Fn7<R, T0, T1, T2, T3, T4, T5, T6> {
  HigherFn7<R, T0, T1, T2, T3, T4, T5, T6> get curry => toCurry7(this);
  Fn6<R, T0, T1, T2, T3, T4, T5> apR(T6 arg) => applyRight7(this, arg);
  Fn6<R, T1, T2, T3, T4, T5, T6> apL(T0 arg) => applyLeft7(this, arg);
}

extension Fn8E<R, T0, T1, T2, T3, T4, T5, T6, T7>
    on Fn8<R, T0, T1, T2, T3, T4, T5, T6, T7> {
  HigherFn8<R, T0, T1, T2, T3, T4, T5, T6, T7> get curry => toCurry8(this);
  Fn7<R, T0, T1, T2, T3, T4, T5, T6> apR(T7 arg) => applyRight8(this, arg);
  Fn7<R, T1, T2, T3, T4, T5, T6, T7> apL(T0 arg) => applyLeft8(this, arg);
}

extension Fn9E<R, T0, T1, T2, T3, T4, T5, T6, T7, T8>
    on Fn9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> {
  HigherFn9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> get curry => toCurry9(this);
  Fn8<R, T0, T1, T2, T3, T4, T5, T6, T7> apR(T8 arg) => applyRight9(this, arg);
  Fn8<R, T1, T2, T3, T4, T5, T6, T7, T8> apL(T0 arg) => applyLeft9(this, arg);
}

extension Fn10E<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    on Fn10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> {
  HigherFn10<R, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> get curry =>
      toCurry10(this);
  Fn9<R, T0, T1, T2, T3, T4, T5, T6, T7, T8> apR(T9 arg) =>
      applyRight10(this, arg);
  Fn9<R, T1, T2, T3, T4, T5, T6, T7, T8, T9> apL(T0 arg) =>
      applyLeft10(this, arg);
}
