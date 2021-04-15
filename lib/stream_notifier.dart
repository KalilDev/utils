import 'dart:async';

import 'maybe.dart';

/// Wraps an [Stream<T>] and provides an [value] getter.
///
/// Lazily subscribes to the stream when the first listener/subscription is
/// added.
class StreamNotifier<T> {
  final Set<void Function(T)> _listeners = <void Function(T)>{};
  final Set<void Function()> _doneListeners = <void Function()>{};
  final Set<Function> _errorListeners = <Function>{};
  final Stream<T> _stream;
  StreamSubscription<T> _subs;

  /// Wraps the [stream].
  StreamNotifier(Stream<T> stream) : _stream = stream;

  void _ensureInitialized() {
    _subs ??= _stream.listen(
      _onStream,
      onDone: _onStreamDone,
      onError: _onStreamError,
    );
  }

  void _onStream(T value) {
    _value = Just(value);
    _listeners.toList().forEach((fn) => fn(value));
  }

  void _onStreamDone() => _doneListeners.toList().forEach((fn) => fn());
  void _onStreamError(Object error, [StackTrace s]) =>
      _errorListeners.toList().forEach((fn) {
        if (fn is void Function(Object error, [StackTrace s])) {
          return fn(error, s);
        }
        return fn(error);
      });

  void _addListeners({
    void Function(T) onValue,
    void Function() onDone,
    Function onError,
  }) {
    if (onValue != null) {
      _listeners.add(onValue);
    }
    if (onDone != null) {
      _doneListeners.add(onDone);
    }
    if (onError != null) {
      _errorListeners.add(onError);
    }
  }

  void _removeListeners({
    void Function(T) onValue,
    void Function() onDone,
    Function onError,
  }) {
    if (onValue != null) {
      _listeners.remove(onValue);
    }
    if (onDone != null) {
      _doneListeners.remove(onDone);
    }
    if (onError != null) {
      _errorListeners.remove(onError);
    }
  }

  Maybe<T> _value = None();

  /// Returns [Just] the current value when present, otherwise returns [None].
  Maybe<T> get value => _value;

  /// Create an [NotifierSubscription] for this stream. It allows accessing the
  /// [value] also.
  ///
  /// Automatically [close]s [this] when [StreamSubscription.cancel]ed if there
  /// aren't any other listeners.
  NotifierSubscription<T> listen(
    void Function(T) onValue, {
    void Function() onDone,
    Function onError,
  }) =>
      NotifierSubscription(this)
        .._handler = onValue
        .._doneHandler = onDone
        .._errorHandler = onError
        .._init();

  /// Create an [EagerNotifierSubscription] for this stream which notifies the
  /// current state. It allows accessing the [value] also.
  ///
  /// Automatically [close]s [this] when [StreamSubscription.cancel]ed if there
  /// aren't any other listeners.
  EagerNotifierSubscription<T> eagerListen(
    void Function(Maybe<T>) onValue, {
    void Function() onDone,
    Function onError,
  }) =>
      EagerNotifierSubscription(this)
        .._handler = onValue
        .._doneHandler = onDone
        .._errorHandler = onError
        .._init();

  /// Add listeners to this stream.
  void addListener(
    void Function(T) onValue, {
    void Function() onDone,
    Function onError,
  }) {
    _addListeners(
      onValue: onValue,
      onDone: onDone,
      onError: onError,
    );
    _ensureInitialized();
  }

  bool get _isEmpty =>
      _listeners.isEmpty && _doneListeners.isEmpty && _errorListeners.isEmpty;

  /// Stop receiving events and notifying listeners.
  Future<void> cancel() async {
    await _subs.cancel();
  }

  /// Remove listeners from this stream.
  FutureOr<void> removeListener(
    void Function(T) onValue, {
    void Function() onDone,
    Function onError,
    bool doNotCancel = false,
  }) {
    final wasEmpty = _isEmpty;
    _removeListeners(
      onValue: onValue,
      onDone: onDone,
      onError: onError,
    );
    if (doNotCancel) {
      return null;
    }
    if (!wasEmpty && _isEmpty) {
      return cancel();
    }
  }
}

/// An [StreamSubscription] for an [StreamNotifier] which emits the following
/// values only.
class NotifierSubscription<T> extends _NotifierSubscriptionBase<T> {
  final StreamNotifier<T> _self;
  NotifierSubscription(this._self);

  /// Returns [Just] the current value when present, otherwise returns [None].
  Maybe<T> get value => _self.value;

  @override
  void _init() => _self.addListener(
        _onStream,
        onDone: _onStreamDone,
        onError: _onStreamError,
      );

  @override
  void _dispose() => _self.removeListener(
        _onStream,
        onDone: _onStreamDone,
        onError: _onStreamError,
      );
}

/// An [StreamSubscription] for an [StreamNotifier] which emits the initial
/// value, present or not.
class EagerNotifierSubscription<T> extends _NotifierSubscriptionBase<Maybe<T>> {
  final StreamNotifier<T> _self;
  EagerNotifierSubscription(this._self);

  /// Returns [Just] the current value when present, otherwise returns [None].
  Maybe<T> get value => _self.value;

  void _onValue(T value) => _onStream(Just(value));

  @override
  void _init() {
    _self.addListener(
      _onValue,
      onDone: _onStreamDone,
      onError: _onStreamError,
    );
    return _onStream(_self.value);
  }

  @override
  void _dispose() => _self.removeListener(
        _onValue,
        onDone: _onStreamDone,
        onError: _onStreamError,
      );
}

abstract class _NotifierSubscriptionBase<T> implements StreamSubscription<T> {
  Maybe<T> _queuedEvent = None();
  bool _isPaused = false;
  void Function(T) _handler;
  void Function() _doneHandler;
  void Function(Object e, [StackTrace s]) _errorHandler;

  @override
  Future<E> asFuture<E>([E futureValue]) {
    final completer = Completer<E>();
    onDone(() => completer.complete(futureValue));
    onError(completer.completeError);
    return completer.future;
  }

  // ignore: unused_element
  void _init();

  void _dispose();

  void _onStream(T value) {
    if (_isPaused) {
      _queuedEvent = Just(value);
      return;
    }
    _handler(value);
  }

  void _onStreamDone() {
    _doneHandler?.call();
    _dispose();
  }

  void _onStreamError(Object error, [StackTrace s]) {
    if (_errorHandler is void Function(Object, [StackTrace])) {
      return _errorHandler?.call(error, s);
    }
    return _errorHandler?.call(error);
  }

  @override
  Future<void> cancel() async => _dispose();

  @override
  bool get isPaused => _isPaused;

  @override
  void onData(void Function(T) handleData) => _handler = handleData;

  @override
  void onDone(void Function() handleDone) => _doneHandler = handleDone;

  @override
  void onError(Function handleError) => _errorHandler = handleError;

  @override
  void pause([Future<void> resumeSignal]) {
    _isPaused = true;
    if (resumeSignal != null) {
      resumeSignal.then((_) => resume());
    }
  }

  @override
  void resume({
    bool emitLastest = true,
  }) {
    _isPaused = false;
    final queued = _queuedEvent;
    _queuedEvent = None();
    if (!emitLastest) {
      return;
    }
    queued.visit(
      just: _handler,
    );
  }
}
