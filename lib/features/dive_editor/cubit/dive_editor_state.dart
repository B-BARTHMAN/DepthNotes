import 'package:freezed_annotation/freezed_annotation.dart';

part 'dive_editor_state.freezed.dart';

enum DiveEditorStatus { idle, saving, saved, error }

/// State for the dive editor screen.
///
/// `saved` is terminal — the screen pops once it lands. `error` keeps the
/// form open so the user can retry.
@freezed
abstract class DiveEditorState with _$DiveEditorState {
  const factory DiveEditorState({
    @Default(DiveEditorStatus.idle) DiveEditorStatus status,
    String? errorMessage,
  }) = _DiveEditorState;
}
