import 'package:freezed_annotation/freezed_annotation.dart';

part 'abundance.freezed.dart';

/// Coarse count bucket for [Abundance.rough].
enum AbundanceBucket { single, few, many }

/// How many of a species were seen — a descriptive bucket or an exact count.
@freezed
sealed class Abundance with _$Abundance {
  const Abundance._();

  const factory Abundance.rough(AbundanceBucket bucket) = RoughAbundance;

  const factory Abundance.exact(int count) = ExactAbundance;

  /// Exact count where given; null for [Abundance.rough].
  int? get count => switch (this) {
    RoughAbundance() => null,
    ExactAbundance(:final count) => count,
  };
}
