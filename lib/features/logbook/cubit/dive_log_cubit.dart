import 'dart:async';

import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/core/dive/repositories/dive_repository.dart';
import 'package:depth_notes/features/logbook/cubit/dive_log_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiveLogCubit extends Cubit<DiveLogState> {
  DiveLogCubit({required DiveRepository diveRepository})
    : _diveRepository = diveRepository,
      super(const DiveLogState()) {
    _subscription = _diveRepository.watchDives().listen(
      (dives) =>
          emit(state.copyWith(status: DiveLogStatus.success, dives: dives)),
      onError: (Object e) => emit(
        state.copyWith(
          status: DiveLogStatus.failure,
          errorMessage: e.toString(),
        ),
      ),
    );
  }

  final DiveRepository _diveRepository;
  late final StreamSubscription<List<Dive>> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
