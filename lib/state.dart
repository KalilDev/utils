import 'package:utils/utils.dart';

T _identity<T>(T v) => v;

typedef StateFn<S, A> = Tuple<A, S> Function(S);

class State<S, A> implements Monad<A>, MonadState<S> {
  final StateFn<S, A> runState;

  const State(this.runState);

  @override
  State<S, B> bind<B>(State<S, B> Function(A) fn) =>
      State<S, B>((s) => runState(s).visit(
            (a, s) => fn(a).runState(s),
          ));

  @override
  State<S, B> fmap<B>(B Function(A) fn) =>
      State<S, B>((s) => runState(s).first(fn));

  @override
  State<S, T> identity<T>() {
    throw UnimplementedError();
  }

  @override
  State<S, B> lift<A, B>(State<S, B Function(A)> fn, State<S, A> a) =>
      fn.bind((fn) => a.fmap(fn));

  @override
  State<S, T> pure<T>(T value) => unit(value);

  @override
  State<S, T> unit<T>(T value) => State<S, T>((s) => Tuple(value, s));

  @override
  State<S, S> get() => State((s) => Tuple(s, s));

  @override
  State<S, Null> put(S s) => State<S, Null>((_) => Tuple(null, s));

  @override
  State<S, A> state<A>(Tuple<A, S> Function(S) fn) =>
      get().bind((s) => fn(s).visit(
            (a, s) => put(s).unit(a),
          ));
}

typedef RunReader<E, A> = A Function(E env);

class Reader<E, A> extends Monad<A> implements MonadReader<E> {
  final RunReader<E, A> runReader;

  const Reader(this.runReader);

  @override
  Reader<E, B> bind<B>(Reader<E, B> Function(A) fn) {
    // TODO: implement bind
    throw UnimplementedError();
  }

  @override
  Reader<E, B> fmap<B>(B Function(A) fn) {
    // TODO: implement fmap
    throw UnimplementedError();
  }

  @override
  Reader<E, T> identity<T>() {
    // TODO: implement identity
    throw UnimplementedError();
  }

  @override
  Reader<E, B> lift<A, B>(Reader<E, B Function(A)> fn, Reader<E, A> a) {
    // TODO: implement lift
    throw UnimplementedError();
  }

  @override
  Reader<E, T> unit<T>(T value) {
    // TODO: implement unit
    throw UnimplementedError();
  }

  Reader<E, E> ask() => Reader(_identity);

  @override
  Reader<E, A> local<A>(E Function(E) f, Reader<E, A> m) {
    return Reader((e) => runReaders(m, f(e)));
  }

  @override
  Reader<E, A> reader<A>(A Function(E) fn) => ask().fmap(fn);
}

A runReaders<E, A>(Reader<E, A> reader, E env) => null;
