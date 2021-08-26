import 'dart:collection';
import 'dart:convert';

import '../converter_function.dart';
import '../event_sourcing.dart';

class _EventListNode<E> extends LinkedListEntry<_EventListNode<E>> {
  _EventListNode(this.entry);
  final E entry;
}

/// An [Codec] which can [encode] and [decode] an
/// [SinglyLinkedEventSourcedModel].
class SinglyLinkedEventSourcedModelCodec<
        S extends EventSourcedSnapshot<S, B, E>,
        B extends EventSourcedSnapshotBuilder<S, B, E>,
        E extends EventSourcedEvent<S, B, E>>
    extends Codec<SinglyLinkedEventSourcedModel<S, B, E>,
        Map<String, dynamic>> {
  /// Create an [SinglyLinkedEventSourcedModelCodec].
  const SinglyLinkedEventSourcedModelCodec();

  @override
  Converter<Map<String, dynamic>, SinglyLinkedEventSourcedModel<S, B, E>>
      get decoder =>
          ConverterFn((m) => SinglyLinkedEventSourcedModel<S, B, E>._(
                initialState:
                    ArgumentError.checkNotNull(m['initialState'] as S?),
                state: m['state'] as S,
                eventList: LinkedList()
                  ..addAll(ArgumentError.checkNotNull(m['eventList'] as List?)
                      .cast<E>()
                      .map((e) => _EventListNode(e))),
              ));

  @override
  Converter<SinglyLinkedEventSourcedModel<S, B, E>, Map<String, dynamic>>
      get encoder => ConverterFn((t) => <String, dynamic>{
            'initialState': t.initialState,
            'state': t._snapshot,
            'eventList': t._eventList.map((e) => e.entry).toList(),
          });
}

/// An [EventSourcedModel] which uses an [LinkedList] as the backing data
/// structure.
class SinglyLinkedEventSourcedModel<
    S extends EventSourcedSnapshot<S, B, E>,
    B extends EventSourcedSnapshotBuilder<S, B, E>,
    E extends EventSourcedEvent<S, B, E>> extends EventSourcedModel<S, B, E> {
  /// Create an [SinglyLinkedEventSourcedModel]
  SinglyLinkedEventSourcedModel(S initialState)
      : _eventList = LinkedList<_EventListNode<E>>(),
        super(initialState);

  SinglyLinkedEventSourcedModel._(
      {required S initialState,
      required S state,
      required LinkedList<_EventListNode<E>> eventList})
      : _snapshot = state,
        _eventList = eventList,
        super(initialState);

  final LinkedList<_EventListNode<E>> _eventList;

  @override
  S add(E event) {
    _eventList.add(_EventListNode<E>(event));
    return _snapshot = snapshot.rebuild(event.applyTo);
  }

  @override
  S addAll(Iterable<E> events) {
    final b = snapshot.toBuilder();
    for (final e in events) {
      _eventList.add(_EventListNode<E>(e));
      e.applyTo(b);
    }
    return _snapshot = b.build();
  }

  @override
  S get snapshot => _snapshot ?? initialState;
  S? _snapshot;

  @override
  ModelUndoState get undoState => const ModelUndoState();

  @override
  Codec<EventSourcedModel<S, B, E>, Map<String, dynamic>> get codec =>
      SinglyLinkedEventSourcedModelCodec<S, B, E>();
}
