import 'package:depth_notes/core/dive/models/dive.dart';

class LocalDiveService {
  Future<List<Dive>> getDives() async {
    return [
      Dive(
        id: '1',
        date: DateTime(2026, 5, 10),
        site: 'Blue Hole',
        depth: 28,
        duration: 42,
        updatedAt: DateTime(2026, 5, 10),
        version: 1,
      ),
      Dive(
        id: '2',
        date: DateTime(2026, 4, 22),
        site: 'Shark Point',
        depth: 18,
        duration: 55,
        updatedAt: DateTime(2026, 4, 22),
        version: 1,
      ),
      Dive(
        id: '3',
        date: DateTime(2026, 3, 5),
        site: 'Manta Reef',
        depth: 22,
        duration: 48,
        updatedAt: DateTime(2026, 3, 5),
        version: 1,
      ),
    ];
  }
}
