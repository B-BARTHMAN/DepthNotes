import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

/// A dive certification card (PADI Open Water, SSI Advanced, etc.).
/// Value object on [Profile] — no id, no independent lifecycle.
@freezed
abstract class Certification with _$Certification {
  const factory Certification({
    required String agency,
    required String level,
    String? number,
    DateTime? date,
  }) = _Certification;
}

/// The signed-in user's profile. [id] is the Supabase auth uid.
///
/// Synced — so it's available on every device once authenticated.
/// Certifications are an embedded list (not atlas-queried).
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required DateTime updatedAt,
    String? displayName,
    String? homeRegion,
    @Default(<Certification>[]) List<Certification> certifications,
    DateTime? deletedAt,
  }) = _Profile;
}
