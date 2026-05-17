import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/core/dive/models/dive_time.dart';

class LocalDiveService {
  final List<Dive> _dives = [
      Dive(
        id: '1',
        date: DateTime(2026, 5, 10),
        site: 'Blue Hole',
        depth: 28,
        time: const DiveTime.rough(
          timeOfDay: DiveTimeOfDay.afternoon,
          duration: 63
        ),
        updatedAt: DateTime(2026, 5, 10),
        version: 1,
      ),
      Dive(
        id: '2',
        date: DateTime(2026, 4, 22),
        site: 'Shark Point',
        depth: 18,
        time: const DiveTime.rough(
          timeOfDay: DiveTimeOfDay.morning,
          duration: 55
        ),
        updatedAt: DateTime(2026, 4, 22),
        version: 1,
      ),
      Dive(
        id: '3',
        date: DateTime(2026, 3, 5),
        site: 'Manta Reef',
        depth: 22,
        time: DiveTime.precise(
          timeIn: DateTime(2026, 9, 7, 16, 30),
          timeOut: DateTime(2026, 9, 7, 17, 17),
        ),
        updatedAt: DateTime(2026, 3, 5),
        version: 1,
      ),
    ];

  Future<List<Dive>> getDives() async => List.unmodifiable(_dives);

  Future<void> addDive(Dive dive) async => _dives.insert(0, dive);
}
