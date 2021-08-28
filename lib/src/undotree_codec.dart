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
  const UndoTreeEncoder([int codecVersion = 1])
      : _codecVersion = codecVersion,
        assert(codecVersion >= 0 && codecVersion < 2);

  final int _codecVersion;

  List<_UndoTreeEncoder<E>> get _kCodecEncoders => [_encoderV0, _encoderV1];
  static Map<String, dynamic> _encoderV0<E>(UndoTree<E> input) {
    /// Walk an header producing an entry with its index as a key, and itself,
    /// along with the other alt headers as the children, inside an map on the
    /// value.
    MapEntry<String, dynamic> _walkHeader(UndoHeader h) {
      final childIter = h.next?.altIter() ?? [];
      final children =
          Map<String, dynamic>.fromEntries(childIter.map(_walkHeader));

      return MapEntry<String, dynamic>(h.index.toString(), children);
    }

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

  static Map<String, dynamic> _encoderV1<E>(UndoTree<E> input) {
    final entries = input._headerList.map((h) => h.entry).toList();
    final edges = input._headerList
        .map((e) => [
              e.prev?.index,
              e.next?.index,
              e.prevAlt?.index,
              e.nextAlt?.index,
            ])
        .toList();
    final length = input._length;
    final current = input.current?.index;
    final head = input.head?.index;

    return <String, dynamic>{
      'length': length,
      'current': current,
      'head': head,
      'entries': entries,
      'edges': edges,
      'codecVersion': 1,
    };
  }

  @override
  Map<String, dynamic> convert(UndoTree<E> input) =>
      _kCodecEncoders[_codecVersion](input);
}

typedef _UndoTreeEncoder<E> = Map<String, dynamic> Function(UndoTree<E>);
typedef _UndoTreeDecoder<E> = UndoTree<E> Function(Map<String, dynamic>);

/// This class deserializes an json compatible map into an [UndoTree] of [E].
///
/// It uses private member access in the [UndoTree] because if those apis were
/// public, the tree would be easily corrupted.
class UndoTreeDecoder<E> extends Converter<Map<String, dynamic>, UndoTree<E>> {
  const UndoTreeDecoder();

  @override
  UndoTree<E> convert(Map<String, dynamic> input) {
    final codecVersion = input['codecVersion'] as int? ?? 0;

    if (_kCodecDecoders.length < codecVersion) {
      throw const FormatException();
    }
    if (!_kCodecRequiredKeys[codecVersion].containsAll(input.keys.toSet())) {
      throw const FormatException();
    }

    return _kCodecDecoders[codecVersion](input);
  }

  static const _kCodecRequiredKeys = [
    {
      'length',
      'current',
      'entries',
      'nextIndices',
      'indices',
    },
    {
      'length',
      'current',
      'head',
      'entries',
      'edges',
      // The omission of the codecVersion parameter is only allowed on the first
      // codec
      'codecVersion'
    }
  ];

  List<_UndoTreeDecoder<E>> get _kCodecDecoders => [_decoderV0, _decoderV1];

  static UndoTree<E> _decoderV0<E>(Map<String, dynamic> input) {
    final length = input['length'] as int;
    final current = input['current'] as int?;
    final entries = (input['entries'] as List).cast<E>();
    final nextIndices = (input['nextIndices'] as List).cast<int>();
    final indices = input['indices'] as Map<String, dynamic>;

    if (entries.length != length || nextIndices.length != length) {
      throw const FormatException();
    }

    /// Walk every index-children pair in [adjacentIndices], create an
    /// [localRoot] by using [appendToPrevious] on the first pair, and then walk
    /// every children in the pair with [child.append] as the [appendToPrevious]
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

  static UndoTree<E> _decoderV1<E>(Map<String, dynamic> input) {
    final length = input['length'] as int;
    final current = input['current'] as int?;
    final head = input['head'] as int?;
    final entries = (input['entries'] as List).cast<E>();
    final edges =
        (input['edges'] as List).cast<List>().map((e) => e.cast<int?>());

    if (entries.length !=
            length || /*this is guaranteed to be efficient
            because edges is an MappedListIterable*/
        edges.length != length) {
      throw const FormatException();
    }

    final undoHeaders =
        entries.indexed.map((e) => UndoHeader(e.right, e.left)).toList();
    UndoHeader<E>? get(int? i) => i == null || i == -1 ? null : undoHeaders[i];

    for (final e in edges.zip(undoHeaders)) {
      final edges = e.left;
      final header = e.right;
      if (edges.length != 4) {
        throw const FormatException();
      }
      header
        ..prev = get(edges[0])
        ..next = get(edges[1])
        ..prevAlt = get(edges[2])
        ..nextAlt = get(edges[3]);
    }
    return UndoTree<E>()
      .._length = length
      .._headerList.addAll(undoHeaders)
      .._current = get(current)
      .._tail = length == 0 ? null : undoHeaders.first
      .._head = get(head);
  }
}
