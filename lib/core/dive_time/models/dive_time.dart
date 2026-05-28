import 'package:freezed_annotation/freezed_annotation.dart';

part 'dive_time.freezed.dart';

enum DiveTimeOfDay { morning, afternoon, night }

/// Time data on a dive.
///
/// [DiveTime.rough] — casual: time-of-day bucket + duration.
/// [DiveTime.precise] — exact timestamps; duration derived.
///
/// Union prevents invalid states (no half-set precise times, no
/// time-of-day on a precise entry).
@freezed
sealed class DiveTime with _$DiveTime {
  const DiveTime._();

  const factory DiveTime.rough({
    required DiveTimeOfDay timeOfDay,
    required int duration,
  }) = RoughDiveTime;

  const factory DiveTime.precise({
    required DateTime timeIn,
    required DateTime timeOut,
  }) = PreciseDiveTime;

  /// Minutes underwater. Stored on rough; derived on precise.
  int get duration => switch (this) {
    RoughDiveTime(:final duration) => duration,
    PreciseDiveTime(:final timeIn, :final timeOut) =>
      timeOut.difference(timeIn).inMinutes,
  };
}
