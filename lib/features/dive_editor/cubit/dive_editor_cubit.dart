import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/core/dive/repositories/dive_repository.dart';
import 'package:depth_notes/core/dive_time/models/dive_time.dart';
import 'package:depth_notes/features/dive_editor/cubit/dive_editor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

/// Editor cubit. Builds a Dive from form fields and persists it.
///
/// Handles both create and edit: when `_initialDive` is set the id is
/// preserved so the write becomes an update.
class DiveEditorCubit extends Cubit<DiveEditorState> {
  DiveEditorCubit({
    required DiveRepository diveRepository,
    Dive? initialDive,
  }) : _diveRepository = diveRepository,
       _initialDive = initialDive,
       super(const DiveEditorState());

  final DiveRepository _diveRepository;
  final Dive? _initialDive;

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
        id: _initialDive?.id ?? const Uuid().v7(),
        number: 0,
        date: date,
        siteName: site,
        siteId: 'NONE',
        depth: depth,
        time: time,
        updatedAt: now,
        notes: notes,
      );

      if (_initialDive != null) {
        await _diveRepository.updateDive(dive);
      } else {
        await _diveRepository.addDive(dive);
      }

      emit(state.copyWith(status: DiveEditorStatus.saved));
    } catch (e) {
      emit(
        state.copyWith(
          status: DiveEditorStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
