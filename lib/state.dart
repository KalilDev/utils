import 'package:utils/utils.dart';

T _identity<T>(T v) => v;

typedef StateFn<S, A> = Tuple<A, S> Function(S);

class State<S, A> implements Monad<A>, MonadState<S> {
  const State(this.runState);
  final StateFn<S, A> runState;

  @override
  State<S, B> bind<B>(State<S, B> Function(A) fn) =>
      State<S, B>((s) => runState(s).visit(
            (a, s) => fn(a).runState(s),
          ));

  @override
  State<S, B> fmap<B>(B Function(A) fn) => unreachable();
  /*State<S, B>((s) => runState(s).first(fn));*/

  @override
  State<S, T> identity<T>() {
    throw UnimplementedError();
  }

  @override
  State<S, B> lift<A1, B>(State<S, B Function(A1)> fn, State<S, A1> a) =>
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
  State<S, A1> state<A1>(Tuple<A1, S> Function(S) fn) =>
      get().bind((s) => fn(s).visit(
            (a, s) => put(s).unit(a),
          ));
}

typedef RunReader<E, A> = A Function(E env);

class Reader<E, A> extends Monad<A> implements MonadReader<E> {
  const Reader(this.runReader);
  final RunReader<E, A> runReader;

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
  Reader<E, B1> lift<A1, B1>(Reader<E, B1 Function(A1)> fn, Reader<E, A1> a) {
    // TODO: implement lift
    throw UnimplementedError();
  }

  @override
  Reader<E, T> unit<T>(T value) {
    // TODO: implement unit
    throw UnimplementedError();
  }

  @override
  Reader<E, E> ask() => Reader(_identity);

  @override
  Reader<E, A1/*!*/> local<A1>(E Function(E) f, Reader<E, A1> m) {
    return Reader((e) => runReaders(m, f(e)));
  }

  @override
  Reader<E, A1> reader<A1>(A1 Function(E) fn) => ask().fmap(fn);
}

A/*!*/ runReaders<E, A>(Reader<E, A> reader, E env) => null;
