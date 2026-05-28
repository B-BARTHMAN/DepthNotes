import 'package:depth_notes/core/cylinder/models/cylinder_template.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'loadout.freezed.dart';

/// A named, reusable dive setup. Local-only (R42).
///
/// Selecting a loadout prefills the dive editor; the dive then snapshots
/// the values (R40). Editing a loadout never changes past dives.
@freezed
abstract class Loadout with _$Loadout {
  const factory Loadout({
    required String id,
    required String name,
    required DateTime updatedAt,
    @Default(<CylinderTemplate>[]) List<CylinderTemplate> cylinders,
    @Default(<String>[]) List<String> equipmentIds,
    @Default(<String>[]) List<String> buddyNames,
    double? weight, // kg
  }) = _Loadout;
}
