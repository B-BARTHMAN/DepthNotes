import 'package:flutter/material.dart';

/// App-wide themes. Material 3, deep-ocean seed (R29).
///
/// ThemeExtension for design tokens isn't in yet — lands when the first
/// custom token shows up.
abstract final class AppTheme {
  static const _seedColor = Color(0xFF006494);

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
  );
}
