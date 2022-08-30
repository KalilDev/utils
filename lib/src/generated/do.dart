import '../../utils.dart';

/// The do notation implementation for the Monad Maybe with 1 arguments.
/// It is implemented using [Maybe.bind]
Maybe<A> doMaybe1<A>({required Maybe<A> Function() a}) => a();

/// The do notation implementation for the Monad Maybe with 2 arguments.
/// It is implemented using [Maybe.bind]
Maybe<B> doMaybe2<A, B>(
        {required Maybe<A> Function() a, required Maybe<B> Function(A a) b}) =>
    a().bind(b);

/// The do notation implementation for the Monad Maybe with 3 arguments.
/// It is implemented using [Maybe.bind]
Maybe<C> doMaybe3<A, B, C>(
        {required Maybe<A> Function() a,
        required Maybe<B> Function(A a) b,
        required Maybe<C> Function(A a) c}) =>
    a().bind(
      (a) => b(a).bind(
        (b) => c(a),
      ),
    );

/// The do notation implementation for the Monad Maybe with 4 arguments.
/// It is implemented using [Maybe.bind]
Maybe<D> doMaybe4<A, B, C, D>(
        {required Maybe<A> Function() a,
        required Maybe<B> Function(A a) b,
        required Maybe<C> Function(A a) c,
        required Maybe<D> Function(A a, B b) d}) =>
    a().bind(
      (a) => b(a).bind(
        (b) => c(a).bind(
          (c) => d(a, b),
        ),
      ),
    );

/// The do notation implementation for the Monad Maybe with 5 arguments.
/// It is implemented using [Maybe.bind]
Maybe<E> doMaybe5<A, B, C, D, E>(
        {required Maybe<A> Function() a,
        required Maybe<B> Function(A a) b,
        required Maybe<C> Function(A a) c,
        required Maybe<D> Function(A a, B b) d,
        required Maybe<E> Function(A a, B b, C c) e}) =>
    a().bind(
      (a) => b(a).bind(
        (b) => c(a).bind(
          (c) => d(a, b).bind(
            (d) => e(a, b, c),
          ),
        ),
      ),
    );

/// The do notation implementation for the Monad Maybe with 6 arguments.
/// It is implemented using [Maybe.bind]
Maybe<F> doMaybe6<A, B, C, D, E, F>(
        {required Maybe<A> Function() a,
        required Maybe<B> Function(A a) b,
        required Maybe<C> Function(A a) c,
        required Maybe<D> Function(A a, B b) d,
        required Maybe<E> Function(A a, B b, C c) e,
        required Maybe<F> Function(A a, B b, C c, D d) f}) =>
    a().bind(
      (a) => b(a).bind(
        (b) => c(a).bind(
          (c) => d(a, b).bind(
            (d) => e(a, b, c).bind(
              (e) => f(a, b, c, d),
            ),
          ),
        ),
      ),
    );

/// The do notation implementation for the Monad Maybe with 7 arguments.
/// It is implemented using [Maybe.bind]
Maybe<G> doMaybe7<A, B, C, D, E, F, G>(
        {required Maybe<A> Function() a,
        required Maybe<B> Function(A a) b,
        required Maybe<C> Function(A a) c,
        required Maybe<D> Function(A a, B b) d,
        required Maybe<E> Function(A a, B b, C c) e,
        required Maybe<F> Function(A a, B b, C c, D d) f,
        required Maybe<G> Function(A a, B b, C c, D d, E e) g}) =>
    a().bind(
      (a) => b(a).bind(
        (b) => c(a).bind(
          (c) => d(a, b).bind(
            (d) => e(a, b, c).bind(
              (e) => f(a, b, c, d).bind(
                (f) => g(a, b, c, d, e),
              ),
            ),
          ),
        ),
      ),
    );

/// The do notation implementation for the Monad Maybe with 8 arguments.
/// It is implemented using [Maybe.bind]
Maybe<H> doMaybe8<A, B, C, D, E, F, G, H>(
        {required Maybe<A> Function() a,
        required Maybe<B> Function(A a) b,
        required Maybe<C> Function(A a) c,
        required Maybe<D> Function(A a, B b) d,
        required Maybe<E> Function(A a, B b, C c) e,
        required Maybe<F> Function(A a, B b, C c, D d) f,
        required Maybe<G> Function(A a, B b, C c, D d, E e) g,
        required Maybe<H> Function(A a, B b, C c, D d, E e, F f) h}) =>
    a().bind(
      (a) => b(a).bind(
        (b) => c(a).bind(
          (c) => d(a, b).bind(
            (d) => e(a, b, c).bind(
              (e) => f(a, b, c, d).bind(
                (f) => g(a, b, c, d, e).bind(
                  (g) => h(a, b, c, d, e, f),
                ),
              ),
            ),
          ),
        ),
      ),
    );

/// The do notation implementation for the Monad Maybe with 9 arguments.
/// It is implemented using [Maybe.bind]
Maybe<I> doMaybe9<A, B, C, D, E, F, G, H, I>(
        {required Maybe<A> Function() a,
        required Maybe<B> Function(A a) b,
        required Maybe<C> Function(A a) c,
        required Maybe<D> Function(A a, B b) d,
        required Maybe<E> Function(A a, B b, C c) e,
        required Maybe<F> Function(A a, B b, C c, D d) f,
        required Maybe<G> Function(A a, B b, C c, D d, E e) g,
        required Maybe<H> Function(A a, B b, C c, D d, E e, F f) h,
        required Maybe<I> Function(A a, B b, C c, D d, E e, F f, G g) i}) =>
    a().bind(
      (a) => b(a).bind(
        (b) => c(a).bind(
          (c) => d(a, b).bind(
            (d) => e(a, b, c).bind(
              (e) => f(a, b, c, d).bind(
                (f) => g(a, b, c, d, e).bind(
                  (g) => h(a, b, c, d, e, f).bind(
                    (h) => i(a, b, c, d, e, f, g),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

/// The do notation implementation for the Monad Maybe with 10 arguments.
/// It is implemented using [Maybe.bind]
Maybe<J> doMaybe10<A, B, C, D, E, F, G, H, I, J>(
        {required Maybe<A> Function() a,
        required Maybe<B> Function(A a) b,
        required Maybe<C> Function(A a) c,
        required Maybe<D> Function(A a, B b) d,
        required Maybe<E> Function(A a, B b, C c) e,
        required Maybe<F> Function(A a, B b, C c, D d) f,
        required Maybe<G> Function(A a, B b, C c, D d, E e) g,
        required Maybe<H> Function(A a, B b, C c, D d, E e, F f) h,
        required Maybe<I> Function(A a, B b, C c, D d, E e, F f, G g) i,
        required Maybe<J> Function(A a, B b, C c, D d, E e, F f, G g, H h)
            j}) =>
    a().bind(
      (a) => b(a).bind(
        (b) => c(a).bind(
          (c) => d(a, b).bind(
            (d) => e(a, b, c).bind(
              (e) => f(a, b, c, d).bind(
                (f) => g(a, b, c, d, e).bind(
                  (g) => h(a, b, c, d, e, f).bind(
                    (h) => i(a, b, c, d, e, f, g).bind(
                      (i) => j(a, b, c, d, e, f, g, h),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
