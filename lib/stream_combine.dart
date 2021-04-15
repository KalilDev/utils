import 'dart:async';

extension FutureOrThen<T> on FutureOr<T> {
  Future<R> then<R>(
    FutureOr<R> Function(T) onValue, {
    Function onError,
  }) =>
      Future.value(this).then(onValue, onError: onError);
}

/// Combine the [values] into an single [Stream<T>].
/// [values] is a list of [FutureOr<T>] | [Stream<T>].
Stream<T> streamCombine<T>(
    List<dynamic /*FutureOr<T> | FutureOr<Stream<T>>*/ > values) {
  if (!values.every((v) => v is FutureOr<T> || v is Stream<T>)) {
    throw TypeError();
  }
  return _combinedStream<T>(values);
}

Stream<T> _combinedStream<T>(
    List<dynamic /*FutureOr<T> | FutureOr<Stream<T>>*/ > values) async* {
  for (final value in values) {
    if (value is Future<T>) {
      yield* value.asStream();
      continue;
    }
    if (value is T) {
      yield value;
      continue;
    }
    if (value is Stream<T>) {
      yield* value;
      continue;
    }
    throw TypeError();
  }
}
