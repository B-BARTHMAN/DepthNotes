import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo.freezed.dart';

/// A photo attached to a dive. 1:N with Dive.
///
/// [localPath] is always set; [remoteKey] appears once bytes have synced
/// to Supabase Storage (R21 — bytes sync separately from metadata).
@freezed
abstract class Photo with _$Photo {
  const factory Photo({
    required String id,
    required String diveId,
    required String localPath,
    required DateTime updatedAt,
    String? remoteKey,
    String? caption,
    DateTime? takenAt,
    String? speciesId,
    DateTime? deletedAt,
  }) = _Photo;
}
