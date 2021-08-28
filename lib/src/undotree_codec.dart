part of '../undotree.dart';

/// This [Codec] encodes an [UndoTree] into an json compatible map, and decodes
/// into an fresh [UndoTree].
class UndoTreeCodec<E> extends Codec<UndoTree<E>, Map<String, dynamic>> {
  @override
  final UndoTreeDecoder<E> decoder = UndoTreeDecoder<E>();

  @override
  final UndoTreeEncoder<E> encoder = UndoTreeEncoder<E>();
}

/// This class serializes an [UndoTree] of [E] into an json compatible map.
class UndoTreeEncoder<E> extends Converter<UndoTree<E>, Map<String, dynamic>> {
  const UndoTreeEncoder();
  @override
  Map<String, dynamic> convert(UndoTree<E> input) {
    final entries = input._headerList.map((h) => h.entry).toList();
    final tails = input.tail?.altIter() ?? [];
    final indices = Map<String, dynamic>.fromEntries(tails.map(_walkHeader));
    final nextIndices =
        input._headerList.map((h) => h.next?.index ?? -1).toList();
    final length = input._length;
    final current = input.current?.index;

    return <String, dynamic>{
      'length': length,
      'current': current,
      'entries': entries,
      'nextIndices': nextIndices,
      'indices': indices,
    };
  }

  /// Walk an header producing an entry with its index as a key, and itself,
  /// along with the other alt headers as the children, inside an map on the
  /// value.
  MapEntry<String, dynamic> _walkHeader(UndoHeader h) {
    final childIter = h.next?.altIter() ?? [];
    final children =
        Map<String, dynamic>.fromEntries(childIter.map(_walkHeader));

    return MapEntry<String, dynamic>(h.index.toString(), children);
  }
}

/// This class deserializes an json compatible map into an [UndoTree] of [E].
///
/// It uses private member access in the [UndoTree] because if those apis were
/// public, the tree would be easily corrupted.
class UndoTreeDecoder<E> extends Converter<Map<String, dynamic>, UndoTree<E>> {
  const UndoTreeDecoder();
  static const _keys = {
    'length',
    'current',
    'entries',
    'nextIndices',
    'indices',
  };
  @override
  UndoTree<E> convert(Map<String, dynamic> input) {
    if (!input.keys.toSet().containsAll(_keys)) {
      throw const FormatException();
    }
    final length = input['length'] as int;
    final current = input['current'] as int?;
    final entries = (input['entries'] as List).cast<E>();
    final nextIndices = (input['nextIndices'] as List).cast<int>();
    final indices = input['indices'] as Map<String, dynamic>;

    if (entries.length != length || nextIndices.length != length) {
      throw const FormatException();
    }
    // Use this list instead of the one in the [UndoTree] because it is not
    // nullable, therefore setting the length would be invalid;
    final headerList = List<UndoHeader<E>?>.filled(length, null);

    /// Create the headers, by walking the [indices] and adding the respective
    /// entry.
    final root = _recursiveWalkAdjacent(
      indices,
      entries,
      (e, i) => UndoHeader<E>(e, i), // Create an root node
      (e) => headerList[e.index] = e,
    );

    /// Point every header to the correct next header
    for (var i = 0; i < nextIndices.length - 1; i++) {
      final nextI = nextIndices[i];
      if (nextI == -1) {
        continue;
      }
      headerList[i]!.next = headerList[nextI];
    }

    final result = UndoTree<E>().._length = length;

    if (current != null) {
      result._current = headerList[current];
    }
    result._current ??= root;
    result._tail = result.current!.tail();
    result._head = result.current!.head();

    result._headerList.addAll(headerList.cast());

    return result;
  }

  /// Walk every index-children pair in [adjacentIndices], create an [localRoot]
  /// by using [appendToPrevious] on the first pair, and then walk every
  /// children in the pair with [child.append] as the [appendToPrevious]
  /// argument.
  UndoHeader<E>? _recursiveWalkAdjacent(
    Map<String, dynamic> adjacentIndices,
    List<E> entries,
    UndoHeader<E> Function(E, int) appendToPrevious,
    void Function(UndoHeader<E>) onCreated,
  ) {
    UndoHeader<E>? localRoot;
    for (final e in adjacentIndices.entries) {
      final i = int.parse(e.key);
      final children = e.value as Map<dynamic, dynamic>;

      UndoHeader<E> child;
      if (localRoot == null) {
        child = localRoot = appendToPrevious(entries[i], i);
      } else {
        child = localRoot.appendAlt(entries[i], i);
      }
      onCreated(child);
      if (children.isNotEmpty) {
        _recursiveWalkAdjacent(
          children.cast<String, dynamic>(),
          entries,
          child.append,
          onCreated,
        );
      }
    }
    return localRoot;
  }
}
