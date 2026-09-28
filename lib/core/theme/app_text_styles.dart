import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// PRISM typography tokens. COPIED from prism_appbloc's app_text_styles.dart.
///
/// Space Grotesk — ALL headings, page titles, stat numbers, button labels.
///   Never used for body or data.
/// Inter — ALL body text, descriptions, nav items, form input text.
/// JetBrains Mono — ONLY small data labels, tags, timestamps, IDs.
///   Never used for headings or body.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get pageTitle => GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      );

  static TextStyle get sectionHead => GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      );

  static TextStyle get statMedium => GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      );

  static TextStyle get buttonLabel => GoogleFonts.spaceGrotesk(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get bodyM => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textMist,
      );

  static TextStyle get bodyS => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSilver,
      );

  static TextStyle get navItem => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSilver,
      );

  static TextStyle get dataLabel => GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
        color: AppColors.textDim,
      );

  static TextStyle get dataTag => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.cyan,
      );
}
