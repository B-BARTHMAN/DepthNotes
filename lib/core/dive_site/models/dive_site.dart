import 'package:freezed_annotation/freezed_annotation.dart';

part 'dive_site.freezed.dart';

enum SiteStatus { seeded, userCreated, verified }

enum Environment { ocean, sea, lake, river, quarry, pool, cave, other }

enum SiteType { reef, wreck, cave, wall, shore, openWater, other }

/// A dive location — either from the curated catalog or created locally (R43).
///
/// [environment] gates which [DiveConditions] fields the UI shows:
/// [SeaState] only appears for ocean/sea sites.
///
/// [status] tracks curation state: [SiteStatus.userCreated] sites are
/// flagged for review; [SiteStatus.seeded] / [SiteStatus.verified] come
/// from the catalog.
@freezed
abstract class DiveSite with _$DiveSite {
  const factory DiveSite({
    required String id,
    required String name,
    required SiteStatus status,
    required DateTime updatedAt,
    double? lat,
    double? lng,
    Environment? environment,
    SiteType? type,
    String? country,
    double? maxDepth,
    String? description,
    DateTime? deletedAt,
  }) = _DiveSite;
}
