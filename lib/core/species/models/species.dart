import 'package:freezed_annotation/freezed_annotation.dart';

part 'species.freezed.dart';

/// Broad biological group — keeps "my aquarium" groupable without
/// requiring full Linnaean taxonomy.
enum Taxon {
  fish,
  shark,
  ray,
  mollusk,
  crustacean,
  cnidarian,
  mammal,
  reptile,
  echinoderm,
  cephalopod,
  other,
}

/// IUCN Red List conservation status, coarsest to most critical.
enum IucnStatus {
  leastConcern,
  nearThreatened,
  vulnerable,
  endangered,
  criticallyEndangered,
  extinctInTheWild,
  extinct,
  dataDeficient,
  notEvaluated,
}

/// A species in the curated catalog — delivered via regional packs (R43).
///
/// Read-mostly; curator-filled. Users reference species through
/// [SpeciesSighting], not by editing this directly.
@freezed
abstract class Species with _$Species {
  const factory Species({
    required String id,
    required String scientificName,
    required DateTime updatedAt,
    String? commonName,
    Taxon? taxon,
    IucnStatus? iucnStatus,
    String? description,
    String? imageUrl,
    DateTime? deletedAt,
  }) = _Species;
}
