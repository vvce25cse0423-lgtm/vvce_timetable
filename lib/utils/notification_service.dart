// lib/utils/notification_service.dart
// Handles local notifications — fires 5 min before each class starts

import 'dart:async';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/timetable_data.dart';
import '../models/timetable_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  final List<Timer> _pendingTimers = [];

  // ── Notification channel details ─────────────────────────────────────────
  static const _androidDetails = AndroidNotificationDetails(
    'vvce_class_channel',
    'Class Reminders',
    channelDescription: 'Notifies 5 minutes before each class starts',
    importance: Importance.high,
    priority: Priority.high,
    color: Color(0xFF1A237E),
    enableVibration: true,
    playSound: true,
  );

  static const _notifDetails = NotificationDetails(
    android: _androidDetails,
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  // ── Initialize ───────────────────────────────────────────────────────────
  Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
    _initialized = true;
  }

  // ── Request permissions (Android 13+) ────────────────────────────────────
  Future<void> requestPermission() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  // ── Schedule all reminders for today ─────────────────────────────────────
  Future<void> scheduleNotificationsForToday() async {
    await init();

    // Cancel any pending timers
    for (final t in _pendingTimers) {
      t.cancel();
    }
    _pendingTimers.clear();
    await _plugin.cancelAll();

    final now = DateTime.now();
    final weekday = now.weekday; // 1=Mon..5=Fri
    if (weekday < 1 || weekday > 5) return;

    const dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final todayName = dayNames[weekday - 1];
    final entries = daySchedules[todayName] ?? [];

    int notifId = 100; // start from 100 to avoid conflicts
    for (final entry in entries) {
      if (entry is! ClassSlot) continue;

      final parts = entry.startTime.split(':');
      final classHour = int.parse(parts[0]);
      final classMin  = int.parse(parts[1]);

      // Fire notification 5 minutes before class
      final fireAt = DateTime(now.year, now.month, now.day, classHour, classMin)
          .subtract(const Duration(minutes: 5));

      final delay = fireAt.difference(now);
      if (delay.isNegative) continue; // already past

      final id = notifId++;
      final title = '⏰ Class Starting in 5 Minutes!';
      final body  = '${entry.subjectName}\n'
                    '${entry.startTime} – ${entry.endTime}  |  Room: ${entry.room}';

      // Use a Dart Timer to fire the notification at the right time
      final timer = Timer(delay, () async {
        await _plugin.show(id, title, body, _notifDetails);
      });
      _pendingTimers.add(timer);
    }
  }

  // ── Cancel everything ────────────────────────────────────────────────────
  Future<void> cancelAll() async {
    for (final t in _pendingTimers) {
      t.cancel();
    }
    _pendingTimers.clear();
    await _plugin.cancelAll();
  }
}
