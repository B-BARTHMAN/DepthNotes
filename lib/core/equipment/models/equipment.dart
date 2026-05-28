import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment.freezed.dart';

/// Exposure suit cut — affects thickness meaning and thermal rating.
enum SuitType { wetsuit, semidry, drysuit, rashguard }

/// Broad gear bucket for [Equipment.generic]. Split a variant out of this
/// enum into its own union case when it grows type-specific fields.
enum EquipmentCategory {
  bcd,
  regulator,
  computer,
  fins,
  mask,
  light,
  smb,
  other,
}

/// A piece of dive gear the user owns. Local-only (R42).
///
/// [Equipment.exposureSuit] carries suit-specific fields (type, thickness).
/// [Equipment.generic] covers everything else with a category tag.
/// Adding a third variant later is non-breaking.
@freezed
sealed class Equipment with _$Equipment {
  const Equipment._();

  const factory Equipment.exposureSuit({
    required String id,
    required String name,
    required SuitType suitType,
    required DateTime updatedAt,
    int? thicknessMm,
    String? brand,
    String? notes,
    DateTime? retiredAt,
  }) = ExposureSuit;

  const factory Equipment.generic({
    required String id,
    required String name,
    required EquipmentCategory category,
    required DateTime updatedAt,
    String? brand,
    String? notes,
    DateTime? retiredAt,
  }) = GenericEquipment;

  /// Whether this piece of gear is still in use.
  bool get isActive => retiredAt == null;
}
