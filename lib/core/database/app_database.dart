import 'package:drift/drift.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

/// Dive sites — curated catalog rows and user-created local entries.
@DataClassName('DiveSiteRow')
class DiveSites extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get status => text()(); // SiteStatus.name
  DateTimeColumn get updatedAt => dateTime()();

  // Optional location + metadata
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get environment => text().nullable()(); // Environment.name
  TextColumn get type => text().nullable()(); // SiteType.name
  TextColumn get country => text().nullable()();
  RealColumn get maxDepth => real().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Dives table. DiveTime is flattened with a [timeKind] discriminator;
/// only the columns for the active branch are populated.
@DataClassName('DiveRow')
class Dives extends Table {
  // Core logbook fields
  TextColumn get id => text()();
  IntColumn get number => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get siteId => text()();
  TextColumn get siteName => text()(); // snapshot — stable across site renames
  RealColumn get depth => real()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // Optional logbook fields
  TextColumn get entryType => text().nullable()(); // EntryType.name
  TextColumn get diveType => text().nullable()(); // DiveType.name
  RealColumn get weight => real().nullable()(); // kg
  IntColumn get rating => integer().nullable()(); // half-stars 0–10
  TextColumn get notes => text().nullable()();

  // DiveTime union — discriminated
  TextColumn get timeKind => text()(); // 'rough' | 'precise'
  TextColumn get timeOfDay => text().nullable()(); // rough only
  IntColumn get duration => integer().nullable()(); // rough only (minutes)
  DateTimeColumn get timeIn => dateTime().nullable()(); // precise only
  DateTimeColumn get timeOut => dateTime().nullable()(); // precise only

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

/// Local SQLite store. Source of truth for offline-first reads (R17).
///
/// Bump [schemaVersion] and add a migration whenever columns change (R38).
@DriftDatabase(tables: [Dives, DiveSites])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // v1 → v2: Dives restructured (free-text `site` → `siteId` +
        // `siteName`, plus number, entryType, diveType, weight, rating,
        // deletedAt). DiveSites table added.
        //
        // Destructive on the Dives table — acceptable before any production
        // data exists. Replace with a proper TableMigration before M2.
        await m.drop(dives);
        await m.createTable(dives);
        await m.createTable(diveSites);
      }
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
