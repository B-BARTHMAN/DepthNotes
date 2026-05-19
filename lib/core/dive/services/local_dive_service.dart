import 'package:depth_notes/core/database/app_database.dart';
import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/core/dive/models/dive_time.dart';
import 'package:drift/drift.dart';

class LocalDiveService {
  LocalDiveService({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  Stream<List<Dive>> watchDives() {
    final query = _database.select(_database.dives)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.map(_toDomain).watch();
  }

  Future<void> addDive(Dive dive) async =>
      _database.into(_database.dives).insert(_toCompanion(dive));

  Future<void> updateDive(Dive dive) => (_database.update(
    _database.dives,
  )..where((t) => t.id.equals(dive.id))).write(_toCompanion(dive));

  Future<void> deleteDive(String id) =>
      (_database.delete(_database.dives)..where((t) => t.id.equals(id))).go();

  Dive _toDomain(DiveRow r) => Dive(
    id: r.id,
    date: r.date,
    site: r.site,
    depth: r.depth,
    notes: r.notes,
    updatedAt: r.updatedAt,
    time: switch (r.timeKind) {
      'rough' => DiveTime.rough(
        timeOfDay: DiveTimeOfDay.values.byName(r.timeOfDay!),
        duration: r.duration!,
      ),
      'precise' => DiveTime.precise(timeIn: r.timeIn!, timeOut: r.timeOut!),
      _ => throw StateError('unknown timeKind: ${r.timeKind}'),
    },
  );

  DivesCompanion _toCompanion(Dive d) => switch (d.time) {
    RoughDiveTime(:final timeOfDay, :final duration) => DivesCompanion.insert(
      id: d.id,
      date: d.date,
      site: d.site,
      depth: d.depth,
      notes: Value(d.notes),
      updatedAt: d.updatedAt,
      timeKind: 'rough',
      timeOfDay: Value(timeOfDay.name),
      duration: Value(duration),
      timeIn: const Value(null),
      timeOut: const Value(null),
    ),
    PreciseDiveTime(:final timeIn, :final timeOut) => DivesCompanion.insert(
      id: d.id,
      date: d.date,
      site: d.site,
      depth: d.depth,
      notes: Value(d.notes),
      updatedAt: d.updatedAt,
      timeKind: 'precise',
      timeOfDay: const Value(null),
      duration: const Value(null),
      timeIn: Value(timeIn),
      timeOut: Value(timeOut),
    ),
  };
}
