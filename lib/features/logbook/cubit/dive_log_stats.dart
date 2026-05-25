import 'package:depth_notes/features/logbook/cubit/dive_log_state.dart';

/// Derived stats over the loaded dives. Lives on the state itself so the
/// UI doesn't need to recompute or hold them separately.
extension DiveLogStats on DiveLogState {
  int get totalDives => dives.length;

  /// Total minutes underwater across all dives.
  int get totalDuration =>
      dives.fold(0, (sum, dive) => sum + dive.time.duration);
}
