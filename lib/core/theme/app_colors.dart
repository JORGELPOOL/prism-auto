import 'package:flutter/material.dart';

/// PRISM brand color tokens.
///
/// COPIED from prism_appbloc's lib/core/theme/app_colors.dart, unmodified,
/// per the PRISM AUTO build spec ("one brand, one system"). If a token
/// changes upstream (e.g. the cyan shade), copy the updated file across
/// rather than letting the two drift — do not hand-edit values here.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color bgPrimary = Color(0xFF050508); // screen
  static const Color bgVoid = Color(0xFF0A0A14); // cards
  static const Color bgSurface = Color(0xFF16162B); // elevated / hover

  // Primary accent — CTAs and active states only
  static const Color cyan = Color(0xFF00D4FF);

  // Spectrum gradient — logo "X" and hero moments ONLY.
  // Stops at 0 / 0.55 / 1.0, cyan -> violet -> orange.
  static const Color spectrumStart = Color(0xFF00D4FF);
  static const Color spectrumMid = Color(0xFF6B5FFF);
  static const Color spectrumEnd = Color(0xFFFF6B35);
  static const LinearGradient spectrumGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [spectrumStart, spectrumMid, spectrumEnd],
    stops: [0.0, 0.55, 1.0],
  );

  // Semantic
  static const Color gold = Color(0xFFFFD166); // money numbers only — unused in AUTO
  static const Color mint = Color(0xFF00FFCC); // success states only
  static const Color error = Color(0xFFFF4D6A);
  static const Color warning = Color(0xFFFFD166);

  // Text
  static const Color textWhite = Color(0xFFFFFFFF); // headings
  static const Color textMist = Color(0xFFD8D8E4); // primary body
  static const Color textSilver = Color(0xFFA6A6BC); // secondary body
  static const Color textDim = Color(0xFF6E6E86); // labels / placeholders

  // Borders — subtle white overlays, never a visible "card outline"
  static Color border1 = Colors.white.withOpacity(0.06);
  static Color border2 = Colors.white.withOpacity(0.10);
  static Color border3 = Colors.white.withOpacity(0.17);
}
