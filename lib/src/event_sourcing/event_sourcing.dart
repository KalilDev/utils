import 'dart:convert';

export 'data.dart';

/// An event sourced model which can add events, moving forward.
abstract class EventSourcedModel<
    S extends EventSourcedSnapshot<S, B, E>/*!*/,
    B extends EventSourcedSnapshotBuilder<S, B, E>,
    E extends EventSourcedEvent<S, B, E>> {
  EventSourcedModel(this.initialState);

  final S initialState;

  S get snapshot;
  S add(E event);

  S addAll(Iterable<E> events);

  Codec<EventSourcedModel<S, B, E>, Map<String, dynamic>> get codec;
  ModelUndoState get undoState;
}

/// An snapshot of the current [EventSourcedModel]. It should be immutable,
/// and the only way to change it is via an [EventSourcedSnapshotBuilder].
abstract class EventSourcedSnapshot<
    S extends EventSourcedSnapshot<S, B, E>,
    B extends EventSourcedSnapshotBuilder<S, B, E>,
    E extends EventSourcedEvent<S, B, E>> {
  // ignore: public_member_api_docs
  B toBuilder();
  // ignore: public_member_api_docs
  S rebuild(void Function(B bdr) updates);
}

/// An mutable [Builder] that can create an immutable [EventSourcedSnapshot] for
/// an [EventSourcedModel].
abstract class EventSourcedSnapshotBuilder<
    S extends EventSourcedSnapshot<S, B, E>,
    B extends EventSourcedSnapshotBuilder<S, B, E>,
    E extends EventSourcedEvent<S, B, E>> {
  // ignore: public_member_api_docs
  void replace(EventSourcedSnapshot<S, B, E> other);
  // ignore: public_member_api_docs
  void update(void Function(EventSourcedSnapshotBuilder<S, B, E>) updates);
  // ignore: public_member_api_docs
  S build();
}

/// An event that can mutate an [EventSourcedModel] by performing changes to an
/// [EventSourcedSnapshotBuilder] forwards.
// ignore: one_member_abstracts
abstract class EventSourcedEvent<
    S extends EventSourcedSnapshot<S, B, E>,
    B extends EventSourcedSnapshotBuilder<S, B, E>,
    E extends EventSourcedEvent<S, B, E>> {
  /// Perform the modifications to an [bdr] so that it contains the mutations
  /// performed by this event.
  void applyTo(B bdr);
}

/// An event that can mutate an [EventSourcedModel] by performing changes to an
/// [EventSourcedSnapshotBuilder] both forwards and backwards.
abstract class UndoableEventSourcedEvent<
        S extends EventSourcedSnapshot<S, B, E>,
        B extends EventSourcedSnapshotBuilder<S, B, E>,
        E extends UndoableEventSourcedEvent<S, B, E>>
    extends EventSourcedEvent<S, B, E> {
  /// Perform the modifications to an [bdr] so that it does not contains the
  /// mutations performed by this event anymore.
  void undoTo(B bdr);
}

/// An event sourced model which can add events, moving forward and move the
/// event cursor backwards, moving backwards.
abstract class UndoableEventSourcedModel<
        S extends EventSourcedSnapshot<S, B, E>/*!*/,
        B extends EventSourcedSnapshotBuilder<S, B, E>,
        E extends UndoableEventSourcedEvent<S, B, E>>
    extends EventSourcedModel<S, B, E> {
  /// Create an [UndoableEventSourcedModel].
  UndoableEventSourcedModel(S initialState) : super(initialState);
  bool canUndo();
  bool canRedo();
  bool undo();
  bool redo();
}

/// An event sourced model which can add events, moving forward, move the
/// event cursor backwards, moving backwards and creating subbranches when
/// adding events while not on a tip.
abstract class TreeUndoableEventSourcedModel<
        S extends EventSourcedSnapshot<S, B, E>/*!*/,
        B extends EventSourcedSnapshotBuilder<S, B, E>,
        E extends UndoableEventSourcedEvent<S, B, E>/*!*/>
    extends UndoableEventSourcedModel<S, B, E> {
  /// Create an [TreeUndoableEventSourcedModel].
  TreeUndoableEventSourcedModel(S initialState) : super(initialState);

  bool canNextAlt();
  bool nextAlt();
  bool canPrevAlt();
  bool prevAlt();
}

/// An class which contains the information about undoing at the current
/// [EventSourcedModel] state.
/// [null] at the fields means the operation is not supported by the
/// [EventSourcedModel] in question.
class ModelUndoState {
  const ModelUndoState({
    this.undo,
    this.redo,
    this.nextAlt,
    this.prevAlt,
  });

  final bool undo;
  final bool redo;
  final bool nextAlt;
  final bool prevAlt;
}
