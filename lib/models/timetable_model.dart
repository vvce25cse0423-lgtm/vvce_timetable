// lib/models/timetable_model.dart
// Data models for the VVCE Timetable App

import 'package:flutter/material.dart';

/// Represents a single class/lecture slot
class ClassSlot {
  final String subjectCode;
  final String subjectName;
  final String faculty;
  final String room;
  final String startTime;
  final String endTime;
  final SubjectType type;
  /// Optional per-group faculty overrides: {'G1': 'Dr. X', 'G2': 'Dr. Y', 'G3': 'Dr. Z'}
  final Map<String, String>? groupFaculty;
  /// Optional per-group room overrides: {'G1': 'G-202', 'G2': 'G-201', 'G3': 'G-003'}
  final Map<String, String>? groupRoom;

  const ClassSlot({
    required this.subjectCode,
    required this.subjectName,
    required this.faculty,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.groupFaculty,
    this.groupRoom,
  });

  /// Returns faculty for a given group (falls back to default faculty)
  String facultyForGroup(String group) =>
      groupFaculty?[group] ?? faculty;

  /// Returns room for a given group (falls back to default room)
  String roomForGroup(String group) =>
      groupRoom?[group] ?? room;

  /// Returns true if this class is currently ongoing
  bool isOngoing() {
    final now = TimeOfDay.now();
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return nowMinutes >= startMinutes && nowMinutes < endMinutes;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

/// Represents a full day's schedule
class DaySchedule {
  final String dayName;
  final List<ClassSlot?> slots; // null means free/break slot

  const DaySchedule({
    required this.dayName,
    required this.slots,
  });
}

/// Subject types to map icons and colors
enum SubjectType {
  mathematics,
  chemistry,
  programming,
  electronics,
  ai,
  english,
  lab,
  physicalEducation,
  kannada,
  free,
}


/// A break slot (Tea Break, Lunch, etc.) used in daySchedules
class BreakEntry {
  final String timeRange;
  final bool isLunch;
  final bool isTeaBreak;

  const BreakEntry({
    required this.timeRange,
    this.isLunch = false,
    this.isTeaBreak = false,
  });
}
/// Student data model
class Student {
  final String name;
  final String usn;
  final String section;

  const Student({
    required this.name,
    required this.usn,
    required this.section,
  });

  Map<String, String> toMap() => {
        'name': name,
        'usn': usn,
        'section': section,
      };

  factory Student.fromMap(Map<String, String> map) => Student(
        name: map['name'] ?? '',
        usn: map['usn'] ?? '',
        section: map['section'] ?? '',
      );
}
