import 'package:freezed_annotation/freezed_annotation.dart';

part 'gas_mix.freezed.dart';

/// Breathing-gas composition.
///
/// Only O₂ and He are stored; nitrogen is the balance, so it's derived and
/// can never push the three off 100. Air is `GasMix(o2Percent: 21)`.
@freezed
abstract class GasMix with _$GasMix {
  const GasMix._();

  const factory GasMix({
    required int o2Percent,
    @Default(0) int hePercent,
  }) = _GasMix;

  /// Balance of the mix: `100 - o2 - he`.
  int get n2Percent => 100 - o2Percent - hePercent;

  /// True for plain air (21% O₂, no helium).
  bool get isAir => o2Percent == 21 && hePercent == 0;
}
