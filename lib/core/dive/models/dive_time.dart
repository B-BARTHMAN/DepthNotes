
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dive_time.freezed.dart';

enum DiveTimeOfDay { morning, afternoon, night }

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

  int get duration => switch (this) {
    RoughDiveTime(:final duration) => duration,
    PreciseDiveTime(:final timeIn, :final timeOut) => 
      timeOut.difference(timeIn).inMinutes
  };
}
