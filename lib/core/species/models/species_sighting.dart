import 'package:depth_notes/core/species/models/abundance.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'species_sighting.freezed.dart';

/// A species observed on a dive. 1:N with Dive, N:1 with Species.
///
/// [speciesId] links to the catalog when available; [speciesLabel] is a
/// free-text fallback for uncatalogued species. At least one should be set.
@freezed
abstract class SpeciesSighting with _$SpeciesSighting {
  const factory SpeciesSighting({
    required String id,
    required String diveId,
    required DateTime updatedAt,
    String? speciesId,
    String? speciesLabel,
    Abundance? abundance,
    double? depthSeen, // metres
    String? notes,
    String? photoId,
    DateTime? deletedAt,
  }) = _SpeciesSighting;
}
