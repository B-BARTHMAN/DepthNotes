import 'package:depth_notes/core/cylinder/models/gas_mix.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cylinder.freezed.dart';

/// Cylinder construction — affects buoyancy behaviour.
enum CylinderMaterial { aluminium, steel }

/// One cylinder as actually dived. Material, volume and mix usually prefill
/// from a loadout; the pressures are read off the gauge that dive.
///
/// A dive can carry several (twins, stages, deco bottles).
@freezed
abstract class Cylinder with _$Cylinder {
  const factory Cylinder({
    required String id,
    required String diveId,
    required CylinderMaterial material,
    required GasMix mix,
    required DateTime updatedAt,
    double? volume, // litres
    int? startPressure, // bar
    int? endPressure, // bar
    DateTime? deletedAt,
  }) = _Cylinder;

  const Cylinder._();

  /// Bar consumed, when both gauge readings are present.
  int? get pressureUsed => switch ((startPressure, endPressure)) {
    (final start?, final end?) => start - end,
    _ => null,
  };
}
