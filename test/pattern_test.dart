import 'package:test/test.dart';
import 'package:utils/utils.dart';
import 'package:meta/meta.dart';

void main() {
  group('Pattern', () {
    group('inert', () {
      test('values', () {
        final pattern = values([1, 2]);
        expect(pattern.matches(1), true);
        expect(pattern.matches(2), true);
        expect(pattern.matches(0), false);
      });
      test('value', () {
        final pattern = value(1);
        expect(pattern.matches(1), true);
        expect(pattern.matches(0), false);
      });
      test('when', () {
        final pattern = when((v) => v > 1);
        expect(pattern.matches(0), false);
        expect(pattern.matches(1), false);
        expect(pattern.matches(2), true);
      });
      test('type', () {
        final pattern = type<double>();
        expect(pattern.matches(0), false);
        expect(pattern.matches(1), false);
        expect(pattern.matches(1.0), true);
      });
      test('any', () {
        expect(any.matches(0), true);
        expect(any.matches(''), true);
        expect(any.matches([]), true);
        expect(any.matches(null), true);
      });
    });
    group('evaluatable', () {
      @isTestGroup
      void _testEvaluatable<A, B>(
        dynamic Function<A, B>(
          B Function(A), {
          A value,
          Iterable<A> values,
          bool Function(A) matches,
        })
            createPattern,
        String name,
        List<A> validValues,
        List<Object> invalidValues,
        B Function(A) fn,
      ) {
        group(name, () {
          test('type', () {
            final pattern = createPattern<A, B>(fn);
            for (final invalid in invalidValues.where((e) => e is! A)) {
              expect(pattern.matches(invalid), false);
              expect(() => pattern.eval(invalid), throwsA(anything));
            }
            for (final valid in validValues) {
              expect(pattern.matches(valid), true);
              expect(pattern.eval(valid), fn(valid));
            }
          });
          test('value', () {
            final pattern = createPattern<A, B>(fn, value: validValues.first);
            final value = validValues.first;
            for (final invalid in invalidValues.followedBy(
              validValues.skip(1),
            )) {
              expect(pattern.matches(invalid), false);
              expect(() => pattern.eval(invalid), throwsA(anything));
            }
            expect(pattern.matches(value), true);
            expect(pattern.eval(value), fn(value));
          });
          test('values', () {
            final pattern = createPattern<A, B>(fn, values: validValues);
            for (final valid in validValues) {
              expect(pattern.matches(valid), true);
              expect(pattern.eval(valid), fn(valid));
            }
            for (final invalid in invalidValues) {
              expect(pattern.matches(invalid), false);
              expect(() => pattern.eval(invalid), throwsA(anything));
            }
          });
          test('matches', () {
            final pattern =
                createPattern<A, B>(fn, matches: validValues.contains);
            for (final valid in validValues) {
              expect(pattern.matches(valid), true);
              expect(pattern.eval(valid), fn(valid));
            }
            for (final invalid in invalidValues) {
              expect(pattern.matches(invalid), false);
              expect(() => pattern.eval(invalid), throwsA(anything));
            }
          });
          test('more than one throws', () {
            expect(
                () => createPattern<A, B>(
                      fn,
                      value: validValues.first,
                      values: validValues,
                    ),
                throwsA(anything));
            expect(
                () => createPattern<A, B>(
                      fn,
                      value: validValues.first,
                      values: validValues,
                      matches: (i) => true,
                    ),
                throwsA(anything));
            expect(
                () => createPattern<A, B>(
                      fn,
                      values: validValues,
                      matches: (i) => true,
                    ),
                throwsA(anything));
            expect(
                () => createPattern<A, B>(
                      fn,
                      value: validValues.first,
                      matches: (i) => true,
                    ),
                throwsA(anything));
          });
        });
      }

      _testEvaluatable<int, double>(
          mapper, 'mapper', [1, 2, 3], [1.0, '', []], (i) => 2.0 * i);
      _testEvaluatable<int, int>(
          <A, B>(
            B Function(A) fn, {
            A value,
            Iterable<A> values,
            bool Function(A) matches,
          }) =>
              endoMap<A>(
                fn as A Function(A),
                value: value,
                values: values,
                matches: matches,
              ),
          'endoMap',
          [1, 2, 3],
          [1.0, '', []],
          (i) => 2 * i);
      _testEvaluatable<int, void>(
          <A, B>(
            B Function(A) fn, {
            A value,
            Iterable<A> values,
            bool Function(A) matches,
          }) =>
              doWhen<A>(
                fn,
                value: value,
                values: values,
                matches: matches,
              ),
          'doWhen',
          [1, 2, 3],
          [1.0, '', []],
          (i) => i * 2.0);
    });
    group('match', () {
      test('is stateless', () {
        const matched = match(1.0);
        expect(matched.eval([any]), null);
        expect(matched.eval([any]), null);
      });
      group('eval', () {
        test('returns null on not found', () {
          expect(const match(1).eval([]), null);
        });
        test('throws on invalid return type', () {
          expect(
            () => const match(1).eval<double>([any.then((_) => 1)]),
            throwsA(anything),
          );
        });
        test('evaluates sequentially', () {
          expect(
            const match(1).eval([
              any.then<int>((_) => 2),
              type<int>().then<int>((_) => fail('should be unreachable'))
            ]),
            2,
          );
        });
        test('returns null on inert patterns', () {
          expect(
            const match(1).eval<int>([
              any,
              type<int>().then<int>((_) => fail('should be unreachable'))
            ]),
            null,
          );
        });
      });
    });
  });

  group('ObjectPatternMatching', () {
    test('Works as expected', () {
      expect(1.match([type<int>().then((_) => 2)]), 2);
      expect(1.0.match([type<int>().then((_) => 2)]), null);
      expect(() => ''.match([any.then((_) => throw '')]), throwsA(''));
    });
  });
}
