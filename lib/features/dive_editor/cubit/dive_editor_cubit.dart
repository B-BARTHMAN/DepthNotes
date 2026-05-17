
import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/core/dive/models/dive_time.dart';
import 'package:depth_notes/core/dive/repositories/dive_repository.dart';
import 'package:depth_notes/features/dive_editor/cubit/dive_editor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class DiveEditorCubit extends Cubit<DiveEditorState> {
  DiveEditorCubit({required DiveRepository diveRepository})
    : _diveRepository = diveRepository,
      super(const DiveEditorState());
  
  final DiveRepository _diveRepository;

  Future<void> saveDive({
    required DateTime date,
    required String site,
    required double depth,
    required DiveTime time,
    String? notes,
  }) async {
    emit(state.copyWith(status: DiveEditorStatus.saving));
    try {
      final now = DateTime.now();
      final dive = Dive(
        id: const Uuid().v7(), 
        date: date, 
        site: site, 
        depth: depth, 
        time: time, 
        updatedAt: now, 
        notes: notes
      );
      await _diveRepository.addDive(dive);
      emit(state.copyWith(status: DiveEditorStatus.saved));
    } catch (e) {
      emit(
        state.copyWith(
          status: DiveEditorStatus.error,
          errorMessage: e.toString()
        )
      );
    }
  }
}
