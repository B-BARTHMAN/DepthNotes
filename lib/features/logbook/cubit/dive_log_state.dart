import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dive_log_state.freezed.dart';

enum DiveLogStatus { initial, loading, success, failure }

@freezed
abstract class DiveLogState with _$DiveLogState {
  const factory DiveLogState({
    @Default(DiveLogStatus.initial) DiveLogStatus status,
    @Default(<Dive>[]) List<Dive> dives,
    String? errorMessage,
  }) = _DiveLogState;
}
