import 'package:depth_notes/core/temperature/models/temperature.dart';
import 'package:depth_notes/core/visibility/models/visibility.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dive_conditions.freezed.dart';

enum CurrentStrength { none, light, moderate, strong }

enum Weather { sunny, cloudy, overcast, rain, storm }

/// Surface state — only meaningful in open water.
enum SeaState { calm, choppy, rough }

/// Observed conditions for one dive. 1:1 with a dive, so the dive's id is
/// the key. Every field is optional: a pool dive simply leaves [seaState]
/// and friends null.
@freezed
abstract class DiveConditions with _$DiveConditions {
  const factory DiveConditions({
    required String diveId,
    required DateTime updatedAt,
    Temperature? waterTemp,
    double? airTemp, // °C
    Visibility? visibility,
    CurrentStrength? current,
    Weather? weather,
    SeaState? seaState,
    DateTime? deletedAt,
  }) = _DiveConditions;
}
