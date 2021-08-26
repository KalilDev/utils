import 'package:test/test.dart';
import 'package:utils/either.dart';
import 'package:utils/maybe.dart';
import 'package:utils/curry.dart';
import 'package:utils/utils.dart';

Never _fail([dynamic _]) => fail('Should not be called');
void main() {
  group('Either', () {
    test('right/left', () {
      expect(Either.left<int, double>(1), isA<Left<int, double>>());
      expect(Either.right<int, double>(1.0), isA<Right<int, double>>());
    });
    test('identity', () {
      final left = Either.left<int, double>(1);
      final right = Either.right<int, double>(1.0);
      expect(left.identity<String>(), isA<Left<int, String>>());
      expect(right.identity<String>(), isA<Left<int, String>>());
    });
    test('unit', () {
      final left = Either.left<int, double>(1);
      final right = Either.right<int, double>(1.0);
      expect(left.unit<String>(''), isA<Right<int, String>>());
      expect(right.unit<String>(''), isA<Right<int, String>>());
    });
    test('fromComputation lazy', () {
      expect(Either.fromComputation(_fail), isA<Either>());
      expect(
          Either.fromComputation(() => throw Exception()), isNot(isA<Left>()));
      expect(
          Either.fromComputation(() => throw Exception())
              .getL(_fail as Exception Function(Null)),
          isA<Exception>());
      expect(Either.fromComputation(() => 'Hello'), isNot(isA<Right>()));
      expect(
          Either.fromComputation(() => 'Hello')
              .getR(_fail as String Function(Exception)),
          'Hello');
    });
    test('fromComputation', () {
      expect(Either.fromComputation(() => throw Exception()), isA<Left>());
      expect(
          Either.fromComputation(() => throw Exception())
              .getL(_fail as Exception Function(Null)),
          isA<Exception>());
      expect(Either.fromComputation(() => 'Hello'), isA<Right>());
      expect(
          Either.fromComputation(() => 'Hello')
              .getR(_fail as String Function(Exception)),
          'Hello');
    });

    const lv = 1;
    const rv = 'Hello';
    final left = Either.left<int, String>(1);
    final right = Either.right<int, String>('Hello');
    group('BiFunctor', () {
      test('first', () {
        expect(left.first((v) => 2 * v).getL(_fail as int Function(String)), 2);
        expect(
            () => right
                .first((v) => 2 * v)
                .getL(((dynamic _) => throw '') as int Function(String)),
            throwsA(''));
      });
      test('second', () {
        expect(
            () => left
                .second((v) => v * 2)
                .getR(((dynamic _) => throw '') as String Function(int)),
            throwsA(''));
        expect(right.second((v) => v * 2).getR(_fail as String Function(int)),
            rv * 2);
      });
      test('bimap', () {
        double a(int a) => a.toDouble();
        int b(String b) => b.length;
        expect(left.bimap(a: a, b: b).getL(_fail as double Function(int)),
            lv.toDouble());
        expect(right.bimap(a: a, b: b).getR(_fail as int Function(double)),
            rv.length);
      });
    });
    test('fmap', () {
      expect(left.fmap((b) => b * 2).getL(_fail as int Function(String)), lv);
      expect(
          right.fmap((b) => b * 2).getR(_fail as String Function(int)), rv * 2);
    });
    test('bind', () {
      expect(left.bind((b) => right).getL(_fail as int Function(String)), lv);
      expect(right.bind((b) => right).getR(_fail as String Function(int)), rv);
      expect(right.bind((b) => left).getL(_fail as int Function(String)), lv);
    });
    test('getL', () {
      expect(left.getL(_fail as int Function(String)), lv);
      expect(
          () => right.getL(((dynamic _) => throw '') as int Function(String)),
          throwsA(''));
    });
    test('getR', () {
      expect(right.getR(_fail as String Function(int)), rv);
      expect(() => left.getR(((dynamic _) => throw '') as String Function(int)),
          throwsA(''));
    });
    test('visit', () {
      expect(left.visit(a: (_) => 2.0, b: unreachable), 2.0);
      expect(
          () => left.visit(a: unreachable, b: (_) => 2.0), throwsA(anything));
      expect(left.visit(a: (_) => 2.0, b: (_) => 3.0), 2.0);
      expect(
          () => right.visit(a: (_) => 2.0, b: unreachable), throwsA(anything));
      expect(right.visit(a: unreachable, b: (_) => 2.0), 2.0);
      expect(right.visit(a: (_) => 2.0, b: (_) => 3.0), 3.0);
    });
    test('maybeLeft/maybeRight', () {
      expect(left.maybeLeft, isA<Just<int>>());
      expect(left.maybeRight, isA<None<String>>());
      expect(right.maybeLeft, isA<None<int>>());
      expect(right.maybeRight, isA<Just<String>>());
    });
  });
  group('EitherApply', () {
    final left = Either.left<Exception, int>(Exception());
    final right = Either.right<Exception, int>(1);
    double sum(int a, int b) => (a + b).toDouble();
    final sumCurryRight =
        Either.right<Exception, double Function(int) Function(int)>(sum.curry);
    test('apply', () {
      expect(sumCurryRight.apply(left).apply(left), isA<Left>());
      expect(sumCurryRight.apply(right).apply(left), isA<Left>());
      expect(sumCurryRight.apply(left).apply(right), isA<Left>());
      expect(sumCurryRight.apply(right).apply(right), isA<Right>());
      expect(
          sumCurryRight
              .apply(right)
              .apply(right)
              .getR(_fail as double Function(Exception)),
          2.0);
    });
    test('>>', () {
      expect(sumCurryRight >> left >> left, isA<Left>());
      expect(sumCurryRight >> right >> left, isA<Left>());
      expect(sumCurryRight >> left >> right, isA<Left>());
      expect(sumCurryRight >> right >> right, isA<Right>());
      expect(
          (sumCurryRight >> right >> right)
              .getR(_fail as double Function(Exception)),
          2.0);
    });
  });
  group('EitherIterableUtils', () {
    const lv = 1;
    const rv = 'Hello';
    final left = Either.left<int, String>(1);
    final right = Either.right<int, String>('Hello');
    final iter = Iterable.generate(4, (i) => i.isEven ? left : right);
    test('lefts', () {
      expect(iter.lefts(), Iterable.castFrom<int, int>([lv, lv]));
    });
    test('rights', () {
      expect(iter.rights(), Iterable.castFrom<String, String>([rv, rv]));
    });
    test('partitionEithers', () {
      final lefts = iter.partitionEithers()[0];
      final rights = iter.partitionEithers()[1];
      expect(lefts, Iterable.castFrom<int, int>([lv, lv]));
      expect(rights, Iterable.castFrom<String, String>([rv, rv]));
    });
  });
}
