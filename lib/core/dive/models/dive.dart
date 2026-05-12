
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dive.freezed.dart';

@freezed
abstract class Dive with _$Dive {
  const factory Dive({
    required String id,
    required DateTime date,
    required String site,
    required double depth,
    required int duration,
    required DateTime updatedAt,
    required int version,
  }) = _Dive;
}
