import 'dart:collection';
import 'dart:convert';

import '../../maybe.dart';
import '../converter_function.dart';
import '../event_sourcing.dart';

/// An [Codec] which can [encode] and [decode] an
/// [DoublyLinkedEventSourcedModel].
class DoublyLinkedEventSourcedModelCodec<
        S extends EventSourcedSnapshot<S, B, E>,
        B extends EventSourcedSnapshotBuilder<S, B, E>,
        E extends UndoableEventSourcedEvent<S, B, E>>
    extends Codec<DoublyLinkedEventSourcedModel<S, B, E>,
        Map<String, dynamic>> {
  /// Create an [DoublyLinkedEventSourcedModelCodec].
  const DoublyLinkedEventSourcedModelCodec();

  @override
  Converter<Map<String, dynamic>, DoublyLinkedEventSourcedModel<S, B, E>>
      get decoder => ConverterFn((m) {
            final cursorI = m['cursorIndex'] as int?;
            final entries =
                ArgumentError.checkNotNull(m['entries'] as List?).cast<E>();
            _DoubleLink<E> it = _DoubleLink(None());
            _DoubleLink<E> cursor = it;

            for (var i = 0; i < entries.length; i++) {
              final event = entries[i];
              final nextLink = _DoubleLink(Just(event));
              it.next = nextLink;
              nextLink.previous = it;
              it = nextLink;

              if (i == cursorI) {
                it = it;
              }
            }

            return DoublyLinkedEventSourcedModel<S, B, E>._(
              initialState: ArgumentError.checkNotNull(m['initialState'] as S?),
              state: m['state'] as S,
              cursor: cursor,
            );
          });

  @override
  Converter<DoublyLinkedEventSourcedModel<S, B, E>, Map<String, dynamic>>
      get encoder => ConverterFn((t) {
            final entries = <E>[];
            int? cursorI;
            // skip the sentry (_DoubleLink(None()))
            for (var it = t._eventCursor.start.next, i = 0; it != null; i++) {
              entries.add(it.value.visit(
                just: (e) => e,
                none: () => throw StateError(
                  "There should have been an event at the link",
                ),
              ));
              if (it == t._eventCursor) {
                cursorI = i;
              }
            }
            return <String, dynamic>{
              'initialState': t.initialState,
              'state': t._snapshot,
              'cursorIndex': cursorI,
              'entries': entries,
            };
          });
}

class _DoubleLink<T> {
  _DoubleLink(this.value);

  final Maybe<T> value;
  _DoubleLink<T>? previous;
  _DoubleLink<T>? next;

  Iterable<_DoubleLink<T>> get nextLinks sync* {
    for (var it = next; it != null; it = it.next) {
      yield it;
    }
  }

  Iterable<_DoubleLink<T>> get previousLinks sync* {
    for (var it = previous; it != null; it = it.next) {
      yield it;
    }
  }

  _DoubleLink<T> get start {
    if (previous == null) {
      return this;
    }
    return previousLinks.last;
  }

  bool get isNotLinked => previous == null && next == null;
  void unlink() {
    previous = null;
    next = null;
  }
}

/// An [UndoableEventSourcedModel] which uses an [DoubleLinkedQueueEntry] as the
/// backing data structure.
class DoublyLinkedEventSourcedModel<
        S extends EventSourcedSnapshot<S, B, E>,
        B extends EventSourcedSnapshotBuilder<S, B, E>,
        E extends UndoableEventSourcedEvent<S, B, E>>
    extends UndoableEventSourcedModel<S, B, E> {
  /// Create an [DoublyLinkedEventSourcedModel].
  DoublyLinkedEventSourcedModel(S initialState)
      : _snapshot = initialState,
        super(initialState);

  DoublyLinkedEventSourcedModel._(
      {required S initialState,
      required S state,
      required _DoubleLink<E> cursor})
      : _eventCursor = cursor,
        _snapshot = state,
        super(initialState);

  _DoubleLink<E> _eventCursor = _DoubleLink(None());

  @override
  bool canUndo() {
    // we are at the beggining, therefore there aren't any events, so we can't
    // undo
    if (_eventCursor.value is None) {
      return false;
    }

    final previous = _eventCursor.previous;
    assert(previous != null);
    return true;
  }

  @override
  bool undo() {
    if (!canUndo()) {
      return false;
    }

    final previous = _eventCursor.previous;
    if (previous == null) {
      throw StateError('There should have been an previous link');
    }
    final currentEvent = _eventCursor.value.visit(
      just: (e) => e,
      none: () => throw StateError('There should have been an event now'),
    );
    _eventCursor = previous;
    _snapshot = snapshot.rebuild(currentEvent.undoTo);
    return true;
  }

  @override
  bool canRedo() {
    final next = _eventCursor.next;
    // we are at the head, so we can't redo.
    if (next == null) {
      return false;
    }
    return true;
  }

  @override
  bool redo() {
    if (!canRedo()) {
      return false;
    }
    final next = _eventCursor.next;
    if (next == null) {
      throw StateError('There should have been an next link');
    }

    final nextEvent = next.value.visit(
      just: (e) => e,
      none: () => throw StateError('There should have been an next event'),
    );
    _eventCursor = next;
    _snapshot = snapshot.rebuild(nextEvent.applyTo);
    return true;
  }

  void _removeEventsAfterTheCursor() {
    // store the nexts in an list and unlink each one
    for (final next in _eventCursor.nextLinks.toList()) {
      next.unlink();
    }
    // unlink the current so that it does not point to the unlinked next(s)
    _eventCursor.next = null;
  }

  void _addAndMoveCursor(E event) {
    final nextLink = _DoubleLink(Just(event));
    // Link them
    _eventCursor.next = nextLink;
    nextLink.previous = _eventCursor;

    _eventCursor = nextLink;
  }

  @override
  S add(E event) {
    _removeEventsAfterTheCursor();
    _addAndMoveCursor(event);
    return _snapshot = snapshot.rebuild(event.applyTo);
  }

  @override
  S addAll(Iterable<E> events) {
    _removeEventsAfterTheCursor();
    final builder = snapshot.toBuilder();
    for (final event in events) {
      _addAndMoveCursor(event);
      event.applyTo(builder);
    }
    return _snapshot = builder.build();
  }

  @override
  S get snapshot => _snapshot;
  S _snapshot;

  @override
  Codec<EventSourcedModel<S, B, E>, Map<String, dynamic>> get codec =>
      DoublyLinkedEventSourcedModelCodec<S, B, E>();

  @override
  ModelUndoState get undoState => ModelUndoState(
        undo: canUndo(),
        redo: canRedo(),
      );
}
