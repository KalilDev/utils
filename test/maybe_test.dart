import 'package:utils/utils.dart' hide type;
import 'package:test/test.dart';

extension _MaybeTest<T> on Maybe<T> {
  T get value => visit(
        just: (v) => v,
        none: () => fail('should be Just<$T>'),
      );
}

void main() {
  group('ext', () {
    Maybe<int> greaterThanOne(int i) =>
        i > 1 ? Just<int>(i) : const None<int>();
    group('MaybeObjectWrapping', () {
      test('maybe', () {
        // ignore: unnecessary_cast
        final maybeNullInt = (null as int).maybe;
        final maybeOne = 1.maybe;
        expect(maybeNullInt, isA<None<int>>());
        expect(maybeOne.value, 1);
      });
      test('just', () {
        // ignore: unnecessary_cast
        final justNullInt = (null as int).just;
        final justOne = 1.just;
        expect(justNullInt.value, null);
        expect(justOne.value, 1);
      });
    });
    group('MaybeIterableCatamorph', () {
      test('cataMaybes', () {
        const none = None<int>();
        const justOne = Just<int>(1);
        expect([none].cataMaybes(), isEmpty);
        expect([none, none].cataMaybes(), isEmpty);
        expect([justOne].cataMaybes(), Iterable.castFrom([1]));
        expect(
            [justOne, none, justOne].cataMaybes(), Iterable.castFrom([1, 1]));
      });
    });
    group('MaybeListTraverse', () {
      Maybe<int> indexGreaterThanOne(int v, [int i]) =>
          i > 1 ? Just<int>(v) : const None<int>();
      final emptyList = <int>[];
      final list = <int>[0, 1, 2, 1];
      test('traverse', () {
        expect(
          emptyList.traverse(greaterThanOne),
          isA<None<List<int>>>(),
        );
        expect(
          emptyList.traverse(indexGreaterThanOne),
          isA<None<List<int>>>(),
        );
        expect(
          list.traverse(greaterThanOne).value,
          [2],
        );
        expect(
          list.traverse(indexGreaterThanOne).value,
          [2, 1],
        );
      });
    });
    group('MaybeIterableTraverse', () {
      Maybe<int> greaterThanOne(int i) =>
          i > 1 ? Just<int>(i) : const None<int>();
      const emptyIter = Iterable<int>.empty();
      final iter = <int>[0, 1, 2, 1].map((e) => e);
      test('traverse', () {
        expect(
          emptyIter.traverse(greaterThanOne),
          isA<None<List<int>>>(),
        );
        expect(
          iter.traverse(greaterThanOne).value,
          [2],
        );
      });
    });
  });
  group('MaybeApply', () {
    String Function(String) concat(String a) => (String b) => a + b;
    const noneString = None<String>();
    const justHello = Just<String>('Hello');
    const justWorld = Just<String>(' World');
    test('apply', () {
      expect(
        concat.just.apply(noneString).apply(noneString),
        isA<None<String>>(),
      );
      expect(
        concat.just.apply(justHello).apply(noneString),
        isA<None<String>>(),
      );
      expect(
        concat.just.apply(noneString).apply(justWorld),
        isA<None<String>>(),
      );
      expect(
        concat.just.apply(justHello).apply(justWorld).value,
        'Hello World',
      );
    });
    test('>>', () {
      expect(
        concat.just >> noneString >> noneString,
        isA<None<String>>(),
      );
      expect(
        concat.just >> justHello >> noneString,
        isA<None<String>>(),
      );
      expect(
        concat.just >> noneString >> justWorld,
        isA<None<String>>(),
      );
      expect(
        (concat.just >> justHello >> justWorld).value,
        'Hello World',
      );
    });
  });
  group('Maybe', () {
    test('fromNullable', () {
      expect(Maybe.fromNullable<int>(1), isA<Just<int>>());
      expect(Maybe.fromNullable<int>(null), isA<None<int>>());
    });
    test('just', () {
      expect(Maybe.just<int>(1), isA<Just<int>>());
      expect(Maybe.just<int>(null), isA<Just<int>>());
    });
    test('none', () {
      expect(Maybe.none<int>(), isA<None<int>>());
      expect(Maybe.none<double>(), isA<None<double>>());
    });
    test('unit', () {
      const none = None<int>();
      const one = Just<int>(1);
      expect(none.unit<double>(2).value, 2.0);
      expect(one.unit<double>(2).value, 2.0);
    });
    test('identity', () {
      const none = None<int>();
      const one = Just<int>(1);
      expect(none.identity<double>(), isA<None<double>>());
      expect(one.identity<double>(), isA<None<double>>());
    });
    test('fromOperation', () {
      expect(Maybe.fromOperation<int>(() => 1), isA<Just<int>>());
      expect(Maybe.fromOperation<int>(() => null), isA<None<int>>());
      expect(
          Maybe.fromOperation<int>(() => throw Exception()), isA<None<int>>());
      expect(() => Maybe.fromOperation<int>(() => throw ''), throwsA(anything));
    });
    test('nullableFromOperation', () {
      expect(Maybe.nullableFromOperation<int>(() => 1), isA<Just<int>>());
      expect(Maybe.nullableFromOperation<int>(() => null), isA<Just<int>>());
      expect(Maybe.nullableFromOperation<int>(() => throw Exception()),
          isA<None<int>>());
      expect(() => Maybe.nullableFromOperation<int>(() => throw ''),
          throwsA(anything));
    });
    test('fromAsyncOperation', () async {
      expect(
          await Maybe.fromAsyncOperation<int>(() async => 1), isA<Just<int>>());
      expect(await Maybe.fromAsyncOperation<int>(() async => null),
          isA<None<int>>());
      expect(await Maybe.fromAsyncOperation<int>(() async => throw Exception()),
          isA<None<int>>());
      expect(Maybe.fromAsyncOperation<int>(() async => throw ''),
          throwsA(anything));
    });
    test('nullableFromAsyncOperation', () async {
      expect(await Maybe.nullableFromAsyncOperation<int>(() async => 1),
          isA<Just<int>>());
      expect(await Maybe.nullableFromAsyncOperation<int>(() async => null),
          isA<Just<int>>());
      expect(
          await Maybe.nullableFromAsyncOperation<int>(
              () async => throw Exception()),
          isA<None<int>>());
      expect(Maybe.nullableFromAsyncOperation<int>(() async => throw ''),
          throwsA(anything));
    });
    test('map', () {
      const noneInt = None<int>();
      const justInt = Just<int>(1);
      expect(noneInt.map((v) => 2.0 * v), isA<None<double>>());
      expect(justInt.map((v) => 2.0 * v).value, 2.0);
    });
    test('fmap', () {
      const noneInt = None<int>();
      const justInt = Just<int>(1);
      expect(noneInt.fmap((v) => 2.0 * v), isA<None<double>>());
      expect(justInt.fmap((v) => 2.0 * v).value, 2.0);
    });
    test('bind', () {
      const noneInt = None<int>();
      const justOne = Just<int>(1);
      const justTwo = Just<int>(2);
      Maybe<double> maybeDouble(int i) =>
          i == 2 ? const None<double>() : Just<double>(2.0 * i);
      expect(noneInt.bind(maybeDouble), isA<None<double>>());
      expect(justOne.bind(maybeDouble).value, 2.0);
      expect(justTwo.bind(maybeDouble), isA<None<double>>());
    });
    test('filter', () {
      const noneInt = None<int>();
      const justOne = Just<int>(1);
      const justTwo = Just<int>(2);
      bool notTwo(int i) => i != 2;
      expect(noneInt.filter(notTwo), isA<None<int>>());
      expect(justOne.filter(notTwo).value, 1);
      expect(justTwo.filter(notTwo), isA<None<int>>());
    });
    test('filterNonNullable', () {
      const noneInt = None<int>();
      const justOne = Just<int>(1);
      const justNull = Just<int>(null);
      expect(noneInt.filterNonNullable(), isA<None<int>>());
      expect(justOne.filterNonNullable(), isA<Just<int>>());
      expect(justNull.filterNonNullable(), isA<None<int>>());
    });
    test('fillWhenNone', () {
      const noneInt = None<int>();
      const justTwo = Just<int>(2);
      expect(noneInt.fillWhenNone(1).value, 1);
      expect(justTwo.fillWhenNone(1).value, 2);
    });
    test('valueOrElse', () {
      const noneInt = None<int>();
      const justOne = Just<int>(1);
      expect(noneInt.valueOrElse(2), 2);
      expect(justOne.valueOrElse(2), 1);
    });
    test('valueOr', () {
      const noneInt = None<int>();
      const justOne = Just<int>(1);
      expect(noneInt.valueOr(2), 2);
      expect(justOne.valueOr(2), 1);
    });
    test('valueOrGet', () {
      const noneInt = None<int>();
      const justOne = Just<int>(1);
      expect(noneInt.valueOrGet(() => 2), 2);
      expect(justOne.valueOrGet(() => 2), 1);
    });
    test('visit', () {
      const noneInt = None<int>();
      const justOne = Just<int>(1);
      expect(
        noneInt.visit<double>(just: (_) => fail('Not just'), none: () => 2.0),
        2.0,
      );

      expect(
        justOne.visit<double>(
            none: () => fail('Not none'), just: (i) => 3.0 * i),
        3.0,
      );
    });
    test('lift', () {
      // ignore: unnecessary_parenthesis
      final justFn = ((int i) => 2.0).just;
      const noneInt = None<int>();
      const justOne = Just<int>(1);
      expect(noneInt.lift(justFn, noneInt), isA<None<double>>());
      expect(justOne.lift(justFn, noneInt), isA<None<double>>());
      expect(noneInt.lift(justFn, justOne).value, 2.0);
      expect(justOne.lift(justFn, justOne).value, 2.0);
    });
    test('==', () {
      const noneInt = None<int>();
      const noneDouble = None<double>();
      const justOne = Just<int>(1);
      const otherJustOne = Just<int>(1);
      const justString = Just<String>('');
      expect(noneInt, isNot(equals(noneDouble)));
      expect(noneInt, isNot(equals(justOne)));
      expect(noneDouble, isNot(equals(justOne)));
      expect(justString, isNot(equals(justOne)));
      expect(justOne, equals(otherJustOne));
    });
  });
}
