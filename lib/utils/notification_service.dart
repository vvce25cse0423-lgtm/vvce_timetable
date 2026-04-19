// lib/utils/notification_service.dart
// Background-capable notifications using zonedSchedule
// Works even when the app is closed — 5 min before EVERY class, break & lunch

import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;
import '../data/timetable_data.dart';
import '../models/timetable_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // ── Channel configs ───────────────────────────────────────────────────────
  static const _classChannel = AndroidNotificationDetails(
    'vvce_class_channel',
    'Class Reminders',
    channelDescription: 'Alerts 5 min before every class, break & lunch',
    importance: Importance.max,
    priority: Priority.high,
    color: Color(0xFF1A237E),
    enableVibration: true,
    playSound: true,
    fullScreenIntent: true,       // shows on lock screen
    visibility: NotificationVisibility.public,
  );

  static const _breakChannel = AndroidNotificationDetails(
    'vvce_break_channel',
    'Break Reminders',
    channelDescription: 'Alerts 5 min before Tea Break and Lunch Break',
    importance: Importance.high,
    priority: Priority.high,
    color: Color(0xFFFFB300),
    enableVibration: true,
    playSound: true,
    visibility: NotificationVisibility.public,
  );

  static const _classNotifDetails = NotificationDetails(
    android: _classChannel,
    iOS: DarwinNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    ),
  );

  static const _breakNotifDetails = NotificationDetails(
    android: _breakChannel,
    iOS: DarwinNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true,
    ),
  );

  // ── Init ─────────────────────────────────────────────────────────────────
  Future<void> init() async {
    if (_initialized) return;

    // Init timezone database — needed for zonedSchedule
    tzData.initializeTimeZones();
    // Set to India timezone
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (_) {},
    );
    _initialized = true;
  }

  // ── Request permissions ───────────────────────────────────────────────────
  Future<void> requestPermission() async {
    await init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  // ── Schedule ALL notifications for today ─────────────────────────────────
  // Uses zonedSchedule → survives app close/kill
  Future<void> scheduleNotificationsForToday() async {
    await init();
    await _plugin.cancelAll(); // clear old ones

    final now = DateTime.now();
    final weekday = now.weekday;
    if (weekday < 1 || weekday > 5) return; // weekend — skip

    const dayNames = ['Monday','Tuesday','Wednesday','Thursday','Friday'];
    final todayName = dayNames[weekday - 1];
    final entries = daySchedules[todayName] ?? [];

    int id = 200;

    for (final entry in entries) {
      if (entry is ClassSlot) {
        // ── Class notification ──────────────────────────────────────
        final fireAt = _fireTime(now, entry.startTime, minutesBefore: 5);
        if (fireAt == null) continue;

        await _scheduleOne(
          id: id++,
          title: '⏰ Class in 5 Minutes!',
          body: '${entry.subjectName}  •  ${entry.startTime}–${entry.endTime}\n📍 Room: ${entry.room}',
          when: fireAt,
          details: _classNotifDetails,
        );

      } else if (entry is BreakEntry) {
        // ── Break / Lunch notification ──────────────────────────────
        final startStr = entry.timeRange.split(' - ')[0].trim();
        final fireAt = _fireTime(now, startStr, minutesBefore: 5);
        if (fireAt == null) continue;

        final isLunch = entry.isLunch;
        final emoji   = isLunch ? '🍽️' : '☕';
        final label   = isLunch ? 'Lunch Break' : 'Tea Break';
        final body    = isLunch
            ? 'Lunch Break starts at ${startStr.trim()}  •  Next class after 13:30'
            : 'Tea Break starting at ${startStr.trim()}  •  Refreshment time!';

        await _scheduleOne(
          id: id++,
          title: '$emoji $label in 5 Minutes!',
          body: body,
          when: fireAt,
          details: _breakNotifDetails,
        );
      }
    }
  }

  // ── Schedule a single zonedSchedule notification ──────────────────────────
  Future<void> _scheduleOne({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime when,
    required NotificationDetails details,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      when,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ── Build TZDateTime 5 min before a given "HH:mm" time string ─────────────
  tz.TZDateTime? _fireTime(DateTime now, String timeStr, {required int minutesBefore}) {
    try {
      final parts   = timeStr.split(':');
      final hour    = int.parse(parts[0]);
      final minute  = int.parse(parts[1]);
      final classTime = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute,
      );
      final fireAt = classTime.subtract(Duration(minutes: minutesBefore));
      // Skip if already past
      if (fireAt.isBefore(tz.TZDateTime.now(tz.local))) return null;
      return fireAt;
    } catch (_) {
      return null;
    }
  }

  // ── Cancel all ────────────────────────────────────────────────────────────
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
