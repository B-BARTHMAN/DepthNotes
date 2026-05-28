import 'package:depth_notes/core/dive_time/models/dive_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dive.freezed.dart';

enum EntryType { shore, boat }

enum DiveType { fun, training, deco, work }

/// Single dive entry.
///
/// [depth] is metric (metres). [weight] is metric (kg).
///
/// [rating] is half-stars: 1 = ½ star … 10 = 5 stars; null means unrated.
///
/// [siteName] snapshots the site name at log time so past dives are stable
/// even if the site is later renamed. [siteId] links to the catalog.
@freezed
abstract class Dive with _$Dive {
  const factory Dive({
    required String id,
    required int number,
    required DateTime date,
    required String siteId,
    required String siteName,
    required double depth,
    required DiveTime time,
    required DateTime updatedAt,
    EntryType? entryType,
    DiveType? diveType,
    double? weight,
    int? rating,
    String? notes,
    DateTime? deletedAt,
  }) = _Dive;
}
