// lib/utils/prefs_service.dart
// SharedPreferences wrapper for storing user data

import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_theme.dart';

class PrefsService {
  static PrefsService? _instance;
  static SharedPreferences? _prefs;

  PrefsService._();

  /// Singleton accessor
  static Future<PrefsService> getInstance() async {
    _instance ??= PrefsService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // ─── Student Data ───────────────────────────────────────────────

  Future<void> saveStudent({
    required String name,
    required String usn,
    required String section,
  }) async {
    await _prefs!.setString(AppConstants.keyStudentName, name.trim());
    await _prefs!.setString(AppConstants.keyStudentUSN, usn.trim().toUpperCase());
    await _prefs!.setString(AppConstants.keyStudentSection, section.trim().toUpperCase());
    await _prefs!.setBool(AppConstants.keyIsLoggedIn, true);
  }

  String get studentName => _prefs!.getString(AppConstants.keyStudentName) ?? '';
  String get studentUSN => _prefs!.getString(AppConstants.keyStudentUSN) ?? '';
  String get studentSection => _prefs!.getString(AppConstants.keyStudentSection) ?? '';
  bool get isLoggedIn => _prefs!.getBool(AppConstants.keyIsLoggedIn) ?? false;

  // ─── Theme ───────────────────────────────────────────────────────

  Future<void> setDarkMode(bool isDark) async {
    await _prefs!.setBool(AppConstants.keyThemeMode, isDark);
  }

  bool get isDarkMode => _prefs!.getBool(AppConstants.keyThemeMode) ?? false;

  // ─── Logout ──────────────────────────────────────────────────────

  Future<void> logout() async {
    await _prefs!.remove(AppConstants.keyStudentName);
    await _prefs!.remove(AppConstants.keyStudentUSN);
    await _prefs!.remove(AppConstants.keyStudentSection);
    await _prefs!.setBool(AppConstants.keyIsLoggedIn, false);
  }
}
