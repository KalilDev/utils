import 'dart:async';

import '../either.dart';
import '../event_bus.dart';

/// The actual implementation of [EventBus]
class EventBusImpl implements EventBus {
  final StreamController _eventsController = StreamController.broadcast();
  final StreamController _unhandledController = StreamController.broadcast();
  final List<_Listener> _listeners = [];
  final Map<Type, dynamic> _lastEvent = {};
  bool _closed = false;

  void _maybeCache<T>(T event) {
    if (identical(T, dynamic)) {
      return;
    }
    if (event is IAmNotCacheable) {
      return;
    }
    _lastEvent[T] = event;
  }

  void _addError<E, Event extends IMayThrowAn<E>>(E error) {
    if (_closed) {
      throw StateError('This bus was closed already!');
    }

    final listeners = _listeners.where((l) => l.canAdd(Event));
    // TODO: Error event
    // _eventsController.add(event);
    if (listeners.isEmpty) {
      // TODO: Error event
      // _unhandledController.add(event);
    } else {
      listeners.forEach((l) => l.addError(error));
    }
  }

  void _add<T>(T event) {
    if (_closed) {
      throw StateError('This bus was closed already!');
    }

    final listeners = _listeners.where((l) => l.canAdd(T));
    _eventsController.add(event);
    if (listeners.isEmpty) {
      _unhandledController.add(event);
    } else {
      listeners.forEach((l) => l.addEvent(event));
    }
    _maybeCache<T>(event);
  }

  void _addRetrieveToListener<T extends IAmRetrievable>(
    _Listener listener,
    Duration retrieveTimeout,
    Object retrieveArgument,
  ) {
    listener
      ..onListen = () async {
        if (_lastEvent.containsKey(T) && _lastEvent[T] is T) {
          listener.addEvent(_lastEvent[T] as T);
          return;
        }
        await Future.delayed(retrieveTimeout);
        if (!listener.didAdd) {
          _add<Retrieve<T>>(Retrieve<T>(retrieveArgument));
        }
      }
      ..onCancel = () => _listeners.remove(listener);
  }

  /// Public API

  @override
  Stream<Either<E, Event>>
      eventsOrErrors<E, Event extends IAmRetrievableAndMayThrowAn<E>>({
    Duration retrieveTimeout = const Duration(milliseconds: 10),
    Object argument,
  }) {
    final l = _EitherListener<E, Event>();
    _addRetrieveToListener<Event>(l, retrieveTimeout, argument);
    _listeners.add(l);
    return l.stream;
  }

  @override
  Stream<T> events<T extends IAmRetrievable>({
    Duration retrieveTimeout = const Duration(milliseconds: 10),
    Object argument,
  }) {
    final l = _RegularListener<T>();
    _addRetrieveToListener<T>(l, retrieveTimeout, argument);
    _listeners.add(l);
    return l.stream;
  }

  @override
  Stream<T> nextEvents<T>() {
    final l = _RegularListener<T>();
    _listeners.add(l);
    l..onCancel = () => _listeners.remove(l);
    return l.stream;
  }

  @override
  Stream<Either<E, Event>>
      nextEventsOrErrors<E, Event extends IMayThrowAn<E>>() {
    final l = _EitherListener<E, Event>();
    _listeners.add(l);
    l..onCancel = () => _listeners.remove(l);
    return l.stream;
  }

  @override
  Stream get unhandledEvents => _unhandledController.stream;

  @override
  Stream get allEvents => _eventsController.stream;

  @override
  void add<T>(T event) => _add<T>(event);

  @override
  void addError<E, Event extends IMayThrowAn<E>>(E error) {
    _addError<E, Event>(error);
  }

  @override
  Future<void> close() async {
    _closed = true;
    await _eventsController.close();
    await _unhandledController.close();
    for (final l in _listeners) {
      await l.handleClose();
    }
  }
}

abstract class _Listener {
  bool didAdd = false;

  set onListen(FutureOr<void> Function() onListen);
  set onCancel(FutureOr<void> Function() onCancel);

  bool canAdd(Type eventType);

  void addError(Object error);

  void addEvent(dynamic event);

  void handleClose();
}

class _EitherListener<E, Event extends IMayThrowAn<E>> extends _Listener {
  final StreamController<Either<E, Event>> _controller =
      StreamController<Either<E, Event>>();

  @override
  set onListen(FutureOr<void> Function() onListen) =>
      _controller.onListen = onListen;
  @override
  set onCancel(FutureOr<void> Function() onCancel) =>
      _controller.onCancel = onCancel;

  Stream<Either<E, Event>> get stream => _controller.stream;

  @override
  bool canAdd(Type eventType) => eventType == Event;

  @override
  void addError(Object error) {
    if (error is! E) {
      throw TypeError();
    }
    _controller.add(Either.left<E, Event>(error));
  }

  @override
  void addEvent(dynamic event) {
    if (event is! Event) {
      throw TypeError();
    }
    didAdd = true;
    _controller.add(Either.right<E, Event>(event as Event));
  }

  @override
  void handleClose() {
    didAdd = true;
    _controller.close();
  }
}

class _RegularListener<T> extends _Listener {
  final StreamController<T> _controller = StreamController<T>();
  @override
  bool didAdd = false;

  @override
  set onListen(FutureOr<void> Function() onListen) =>
      _controller.onListen = onListen;
  @override
  set onCancel(FutureOr<void> Function() onCancel) =>
      _controller.onCancel = onCancel;

  Stream<T> get stream => _controller.stream;

  @override
  bool canAdd(Type eventType) => eventType == T;

  @override
  void addError(Object error) {
    _controller.addError(error);
  }

  @override
  void addEvent(dynamic event) {
    if (event is! T) {
      throw TypeError();
    }
    didAdd = true;
    _controller.add(event as T);
  }

  @override
  void handleClose() {
    didAdd = true;
    _controller.close();
  }
}
