import 'package:freezed_annotation/freezed_annotation.dart';

part 'buddy.freezed.dart';

/// A dive buddy on a specific dive. 1:N with Dive.
///
/// [name] is always present (free text). [linkedUserId] is the social
/// hook — null today, set once friends/accounts land.
@freezed
abstract class Buddy with _$Buddy {
  const factory Buddy({
    required String id,
    required String diveId,
    required String name,
    required DateTime updatedAt,
    String? linkedUserId,
    DateTime? deletedAt,
  }) = _Buddy;
}
