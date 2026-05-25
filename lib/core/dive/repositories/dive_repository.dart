import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/core/dive/services/local_dive_service.dart';

/// Orchestrates dive I/O.
///
/// Local-only today. Gains a remote service and a pending-mutation queue
class DiveRepository {
  DiveRepository({required LocalDiveService localDiveService})
    : _localDiveService = localDiveService;

  final LocalDiveService _localDiveService;

  Stream<List<Dive>> watchDives() => _localDiveService.watchDives();

  Future<void> addDive(Dive dive) => _localDiveService.addDive(dive);
  Future<void> updateDive(Dive dive) => _localDiveService.updateDive(dive);
  Future<void> deleteDive(String id) => _localDiveService.deleteDive(id);
}
