import 'package:freezed_annotation/freezed_annotation.dart';

part 'temperature.freezed.dart';

/// Coarse water-temperature bucket for [Temperature.rough].
enum TempBucket { cold, cool, temperate, warm }

/// Water temperature on a dive, at whatever fidelity it was recorded.
///
/// [Temperature.rough] — a qualitative bucket.
/// [Temperature.single] — one reading in °C.
/// [Temperature.range] — surface + bottom; average derived.
///
/// Stored metric (°C). The union keeps each shape valid; coarse derives
/// from fine.
@freezed
sealed class Temperature with _$Temperature {
  const Temperature._();

  const factory Temperature.rough(TempBucket bucket) = RoughTemperature;

  const factory Temperature.single(double celsius) = SingleTemperature;

  const factory Temperature.range({
    required double surface,
    required double bottom,
  }) = RangeTemperature;

  /// A single representative °C where one exists;
  /// null for [Temperature.rough].
  double? get representativeCelsius => switch (this) {
    RoughTemperature() => null,
    SingleTemperature(:final celsius) => celsius,
    RangeTemperature(:final surface, :final bottom) => (surface + bottom) / 2,
  };
}
