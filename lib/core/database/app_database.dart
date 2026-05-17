import 'package:drift/drift.dart';

part 'app_database.g.dart';

@DataClassName('DiveRow')
class Dives extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get site => text()();
  RealColumn get depth => real()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  // DiveTime union, flattened with a discriminator
  TextColumn get timeKind => text()(); // 'rough' | 'precise'
  TextColumn get timeOfDay => text().nullable()(); // rough
  IntColumn get duration => integer().nullable()(); // rough
  DateTimeColumn get timeIn => dateTime().nullable()(); // precise
  DateTimeColumn get timeOut => dateTime().nullable()(); // precise

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Dives])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
