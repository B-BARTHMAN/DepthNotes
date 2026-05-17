import 'package:depth_notes/features/logbook/cubit/dive_log_state.dart';

extension DiveLogStats on DiveLogState {
  int get totalDives => dives.length;
  int get totalDuration => dives.fold(
    0, (sum, dive) => sum + dive.time.duration
  );
}
