import 'package:depth_notes/core/cylinder/models/cylinder.dart';
import 'package:depth_notes/core/cylinder/models/gas_mix.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cylinder_template.freezed.dart';

/// A saved tank configuration inside a [Loadout]. No pressures — those
/// are per-dive measurements. On save the editor copies material, volume,
/// and mix into a [Cylinder] satellite on the dive.
@freezed
abstract class CylinderTemplate with _$CylinderTemplate {
  const factory CylinderTemplate({
    required CylinderMaterial material,
    required GasMix mix,
    double? volume, // litres
  }) = _CylinderTemplate;
}
