library utils.event_bus;

import 'dart:async';
import 'either.dart';
import 'src/event_bus.dart';

/// An bus which receives every event from an scope, dispatches them to the
/// correct handler and keeps the last of each cacheable event saved.
abstract class EventBus {
  /// Create the implementation of an [EventBus]
  factory EventBus() = EventBusImpl;

  /// The [Stream] for the next events of type [Event] + the last cached one or
  /// an [Retrieve]d one or the errors emitted by this [Event] type. Prefer this
  /// over [events] for events which [IMayThrowAn].
  Stream<Either<E, Event>>
      eventsOrErrors<E, Event extends IAmRetrievableAndMayThrowAn<E>>({
    Duration retrieveTimeout = const Duration(milliseconds: 10),
    Object? argument,
  });

  /// The [Stream] for the next events of type [T] + the last cached one or an
  /// [Retrieve]d one.
  Stream<T> events<T extends IAmRetrievable>({
    Duration retrieveTimeout = const Duration(milliseconds: 10),
    Object? argument,
  });

  /// An [Stream] containing only the next events of type [T].
  Stream<T> nextEvents<T>();

  /// An [Stream] containing only the next events of type [Event] or the errors
  /// emitted by this [Event] type. Prefer this over [nextEvents] for events
  /// which [IMayThrowAn].
  Stream<Either<E, Event>>
      nextEventsOrErrors<E, Event extends IMayThrowAn<E>>();

  /// An [Stream] of the events which were not handled by any client of the bus.
  Stream get unhandledEvents;

  /// An [Stream] of every event added to this bus.
  Stream get allEvents;

  /// Add an [event] to the bus. The type argument is needed for caching.
  void add<T>(T event);

  /// Add an [error] to the bus That will be sent to the listeners of
  /// [Event].
  void addError<E, Event extends IMayThrowAn<E>>(E error);

  /// Close this bus.
  Future<void> close();
}

/// An interface to mark events which shall not be cached
abstract class IAmNotCacheable {
  const IAmNotCacheable._();
}

/// An interface to mark events which shall be [Retrieve]d.
abstract class IAmRetrievable {
  const IAmRetrievable._();
}

/// An interface to mark events which can throw an [E].
abstract class IMayThrowAn<E> {
  const IMayThrowAn._();
}

/// An interface to mark events which shall be [Retrieve]d and can throw an [E].
///
/// This is needed so that doing something invalid is an static type error.
abstract class IAmRetrievableAndMayThrowAn<E>
    implements IAmRetrievable, IMayThrowAn<E> {
  const IAmRetrievableAndMayThrowAn._();
}

/// An event which signals it's handler to add an new [T] to the bus.
class Retrieve<T> implements IAmNotCacheable {
  const Retrieve([this.argument]);

  /// An additional argument passed to the [Retrieve] event
  final Object? argument;
}
