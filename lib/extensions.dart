library utils.extensions;

import 'dart:async';

import 'curry.dart';
import 'type.dart';

/// python-like range object
// ignore: camel_case_types
class range extends Iterable<int> {
  const range(
    this.end, [
    this.start = 0,
    this.step = 1,
  ]) : assert(step != 0);

  /// Required. An integer number specifying at which position to end.
  final int end;

  /// Optional. An integer number specifying at which position to start.
  /// Default is 0
  final int start;

  /// Optional. An integer number specifying the incrementation.
  /// Default is 1
  final int step;

  bool get crescent => step > 0;
  bool get decrescent => step < 0;
  @override
  int get length => (end - start + (crescent ? -1 : 1)) ~/ step + 1;

  @override
  Iterator<int> get iterator => _RangeIterator(this);
}

/// An Infinite iterable filled with the value [_value]
// ignore: camel_case_types
class infinite<T> extends Iterable<T> {
  const infinite(this._value);
  final T _value;

  @override
  Iterator<T> get iterator => _InfiniteIterator(_value);
}

class _InfiniteIterator<T> implements Iterator<T> {
  const _InfiniteIterator(this._value);
  final T _value;

  @override
  @pragma('vm:prefer-inline')
  T get current => _value;

  @override
  @pragma('vm:prefer-inline')
  bool moveNext() => true;
}

class _RangeIterator extends Iterator<int> {
  _RangeIterator(this._self);
  final range _self;

  int? _i;

  @override
  int get current => _i!;

  @override
  bool moveNext() {
    if (_i == null) {
      _i = _self.start;
      return _self.start <= _self.end;
    }
    var i = _i!;

    _i = i += _self.step;
    if (_self.crescent && i >= _self.end) {
      return false;
    }
    if (_self.decrescent && i <= _self.end) {
      return false;
    }
    return true;
  }
}

extension ObjectE<T> on T {
  @Deprecated('There are very few usecases for this.')
  T fmapOn<T1>(T Function(T1) fn) => this is T1 ? fn(this as T1) : this;
  @Deprecated('Use pipe')
  T1 fmap<T1>(T1 Function(T) fn) => fn(this);

  // let (|>) x f = f x
  T1 pipe<T1>(T1 Function(T) fn) => fn(this);
}

extension FunctionE<R, A> on Fn1<R, A> {
  // let (<|) f x = f x
  R pipeL(A arg) => this(arg);

  // let (>>) f g x = g (f x)
  // compose
  Fn1<C, A> comp<C>(C Function(R) g) => (e) => g(this(e));

  // let (<<) f g x = f (g x)
  // composeLeft
  Fn1<R, C> compL<C>(A Function(C) g) => (e) => this(g(e));
}

extension IterableE<T> on Iterable<T> {
  @pragma('vm:prefer-inline')
  Iterable<T1> fmap<T1>(T1 Function(T) fn) => map(fn);
  @pragma('vm:prefer-inline')
  Iterable<T1> bind<T1>(Iterable<T1> Function(T) fn) => expand(fn);
  Iterable<Tuple<T, T1>> zip<T1>(Iterable<T1> other) sync* {
    final ia = iterator, ib = other.iterator;
    while (ia.moveNext() && ib.moveNext()) {
      yield Tuple(ia.current, ib.current);
    }
  }

  Iterable<Tuple<int, T>> get indexed sync* {
    var i = 0;
    final it = iterator;
    while (it.moveNext()) {
      yield Tuple(i++, it.current);
    }
  }

  R visit<R>({
    required R Function() empty,
    required R Function(Iterable<T>) values,
  }) =>
      isEmpty ? empty() : values(this);
}

extension IterableFutureOrE<T> on Iterable<FutureOr<T>> {
  Iterable<Future<T>> liftFutures() => map((e) => Future.value(e));
}

extension IterableFutureE<T> on Iterable<Future<T>> {
  Future<Iterable<T>> wait({
    bool eagerError = false,
    void Function(T)? cleanUp,
  }) =>
      Future.wait(this, eagerError: eagerError, cleanUp: cleanUp);
}

extension IterableIterableE<T> on Iterable<Iterable<T>> {
  Iterable<T> unwrap() => expand((e) => e);
}

extension IndexedIterableE<T> on Iterable<Tuple<int, T>> {
  Iterable<T> get deindexed => map((e) => e.right);
}
