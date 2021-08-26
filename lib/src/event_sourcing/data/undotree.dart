import 'dart:convert';

import 'package:utils/undotree.dart';

import '../converter_function.dart';
import '../event_sourcing.dart';

/// An [Codec] which can [encode] and [decode] an [UndoTreeEventSourcedModel].
class UndoTreeEventSourcedModelCodec<
        S extends EventSourcedSnapshot<S, B, E>,
        B extends EventSourcedSnapshotBuilder<S, B, E>,
        E extends UndoableEventSourcedEvent<S, B, E>>
    extends Codec<UndoTreeEventSourcedModel<S, B, E>, Map<String, dynamic>> {
  /// Create an [UndoTreeEventSourcedModelCodec].
  const UndoTreeEventSourcedModelCodec();

  Codec<UndoTree<E /*?*/ >, Map<String, dynamic>> get _undoTreeCodec =>
      UndoTreeCodec<E>();

  @override
  Converter<Map<String, dynamic>, UndoTreeEventSourcedModel<S, B, E>>
      get decoder => ConverterFn((m) => UndoTreeEventSourcedModel<S, B, E>._(
            initialState: ArgumentError.checkNotNull(m['initialState'] as S?),
            state: m['state'] as S? ??
                ArgumentError.checkNotNull(m['initialState'] as S?),
            tree: _undoTreeCodec.decode(ArgumentError.checkNotNull(
              m['tree'] as Map<String, dynamic>?,
            )),
          ));

  @override
  Converter<UndoTreeEventSourcedModel<S, B, E>, Map<String, dynamic>>
      get encoder => ConverterFn((t) => <String, dynamic>{
            'initialState': t.initialState,
            'state': t._snapshot,
            'tree': _undoTreeCodec.encode(t._tree as UndoTree<E>),
          });
}

/// An [TreeUndoableEventSourcedModel] which uses an [UndoTree] as the backing
/// data structure.
class UndoTreeEventSourcedModel<
        S extends EventSourcedSnapshot<S, B, E>,
        B extends EventSourcedSnapshotBuilder<S, B, E>,
        E extends UndoableEventSourcedEvent<S, B, E>>
    extends TreeUndoableEventSourcedModel<S, B, E> {
  /// Create an [UndoTreeEventSourcedModel] from an [initialState]
  UndoTreeEventSourcedModel(S initialState)
      : _tree = UndoTree<E?>()..add(null),
        super(initialState);

  UndoTreeEventSourcedModel._(
      {required S initialState, required S state, required UndoTree<E?> tree})
      : _tree = tree,
        _snapshot = state,
        super(initialState);

  final UndoTree<E?> _tree;

  @override
  S add(E event) {
    _tree.add(event);
    return _snapshot = snapshot.rebuild(event.applyTo);
  }

  @override
  S addAll(Iterable<E> events) {
    final sb = snapshot.toBuilder();
    for (final e in events) {
      _tree.add(e);
      sb.update(
          e.applyTo as void Function(EventSourcedSnapshotBuilder<S, B, E>));
    }
    return _snapshot = sb.build();
  }

  @override
  bool canNextAlt() => _tree.canNextAlt();

  @override
  bool canPrevAlt() => _tree.canPrevAlt();

  @override
  bool canRedo() => _tree.canRedo();

  @override
  bool canUndo() => _tree.canUndo();

  @override
  bool nextAlt() {
    final oldCurr = _tree.current!.entry;
    final e = _tree.nextAlt();
    if (e == null) {
      return false;
    }
    _snapshot = snapshot.rebuild((b) => b
      ..update(oldCurr!.undoTo as void Function(
          EventSourcedSnapshotBuilder<S, B, E>))
      ..update(
          e.applyTo as void Function(EventSourcedSnapshotBuilder<S, B, E>)));
    return true;
  }

  @override
  bool prevAlt() {
    final oldCurr = _tree.current!.entry;
    final e = _tree.prevAlt();
    if (e == null) {
      return false;
    }
    _snapshot = snapshot.rebuild((b) => b
      ..update(oldCurr!.undoTo as void Function(
          EventSourcedSnapshotBuilder<S, B, E>))
      ..update(
          e.applyTo as void Function(EventSourcedSnapshotBuilder<S, B, E>)));
    return true;
  }

  @override
  bool redo() {
    final e = _tree.redo();
    if (e == null) {
      return false;
    }
    _snapshot = snapshot.rebuild(e.applyTo);
    return true;
  }

  @override
  bool undo() {
    final e = _tree.undo();
    // If we hit the bottom of the tree
    if (e == null) {
      return false;
    }
    _snapshot = snapshot.rebuild(e.undoTo);
    return true;
  }

  E? get currentEvent => _tree.current?.entry;

  @override
  S get snapshot => _snapshot ?? initialState;
  S? _snapshot;

  @override
  Codec<UndoTreeEventSourcedModel<S, B, E>, Map<String, dynamic>> get codec =>
      const UndoTreeEventSourcedModelCodec();

  @override
  ModelUndoState get undoState => ModelUndoState(
        undo: canUndo(),
        redo: canRedo(),
        nextAlt: canNextAlt(),
        prevAlt: canPrevAlt(),
      );
}
