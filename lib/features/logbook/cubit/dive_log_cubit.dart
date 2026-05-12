import 'package:depth_notes/core/dive/repositories/dive_repository.dart';
import 'package:depth_notes/features/logbook/cubit/dive_log_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiveLogCubit extends Cubit<DiveLogState> {
  DiveLogCubit({required DiveRepository diveRepository})
    : _diveRepository = diveRepository,
      super(const DiveLogState());

  final DiveRepository _diveRepository;

  Future<void> loadDives() async {
    emit(state.copyWith(status: DiveLogStatus.loading));
    try {
      final dives = await _diveRepository.getDives();
      emit(state.copyWith(status: DiveLogStatus.success, dives: dives));
    } catch (e) {
      emit(
        state.copyWith(
          status: DiveLogStatus.failure,
          errorMessage: e.toString()
        )
      );
    }
  }
}
