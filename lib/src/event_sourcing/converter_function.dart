import 'dart:convert';

/// An [Converter] which is an simple stateless function.
class ConverterFn<S, T> extends Converter<S, T> {
  /// Create an [ConverterFn].
  ConverterFn(this._convert);
  final T Function(S) _convert;

  @override
  T convert(S input) => _convert(input);
}
