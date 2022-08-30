library utils.undotree;

import 'dart:convert';

import 'package:meta/meta.dart';

import 'extensions.dart';
import 'graph.dart';
import 'maybe.dart';

part 'src/undotree_codec.dart';

abstract class UndoTreeNode<E> extends TreeNode<Maybe<E>> {}

// No value. Walks across every alt value from [head].
class UndoTreeRootNode<E> extends UndoTreeNode<E> {
  UndoTreeRootNode(UndoHeader<E>? tail) {
    if (tail == null) {
      return;
    }
    edges.addAll(tail.altIter().map((e) => UndoTreeValueNode(e)));
  }

  @override
  final Set<UndoTreeNode<E>> edges = {};

  @override
  final Maybe<E> value = const None();
}

// Contains value from [head]. Walks across every alt value from [head.next].
class UndoTreeValueNode<E> extends UndoTreeNode<E> {
  // ignore: prefer_initializing_formals
  UndoTreeValueNode(UndoHeader<E> curr) : header = curr {
    if (curr.next == null) {
      return;
    }
    edges.addAll(curr.next!.altIter().map((e) => UndoTreeValueNode(e)));
  }
  @override
  final Set<UndoTreeNode<E>> edges = {};

  @override
  Maybe<E> get value => Just(header.entry);
  final UndoHeader<E> header;
}

/// An tree of entries which are doubly linked from [head] to [tail], and are
/// also doubly linked with an alternate values, resulting in the tree
/// structure.
class UndoTree<E> {
  int _length = 0;
  final _headerList = <UndoHeader<E>>[];

  /// The current head of the tree.
  UndoHeader<E>? get head => _head;
  UndoHeader<E>? _head;

  /// The current tail of the tree.
  UndoHeader<E>? get tail => _tail;
  UndoHeader<E>? _tail;

  /// The current entry on the tree.
  UndoHeader<E>? get current => __current;
  // needed for _current ??= other
  UndoHeader<E>? get _current => __current;
  UndoHeader<E>? __current;
  set _current(UndoHeader<E>? current) {
    __current = current;

    /// If there is an previous node, point it to the [current] node, so that
    /// walking from the tail we end up at [current].
    if (current?.prev != null) {
      current!.prev!.next = current;
    }
  }

  /// The current [E] value of the tree.
  E? get entry => current?.entry;

  /// Add an [entry] to the tree, and return the index it will occupy.
  ///
  /// If the tree contains [next] elements, an new subtree will be created,
  /// otherwise, it will be added to the [head] of the current subtree.
  ///
  /// If the tree was not initialized, it will be with [entry] as the root.
  int add(E entry) {
    final i = _length++;
    // if the undo tree is empty, set the current, the head and the tail.
    if (tail == null) {
      _headerList.add(_current = _head = _tail = UndoHeader(entry, i));
      assert(_headerList[i] == current);
      return i;
    }

    // otherwise, set only the current and the head.
    _headerList.add(_head = _current = current!.add(entry, i));
    assert(_headerList[i] == current);
    return i;
  }

  /// Whether or not an [undo] can be performed. This is the case when the tree
  /// is initialized and there is an [prev] element.
  bool canUndo() => current != null && current!.prev != null;

  /// Changes [current] to be [prev] if possible, returning the previous
  /// [current] if so, and [null] otherwise.
  E? undo() {
    if (!canUndo()) {
      return null;
    }
    final oldCurrent = current!;
    _current = oldCurrent.prev;
    return oldCurrent.entry;
  }

  /// Whether or not an [redo] can be performed. This is the case when the tree
  /// is initialized and there is an [next] element.
  bool canRedo() => current != null && current!.next != null;

  /// Changes [current] to be [next] if possible, returning the new [current]
  /// if so, and [null] otherwise.
  E? redo() {
    if (!canRedo()) {
      return null;
    }
    _current = current!.next;
    return current!.entry;
  }

  /// Whether or not an [prevAlt] can be performed. This is the case when the
  /// tree is initialized and there is an [prevAlt] element.
  bool canPrevAlt() => current != null && current!.prevAlt != null;

  /// Changes [current] to be [prevAlt] if possible, returning the new [current]
  /// if so, and [null] otherwise.
  E? prevAlt() {
    if (!canPrevAlt()) {
      return null;
    }
    _current = current!.prevAlt;
    _head = current!.head();
    return current!.entry;
  }

  /// Whether or not an [nextAlt] can be performed. This is the case when the
  /// tree is initialized and there is an [nextAlt] element.
  bool canNextAlt() => current != null && current!.nextAlt != null;

  /// Changes [current] to be [nextAlt] if possible, returning the new [current]
  /// if so, and [null] otherwise.
  E? nextAlt() {
    if (!canNextAlt()) {
      return null;
    }
    _current = current!.nextAlt;
    _head = current!.head();
    return current!.entry;
  }

  /// The amount of [E]s contained in this tree.
  int get length => _length;
}

/// An header with an final [entry], which is doubly linked with an chain of
/// headers, while also being doubly linked with an chain of adjacent headers,
/// resulting in a tree like structure.
class UndoHeader<E> {
  /// Create an header for the [entry] that occupies [index].
  ///
  /// [visibleForTesting] because it may only be created by the [UndoTree] it
  /// occupies normally.
  @visibleForTesting
  UndoHeader(this.entry, this.index);

  /// The [E] value that is held by this [UndoHeader]
  final E entry;

  /// The [index] this [UndoHeader] occupies in the [UndoTree]
  final int index;

  /// The previous [UndoHeader]. If we are the tail, or not linked yet, it is
  /// null.
  UndoHeader<E>? prev;

  /// The next [UndoHeader]. If we are the head, or not linked yet, it is null.
  UndoHeader<E>? next;

  /// Append the [entry] to the end of the [UndoHeader] linked list, so that
  /// it becomes the new [head].
  UndoHeader<E> append(E entry, int i) {
    final newHeader = UndoHeader<E>(entry, i);
    final UndoHeader<E> head = this.head();

    // Link with the head
    newHeader.prev = head;
    head.next = newHeader;
    return newHeader;
  }

  /// Add the [entry] to the current branch. If we are a head, [append] it,
  /// otherwise [appendAlt].
  UndoHeader<E> add(E entry, int i) {
    // We are at the tip of the tree, so we just append it
    if (next == null) {
      return append(entry, i);
    }
    // We need to add an new alt branch to the next element.
    return next!.appendAlt(entry, i);
  }

  /// An iterable which walks the [UndoHeader] linked list from the
  /// [tail] to the [head], passing through [this].
  Iterable<UndoHeader<E>> entriesIter() sync* {
    final previous = prevsIter().toList(growable: false);
    yield* previous.reversed;
    yield this;
    yield* nextsIter();
  }

  /// An iterable which walks the [UndoHeader] linked list from [this]
  /// to the [head].
  Iterable<UndoHeader<E>> nextsIter() sync* {
    if (next == null) {
      return;
    }
    for (UndoHeader<E>? next = this.next; next != null; next = next.next) {
      yield next;
    }
  }

  /// An iterable which walks the [UndoHeader] linked list backwards from [this]
  /// to the [tail].
  Iterable<UndoHeader<E>> prevsIter() sync* {
    if (prev == null) {
      return;
    }
    for (UndoHeader<E>? prev = this.prev; prev != null; prev = prev.prev) {
      yield prev;
    }
  }

  /// The head of the current [UndoHeader] linked list.
  UndoHeader<E> head() {
    late UndoHeader<E> head;
    for (UndoHeader<E>? next = this; next != null; next = next.next) {
      head = next;
    }
    return head;
  }

  /// The tail of the current [UndoHeader] linked list.
  UndoHeader<E> tail() {
    late UndoHeader<E> tail;
    for (UndoHeader<E>? prev = this; prev != null; prev = prev.prev) {
      tail = prev;
    }
    return tail;
  }

  /// The previous [UndoHeader] node on the alt linked list.
  UndoHeader<E>? prevAlt;

  /// The next [UndoHeader] node on the alt linked list.
  UndoHeader<E>? nextAlt;

  /// Append the [entry] to the end of the alt [UndoHeader] linked list, so that
  /// it becomes the new [altHead].
  UndoHeader<E> appendAlt(E entry, int i) {
    final newHeader = UndoHeader<E>(entry, i);
    final altHeader = altHead();

    // Link with the previous headers
    newHeader.prev = prev;

    // Link with the altHead
    newHeader.prevAlt = altHeader;
    altHeader.nextAlt = newHeader;
    return newHeader;
  }

  /// An iterable which walks the alt [UndoHeader] linked list from the
  /// [altTail] to the [altHead].
  Iterable<UndoHeader<E>> altIter() sync* {
    for (UndoHeader<E>? tail = altTail(); tail != null; tail = tail.nextAlt) {
      yield tail;
    }
  }

  /// The head of the current alt [UndoHeader] linked list.
  UndoHeader<E> altHead() {
    late UndoHeader<E> head;
    for (UndoHeader<E>? next = this; next != null; next = next.nextAlt) {
      head = next;
    }
    return head;
  }

  /// The tail of the current alt [UndoHeader] linked list.
  UndoHeader<E> altTail() {
    late UndoHeader<E> tail;
    for (UndoHeader<E>? prev = this; prev != null; prev = prev.prevAlt) {
      tail = prev;
    }
    return tail;
  }
}
