
import 'package:depth_notes/core/dive/models/dive_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dive.freezed.dart';

@freezed
abstract class Dive with _$Dive {
  const factory Dive({
    required String id,
    required DateTime date,
    required String site,
    required double depth,
    required DiveTime time,
    required DateTime updatedAt,
    String? notes,
  }) = _Dive;
}
