import 'package:depth_notes/core/database/app_database.dart';
import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/core/dive_time/models/dive_time.dart';
import 'package:drift/drift.dart';

/// Drift-backed dive storage. Bridges domain models ↔ rows.
///
/// [DiveTime] is a sealed union but Drift is relational: rows carry a
/// `timeKind` discriminator plus columns for each branch.
class LocalDiveService {
  LocalDiveService({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  // ---------------------------------------------------------------------------
  // Reads
  // ---------------------------------------------------------------------------

  Stream<List<Dive>> watchDives() {
    final query = _database.select(_database.dives)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.map(_toDomain).watch();
  }

  // ---------------------------------------------------------------------------
  // Writes
  // ---------------------------------------------------------------------------

  Future<void> addDive(Dive dive) async =>
      _database.into(_database.dives).insert(_toCompanion(dive));

  Future<void> updateDive(Dive dive) => (_database.update(
    _database.dives,
  )..where((t) => t.id.equals(dive.id))).write(_toCompanion(dive));

  /// Soft delete — sets [deletedAt] and bumps [updatedAt].
  Future<void> deleteDive(String id) {
    final now = DateTime.now();
    return (_database.update(
      _database.dives,
    )..where((t) => t.id.equals(id))).write(
      DivesCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Mappers
  // ---------------------------------------------------------------------------

  /// Row -> domain
  Dive _toDomain(DiveRow r) => Dive(
    id: r.id,
    number: r.number,
    date: r.date,
    siteId: r.siteId,
    siteName: r.siteName,
    depth: r.depth,
    updatedAt: r.updatedAt,
    deletedAt: r.deletedAt,
    entryType: r.entryType != null
        ? EntryType.values.byName(r.entryType!)
        : null,
    diveType: r.diveType != null ? DiveType.values.byName(r.diveType!) : null,
    weight: r.weight,
    rating: r.rating,
    notes: r.notes,
    time: switch (r.timeKind) {
      'rough' => DiveTime.rough(
        timeOfDay: DiveTimeOfDay.values.byName(r.timeOfDay!),
        duration: r.duration!,
      ),
      'precise' => DiveTime.precise(timeIn: r.timeIn!, timeOut: r.timeOut!),
      _ => throw StateError('unknown timeKind: ${r.timeKind}'),
    },
  );

  /// Domain -> row
  DivesCompanion _toCompanion(Dive d) => switch (d.time) {
    RoughDiveTime(:final timeOfDay, :final duration) => DivesCompanion.insert(
      id: d.id,
      number: d.number,
      date: d.date,
      siteId: d.siteId,
      siteName: d.siteName,
      depth: d.depth,
      updatedAt: d.updatedAt,
      deletedAt: Value(d.deletedAt),
      entryType: Value(d.entryType?.name),
      diveType: Value(d.diveType?.name),
      weight: Value(d.weight),
      rating: Value(d.rating),
      notes: Value(d.notes),
      timeKind: 'rough',
      timeOfDay: Value(timeOfDay.name),
      duration: Value(duration),
      timeIn: const Value(null),
      timeOut: const Value(null),
    ),
    PreciseDiveTime(:final timeIn, :final timeOut) => DivesCompanion.insert(
      id: d.id,
      number: d.number,
      date: d.date,
      siteId: d.siteId,
      siteName: d.siteName,
      depth: d.depth,
      updatedAt: d.updatedAt,
      deletedAt: Value(d.deletedAt),
      entryType: Value(d.entryType?.name),
      diveType: Value(d.diveType?.name),
      weight: Value(d.weight),
      rating: Value(d.rating),
      notes: Value(d.notes),
      timeKind: 'precise',
      timeOfDay: const Value(null),
      duration: const Value(null),
      timeIn: Value(timeIn),
      timeOut: Value(timeOut),
    ),
  };
}
