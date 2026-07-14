import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// LaunchPad ALU design tokens.
///
/// Concept: a "mission board" for the ALU venture ecosystem.
/// Ventures post missions; students assemble a crew card and track
/// each application along a flight path. The palette is a night
/// runway: deep pine green tarmac, ember-amber guidance lights,
/// warm paper daylight mode.
class Pad {
  // Core palette
  static const runway = Color(0xFF14453D); // deep pine — primary
  static const ember = Color(0xFFE8862E); // amber — accent / readiness
  static const paper = Color(0xFFF7F3EA); // warm sand background
  static const ink = Color(0xFF20241F); // near-black text
  static const signal = Color(0xFF2E7D5B); // success / accepted
  static const clay = Color(0xFFB3402E); // rejected / errors
  static const sky = Color(0xFF3D6B9E); // shortlisted
  static const gold = Color(0xFFB98900); // interview

  // Dark mode
  static const nightBg = Color(0xFF0C1613);
  static const nightCard = Color(0xFF16241F);
  static const nightBorder = Color(0xFF23362F);

  static const cardRadius = 18.0;

  /// Display face: Space Grotesk. Body: Manrope.
  static TextStyle display(
          {double size = 22,
          FontWeight weight = FontWeight.w700,
          Color? color}) =>
      GoogleFonts.spaceGrotesk(
          fontSize: size, fontWeight: weight, color: color, height: 1.15);

  static TextStyle mono({double size = 11, Color? color}) =>
      GoogleFonts.spaceGrotesk(
          fontSize: size,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.6,
          color: color);

  static Color statusColor(String status) {
    switch (status) {
      case 'accepted':
        return signal;
      case 'rejected':
        return clay;
      case 'interview':
        return gold;
      case 'shortlisted':
        return sky;
      default:
        return const Color(0xFF6B7370);
    }
  }

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final isDark = b == Brightness.dark;
    final bg = isDark ? nightBg : paper;
    final card = isDark ? nightCard : Colors.white;
    final text = isDark ? const Color(0xFFEDEAE0) : ink;

    final scheme = ColorScheme.fromSeed(
      seedColor: runway,
      brightness: b,
      primary: isDark ? const Color(0xFF7FBFA9) : runway,
      secondary: ember,
      surface: card,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: b,
      scaffoldBackgroundColor: bg,
      colorScheme: scheme,
      textTheme: GoogleFonts.manropeTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ).apply(bodyColor: text, displayColor: text),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: display(size: 20, color: text),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: BorderSide(
              color: isDark ? nightBorder : const Color(0xFFE6E0D2)),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? nightBorder : const Color(0xFFEFEADD),
        labelStyle: GoogleFonts.manrope(
            fontSize: 13, fontWeight: FontWeight.w600, color: text),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: isDark ? nightBorder : const Color(0xFFDDD5C4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: isDark ? nightBorder : const Color(0xFFDDD5C4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ember, width: 1.6),
        ),
        labelStyle: GoogleFonts.manrope(fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? ember : runway,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.spaceGrotesk(
              fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: BorderSide(color: isDark ? nightBorder : const Color(0xFFCFC7B4)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        indicatorColor: ember.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(GoogleFonts.manrope(
            fontSize: 12, fontWeight: FontWeight.w700, color: text)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? nightCard : ink,
        contentTextStyle:
            GoogleFonts.manrope(color: Colors.white, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
