import 'package:freezed_annotation/freezed_annotation.dart';

part 'visibility.freezed.dart';

/// Coarse visibility bucket for [Visibility.rough].
enum VisibilityBucket { bad, medium, good }

/// Underwater visibility — a qualitative bucket or an estimate in metres.
@freezed
sealed class Visibility with _$Visibility {
  const Visibility._();

  const factory Visibility.rough(VisibilityBucket bucket) = RoughVisibility;

  const factory Visibility.exact(double metres) = ExactVisibility;

  /// Estimated metres where a number exists; null for [rough].
  double? get metres => switch (this) {
    RoughVisibility() => null,
    ExactVisibility(:final metres) => metres,
  };
}
