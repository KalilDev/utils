import 'package:test/test.dart';
import 'package:kalil_utils/graph.dart';
import 'package:kalil_utils/undotree.dart';

String _treeString<T>(UndoTree<T> tree) => treeToString<UndoTreeNode<T>>(
      UndoTreeRootNode<T>(tree.tail),
      (n) => n.value.visit(
        just: (t) => t.toString(),
        none: () => 'root',
      ),
    );

void main() {
  group('UndoTree', () {});
  group('UndoTreeCodec', () {
    final decoder = UndoTreeCodec<int>().decoder;
    final tree = UndoTree<int>();

    /// root
    /// └── 1
    ///    ├── 12
    ///    │   ├── 123
    ///    │   ├── 124
    ///    │   │   └── 1245
    ///    │   └── 125
    ///    └── 13
    tree
      ..add(1)
      ..add(12)
      ..add(123)
      ..undo()
      ..add(124)
      ..add(1245)
      ..undo()
      ..undo()
      ..add(125)
      ..undo()
      ..undo()
      ..add(13);
    final entries = [1, 12, 123, 124, 1245, 125, 13];
    group('V0', () {
      const v0Encoder = UndoTreeEncoder<int>(0);
      test('encode', () {
        final Map<String, dynamic> r = v0Encoder.convert(tree);
        expect(r['length'], entries.length);
        expect(r['current'], tree.current!.index);
        expect(r['entries'], entries);
        expect(r['nextIndices'], [6, 5, -1, 4, -1, -1, -1]);
        expect(r['indices'], {
          '0': {
            '1': {
              '2': <String, dynamic>{},
              '3': {
                '4': <String, dynamic>{},
              },
              '5': <String, dynamic>{},
            },
            '6': <String, dynamic>{},
          },
        });
      });
      test('decode', () {
        final d = {
          'length': 2,
          'current': 0,
          'entries': [1, 12],
          'nextIndices': [1, -1],
          'indices': {
            '0': {'1': <String, dynamic>{}}
          },
        };
        final UndoTree<int> r = decoder.convert(d);
        final prev = r.current!;
        expectTail(r.current!);
        expectAltNotLinked(r.current!);
        expect(r.current!.entry, 1);

        expect(r.redo(), 12);

        expectLinked(prev, r.current!);
        expectHead(r.current!);
        expectAltNotLinked(r.current!);
        expect(r.current!.entry, 12);
      });
      test('encode and decode', () {
        final UndoTree<int> reencoded =
            decoder.convert(v0Encoder.convert(tree));
        // kinda silly
        // TODO: better eq
        expect(_treeString(tree), _treeString(reencoded));
      });
    });

    group('V1', () {
      // ignore: avoid_redundant_argument_values
      const v1Encoder = UndoTreeEncoder<int>(1);
      test('encode', () {
        final Map<String, dynamic> r = v1Encoder.convert(tree);
        expect(r['length'], entries.length);
        expect(r['current'], tree.current!.index);
        expect(r['head'], tree.head!.index);
        expect(r['entries'], entries);
        expect(r['codecVersion'], 1);
        expect(r['edges'], [
          [null, 6, null, null],
          [0, 5, null, 6],
          [1, null, null, 3],
          [1, 4, 2, 5],
          [3, null, null, null],
          [1, null, 3, null],
          [0, null, 1, null],
        ]);
      });
      test('decode', () {
        final d = {
          'length': 2,
          'current': 0,
          'head': 1,
          'entries': [1, 12],
          'edges': [
            [null, 1, null, null],
            [0, null, null, null],
          ],
          'codecVersion': 1,
        };
        final UndoTree<int> r = decoder.convert(d);
        final prev = r.current!;
        expectTail(r.current!);
        expectAltNotLinked(r.current!);
        expect(r.current!.entry, 1);

        expect(r.redo(), 12);

        expectLinked(prev, r.current!);
        expectHead(r.current!);
        expectAltNotLinked(r.current!);
        expect(r.current!.entry, 12);
      });
      test('encode and decode', () {
        final UndoTree<int> reencoded =
            decoder.convert(v1Encoder.convert(tree));
        // kinda silly
        // TODO: better eq
        expect(_treeString(tree), _treeString(reencoded));
      });
    });
  });
  group('UndoHeader', () {
    late UndoHeader<String> root;
    setUp(() => root = UndoHeader<String>('', 0));
    test('append', () {
      final a = root.append('A', 1);
      final ab = a.append('AB', 2);
      expect(root.values, ['', 'A', 'AB']);

      expectTail(root);
      expectLinked(root, a);
      expectLinked(a, ab);
      expectHead(ab);
    });
    test('add', () {
      final a = root.add('A', 1);
      final b = root.add('B', 2);
      final c = root.add('C', 3);
      expect(a.values, ['', 'A']);
      expect(b.values, ['', 'B']);
      expect(c.values, ['', 'C']);

      expectTail(root);
      expectAltNotLinked(root);
      expectLinked(root, a);
      expectAltTail(a);
      expectAltLinked(a, b);
      expectAltLinked(b, c);
      expectAltHead(c);
      expectHead(a);
      expectHead(b);
      expectHead(c);
    });
    test('entriesIter', () {
      final a = root.add('A', 1);
      final b = root.add('B', 2);
      final c = root.add('C', 3);

      expect(root.entriesIter(), [root, a]);

      expect(a.entriesIter(), [root, a]);
      expect(b.entriesIter(), [root, b]);
      expect(c.entriesIter(), [root, c]);
    });
    test('nextsIter', () {
      final a = root.add('A', 1);
      final b = root.add('B', 2);
      final c = root.add('C', 3);

      expect(root.nextsIter(), [a]);

      expect(a.nextsIter(), <UndoHeader<String>>[]);
      expect(b.nextsIter(), <UndoHeader<String>>[]);
      expect(c.nextsIter(), <UndoHeader<String>>[]);
    });
    test('prevsIter', () {
      final a = root.add('A', 1);
      final b = root.add('B', 2);
      final c = root.add('C', 3);

      expect(a.prevsIter(), [root]);
      expect(b.prevsIter(), [root]);
      expect(c.prevsIter(), [root]);
    });
    test('head', () {
      final a = root.append('A', 1);
      final ab = root.append('AB', 2);
      final abc = root.append('ABC', 3);
      expect(root.head(), abc);
      expect(a.head(), abc);
      expect(ab.head(), abc);
      expect(abc.head(), abc);
    });
    test('tail', () {
      final a = root.append('A', 1);
      final ab = root.append('AB', 2);
      final abc = root.append('ABC', 3);
      expect(root.tail(), root);
      expect(a.tail(), root);
      expect(ab.tail(), root);
      expect(abc.tail(), root);
    });
    test('appendAlt', () {
      final a = root.append('A', 1);
      final ab = a.append('AB', 2);
      final ac = ab.appendAlt('AC', 3);
      expect(root.values, ['', 'A', 'AB']);
      expect(ac.values, ['', 'A', 'AC']);

      expectAltLinked(ab, ac);
      expectLinked(a, ab);
      expectAltTail(ab);
      expectAltHead(ac);
      expectHead(ab);
      expectHead(ac);
    });
    test('altIter', () {
      final a = root.add('A', 1);
      final b = root.add('B', 2);
      final c = root.add('C', 3);

      expect(root.altIter(), [root]);

      expect(a.altIter(), [a, b, c]);
      expect(b.altIter(), [a, b, c]);
      expect(c.altIter(), [a, b, c]);
    });
    test('altHead', () {
      final a = root.add('A', 1);
      final b = root.add('B', 2);
      final c = root.add('C', 3);

      expect(root.altHead(), root);

      expect(a.altHead(), c);
      expect(b.altHead(), c);
      expect(c.altHead(), c);
    });
    test('altTail', () {
      final a = root.add('A', 1);
      final b = root.add('B', 2);
      final c = root.add('C', 3);

      expect(root.altTail(), root);

      expect(a.altTail(), a);
      expect(b.altTail(), a);
      expect(c.altTail(), a);
    });
  });
}

void expectLinked(UndoHeader prev, UndoHeader next) {
  expect(prev.next, next);
  expect(next.prev, prev);
}

void expectHead(UndoHeader head) {
  expect(head.next, null);
}

void expectTail(UndoHeader tail) {
  expect(tail.prev, null);
}

void expectAltLinked(UndoHeader prevAlt, UndoHeader nextAlt) {
  expect(prevAlt.nextAlt, nextAlt);
  expect(nextAlt.prevAlt, prevAlt);
}

void expectAltHead(UndoHeader altHead) {
  expect(altHead.nextAlt, null);
}

void expectAltTail(UndoHeader altTail) {
  expect(altTail.prevAlt, null);
}

void expectNotLinked(UndoHeader notLinked) {
  expect(notLinked.next, null);
  expect(notLinked.prev, null);
}

void expectAltNotLinked(UndoHeader altNotLinked) {
  expect(altNotLinked.nextAlt, null);
  expect(altNotLinked.prevAlt, null);
}

extension _ExtractEntries<T> on UndoHeader<T> {
  List<T> get values => entriesIter().map((e) => e.entry).toList();
}
