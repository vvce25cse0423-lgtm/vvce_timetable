// lib/utils/prefs_service.dart
// SharedPreferences wrapper — includes device-lock (1 account = 1 device)

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_theme.dart';

class PrefsService {
  static PrefsService? _instance;
  static SharedPreferences? _prefs;

  PrefsService._();

  static Future<PrefsService> getInstance() async {
    _instance ??= PrefsService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // ─── Device ID ───────────────────────────────────────────────────────────

  /// Returns a stable unique device fingerprint (hashed)
  Future<String> getDeviceId() async {
    try {
      final info = DeviceInfoPlugin();
      String raw = '';
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = await info.androidInfo;
        raw = '${android.id}-${android.model}-${android.brand}';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = await info.iosInfo;
        raw = ios.identifierForVendor ?? 'ios-unknown';
      } else {
        raw = 'unknown-device';
      }
      // SHA-256 hash so we never store raw device info
      final hash = sha256.convert(utf8.encode(raw)).toString();
      return hash.substring(0, 16); // short fingerprint
    } catch (_) {
      return 'fallback-device';
    }
  }

  // ─── Student Data ─────────────────────────────────────────────────────────

  Future<void> saveStudent({
    required String name,
    required String usn,
    required String section,
    String group = 'G1',
  }) async {
    final deviceId = await getDeviceId();
    await _prefs!.setString(AppConstants.keyStudentName, name.trim());
    await _prefs!.setString(AppConstants.keyStudentUSN, usn.trim().toUpperCase());
    await _prefs!.setString(AppConstants.keyStudentSection, section.trim().toUpperCase());
    await _prefs!.setString('student_group', group.trim().toUpperCase());
    await _prefs!.setString('device_id', deviceId);
    await _prefs!.setBool(AppConstants.keyIsLoggedIn, true);
  }

  String get studentName    => _prefs!.getString(AppConstants.keyStudentName) ?? '';
  String get studentUSN     => _prefs!.getString(AppConstants.keyStudentUSN) ?? '';
  String get studentSection => _prefs!.getString(AppConstants.keyStudentSection) ?? '';
  String get studentGroup   => _prefs!.getString('student_group') ?? 'G1';
  String get savedDeviceId  => _prefs!.getString('device_id') ?? '';
  bool   get isLoggedIn     => _prefs!.getBool(AppConstants.keyIsLoggedIn) ?? false;

  /// Returns true if current device matches the device that logged in
  Future<bool> isCurrentDevice() async {
    if (!isLoggedIn) return true; // not logged in, no conflict
    final currentId = await getDeviceId();
    final saved     = savedDeviceId;
    if (saved.isEmpty) return true; // first time, allow
    return currentId == saved;
  }

  // ─── Theme ───────────────────────────────────────────────────────────────

  Future<void> setDarkMode(bool isDark) async {
    await _prefs!.setBool(AppConstants.keyThemeMode, isDark);
  }

  bool get isDarkMode => _prefs!.getBool(AppConstants.keyThemeMode) ?? false;

  // ─── Logout ──────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await _prefs!.remove(AppConstants.keyStudentName);
    await _prefs!.remove(AppConstants.keyStudentUSN);
    await _prefs!.remove(AppConstants.keyStudentSection);
    await _prefs!.remove('student_group');
    await _prefs!.remove('device_id');
    await _prefs!.setBool(AppConstants.keyIsLoggedIn, false);
  }
}
