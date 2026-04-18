// lib/utils/app_theme.dart
// Theme configuration for VVCE Timetable App

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/timetable_model.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF1A237E);
  static const Color accentGold = Color(0xFFFFB300);
  static const Color backgroundLight = Color(0xFFF5F7FF);
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color cardDark = Color(0xFF21262D);

  // Subject Colors (Light Mode)
  static const Map<SubjectType, Color> subjectColors = {
    SubjectType.mathematics: Color(0xFF7C4DFF),
    SubjectType.chemistry: Color(0xFF00897B),
    SubjectType.programming: Color(0xFF1E88E5),
    SubjectType.electronics: Color(0xFFE53935),
    SubjectType.ai: Color(0xFFFF6F00),
    SubjectType.english: Color(0xFF43A047),
    SubjectType.lab: Color(0xFF8D6E63),
    SubjectType.physicalEducation: Color(0xFF039BE5),
    SubjectType.free: Color(0xFF90A4AE),
  };

  // Subject Colors Dark Mode (slightly lighter)
  static const Map<SubjectType, Color> subjectColorsDark = {
    SubjectType.mathematics: Color(0xFF9C6FFF),
    SubjectType.chemistry: Color(0xFF26A69A),
    SubjectType.programming: Color(0xFF42A5F5),
    SubjectType.electronics: Color(0xFFEF5350),
    SubjectType.ai: Color(0xFFFFB74D),
    SubjectType.english: Color(0xFF66BB6A),
    SubjectType.lab: Color(0xFFA1887F),
    SubjectType.physicalEducation: Color(0xFF29B6F6),
    SubjectType.free: Color(0xFFB0BEC5),
  };

  static Color getSubjectColor(SubjectType type, bool isDark) {
    return isDark
        ? subjectColorsDark[type] ?? subjectColorsDark[SubjectType.free]!
        : subjectColors[type] ?? subjectColors[SubjectType.free]!;
  }

  static IconData getSubjectIcon(SubjectType type) {
    switch (type) {
      case SubjectType.mathematics:
        return Icons.calculate_rounded;
      case SubjectType.chemistry:
        return Icons.science_rounded;
      case SubjectType.programming:
        return Icons.code_rounded;
      case SubjectType.electronics:
        return Icons.electrical_services_rounded;
      case SubjectType.ai:
        return Icons.smart_toy_rounded;
      case SubjectType.english:
        return Icons.menu_book_rounded;
      case SubjectType.lab:
        return Icons.biotech_rounded;
      case SubjectType.physicalEducation:
        return Icons.sports_soccer_rounded;
      case SubjectType.free:
        return Icons.free_breakfast_rounded;
    }
  }

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        primary: primaryBlue,
        secondary: accentGold,
        surface: Colors.white,
        background: backgroundLight,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: primaryBlue,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.poppins(fontSize: 14),
        labelSmall: GoogleFonts.poppins(fontSize: 11),
      ),
      cardTheme: const CardTheme(
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        primary: const Color(0xFF7986CB),
        secondary: accentGold,
        surface: surfaceDark,
        background: backgroundDark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardTheme(
        color: cardDark,
        elevation: 4,
        shadowColor: Colors.black45,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF30363D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF7986CB), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

/// App-wide constants
class AppConstants {
  static const String appName = 'VVCE TimeTable';
  static const String collegeName = 'Vivekananda Vidyavardhaka\nCollege of Engineering';
  static const String collegeShort = 'VVCE Mysore';
  static const String semester = '2nd Semester';
  static const String branch = 'Computer Science & Engineering';
  static const String section = 'Section G';

  // SharedPreferences keys
  static const String keyStudentName = 'student_name';
  static const String keyStudentUSN = 'student_usn';
  static const String keyStudentSection = 'student_section';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyThemeMode = 'theme_mode';
}
