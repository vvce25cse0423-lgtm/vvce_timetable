// lib/data/timetable_data.dart
// VVCE Mysore - 2nd Semester CSE Section G
// C-Cycle Timetable dated 12.02.2026, w.e.f 23.02.2026 (V 1.0)

import '../models/timetable_model.dart';

// Legacy timeSlots kept for compatibility
const List<String> timeSlots = [
  '08:00 - 09:00',
  '09:00 - 10:00',
  '10:00 - 10:30',
  '10:30 - 11:30',
  '11:30 - 12:30',
  '12:30 - 13:30',
  '13:30 - 14:30',
  '14:30 - 15:30',
  '15:30 - 16:30',
];

const List<String> slotStartTimes = [
  '08:00', '09:00', '10:00', '10:30', '11:30',
  '12:30', '13:30', '14:30', '15:30',
];

const List<String> slotEndTimes = [
  '09:00', '10:00', '10:30', '11:30', '12:30',
  '13:30', '14:30', '15:30', '16:30',
];

const List<String> weekDays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
];

// ─────────────────────────────────────────────────────────────────────────────
// daySchedules: each day is a List of dynamic entries — either ClassSlot or
// BreakEntry. Each ClassSlot carries its own startTime/endTime for display.
// ─────────────────────────────────────────────────────────────────────────────

final Map<String, List<dynamic>> daySchedules = {

  // ── MONDAY ────────────────────────────────────────────────────────────────
  // 09:00-10:00 AI
  // Tea Break 10:00-10:30
  // 10:30-11:30 Python
  // 11:30-12:30 Chemistry
  // Lunch 12:30-13:30
  // 13:30-15:30 Communicative Skills-II (2 hrs, single card)
  //   Faculty: Prof. Niranjan Sarja & Prof. Kirti Gupta
  //   Rooms: M-501, AB-07
  // No free period labels
  'Monday': [
    const ClassSlot(
      subjectCode: '1BAIAK204',
      subjectName: 'Intro to AI & Applications',
      faculty: 'Prof. Suraksha P',
      room: 'M-501',
      startTime: '09:00',
      endTime: '10:00',
      type: SubjectType.ai,
    ),
    const BreakEntry(timeRange: '10:00 - 10:30', isTeaBreak: true),
    const ClassSlot(
      subjectCode: '1BPLCS203',
      subjectName: 'Python Programming',
      faculty: 'Prof. Susan Shaju',
      room: 'M-501',
      startTime: '10:30',
      endTime: '11:30',
      type: SubjectType.programming,
    ),
    const ClassSlot(
      subjectCode: '1BCHES202',
      subjectName: 'Applied Chemistry',
      faculty: 'Dr. Sowmya P T',
      room: 'M-501',
      startTime: '11:30',
      endTime: '12:30',
      type: SubjectType.chemistry,
    ),
    const BreakEntry(timeRange: '12:30 - 13:30', isLunch: true),
    const ClassSlot(
      subjectCode: '1BENGK208',
      subjectName: 'Communicative Skills -II',
      faculty: 'Prof. Niranjan Sarja\nProf. Kirti Gupta',
      room: 'M-501 / AB-07',
      startTime: '13:30',
      endTime: '15:30',
      type: SubjectType.english,
    ),
  ],

  // ── TUESDAY ───────────────────────────────────────────────────────────────
  // 08:00-09:00 Maths
  // 09:00-10:00 Chemistry
  // Tea Break 10:00-10:30
  // 10:30-12:30 Maths Lab (2 hrs, single card) — 1BMATS201L
  //   Faculty: Prof. Deepa R Acharya & Prof. Pallavi
  // Lunch 12:30-13:30
  // 13:30-14:30 Electronics
  // 14:30-15:30 Python
  'Tuesday': [
    const ClassSlot(
      subjectCode: '1BMATS201',
      subjectName: 'Applied Mathematics',
      faculty: 'Prof. Deepa R Acharya',
      room: 'M-501',
      startTime: '08:00',
      endTime: '09:00',
      type: SubjectType.mathematics,
    ),
    const ClassSlot(
      subjectCode: '1BCHES202',
      subjectName: 'Applied Chemistry',
      faculty: 'Dr. Sowmya P T',
      room: 'M-501',
      startTime: '09:00',
      endTime: '10:00',
      type: SubjectType.chemistry,
    ),
    const BreakEntry(timeRange: '10:00 - 10:30', isTeaBreak: true),
    const ClassSlot(
      subjectCode: '1BMATS201L',
      subjectName: 'Applied Mathematics Lab',
      faculty: 'Prof. Deepa R Acharya\nProf. Pallavi',
      room: 'A-308',
      startTime: '10:30',
      endTime: '12:30',
      type: SubjectType.lab,
    ),
    const BreakEntry(timeRange: '12:30 - 13:30', isLunch: true),
    const ClassSlot(
      subjectCode: '1BIECK205',
      subjectName: 'Intro to Electronics Engg.',
      faculty: 'Prof. Ankitha D M',
      room: 'M-501',
      startTime: '13:30',
      endTime: '14:30',
      type: SubjectType.electronics,
    ),
    const ClassSlot(
      subjectCode: '1BPLCS203',
      subjectName: 'Python Programming',
      faculty: 'Prof. Susan Shaju',
      room: 'M-501',
      startTime: '14:30',
      endTime: '15:30',
      type: SubjectType.programming,
    ),
  ],

  // ── WEDNESDAY ─────────────────────────────────────────────────────────────
  // 08:00-09:00 Maths
  // 09:00-10:00 Electronics
  // Tea Break 10:00-10:30
  // 10:30-11:30 Chemistry Lab (single card)
  // No lunch, no afternoon
  'Wednesday': [
    const ClassSlot(
      subjectCode: '1BMATS201',
      subjectName: 'Applied Mathematics',
      faculty: 'Prof. Deepa R Acharya',
      room: 'M-501',
      startTime: '08:00',
      endTime: '09:00',
      type: SubjectType.mathematics,
    ),
    const ClassSlot(
      subjectCode: '1BIECK205',
      subjectName: 'Intro to Electronics Engg.',
      faculty: 'Prof. Ankitha D M',
      room: 'M-501',
      startTime: '09:00',
      endTime: '10:00',
      type: SubjectType.electronics,
    ),
    const BreakEntry(timeRange: '10:00 - 10:30', isTeaBreak: true),
    const ClassSlot(
      subjectCode: '1BCHESL206',
      subjectName: 'Applied Chemistry Lab',
      faculty: 'Dr. Anitha Sudhir',
      room: 'G-202',
      startTime: '10:30',
      endTime: '11:30',
      type: SubjectType.lab,
    ),
  ],

  // ── THURSDAY ──────────────────────────────────────────────────────────────
  // 09:00-10:00 Kannada
  // Tea Break 10:00-10:30
  // 10:30-11:30 AI
  // 11:30-12:30 Electronics
  // Lunch 12:30-13:30
  // 13:30-14:30 Chemistry
  // 14:30-15:30 Maths
  // No free period labels (08:00 slot removed)
  'Thursday': [
    const ClassSlot(
      subjectCode: '1BKSKK210',
      subjectName: 'Samskruthika Kannada',
      faculty: 'Ms. Ashwini H B',
      room: 'M-501',
      startTime: '09:00',
      endTime: '10:00',
      type: SubjectType.kannada,
    ),
    const BreakEntry(timeRange: '10:00 - 10:30', isTeaBreak: true),
    const ClassSlot(
      subjectCode: '1BAIAK204',
      subjectName: 'Intro to AI & Applications',
      faculty: 'Prof. Suraksha P',
      room: 'M-501',
      startTime: '10:30',
      endTime: '11:30',
      type: SubjectType.ai,
    ),
    const ClassSlot(
      subjectCode: '1BIECK205',
      subjectName: 'Intro to Electronics Engg.',
      faculty: 'Prof. Ankitha D M',
      room: 'M-501',
      startTime: '11:30',
      endTime: '12:30',
      type: SubjectType.electronics,
    ),
    const BreakEntry(timeRange: '12:30 - 13:30', isLunch: true),
    const ClassSlot(
      subjectCode: '1BCHES202',
      subjectName: 'Applied Chemistry',
      faculty: 'Dr. Sowmya P T',
      room: 'M-501',
      startTime: '13:30',
      endTime: '14:30',
      type: SubjectType.chemistry,
    ),
    const ClassSlot(
      subjectCode: '1BMATS201',
      subjectName: 'Applied Mathematics',
      faculty: 'Prof. Deepa R Acharya',
      room: 'M-501',
      startTime: '14:30',
      endTime: '15:30',
      type: SubjectType.mathematics,
    ),
  ],

  // ── FRIDAY ────────────────────────────────────────────────────────────────
  // 08:00-10:00 Python Lab (2 hrs, single card) — 1BPLCSL207
  // Tea Break 10:00-10:30
  // 10:30-11:30 Maths
  // 11:30-12:30 Python
  // Lunch 12:30-13:30
  // 13:30-14:30 Project-Based Learning (single card)
  'Friday': [
    const ClassSlot(
      subjectCode: '1BPLCSL207',
      subjectName: 'Python Programming Lab',
      faculty: 'Prof. Susan Shaju',
      room: 'M-317',
      startTime: '08:00',
      endTime: '10:00',
      type: SubjectType.lab,
    ),
    const BreakEntry(timeRange: '10:00 - 10:30', isTeaBreak: true),
    const ClassSlot(
      subjectCode: '1BMATS201',
      subjectName: 'Applied Mathematics',
      faculty: 'Prof. Deepa R Acharya',
      room: 'M-501',
      startTime: '10:30',
      endTime: '11:30',
      type: SubjectType.mathematics,
    ),
    const ClassSlot(
      subjectCode: '1BPLCS203',
      subjectName: 'Python Programming',
      faculty: 'Prof. Susan Shaju',
      room: 'M-501',
      startTime: '11:30',
      endTime: '12:30',
      type: SubjectType.programming,
    ),
    const BreakEntry(timeRange: '12:30 - 13:30', isLunch: true),
    const ClassSlot(
      subjectCode: '1BPBLK209',
      subjectName: 'Project-Based Learning',
      faculty: 'Prof. Kavyashree G',
      room: 'D-012',
      startTime: '13:30',
      endTime: '14:30',
      type: SubjectType.lab,
    ),
  ],
};

// Legacy map kept for stats_widget compatibility
final Map<String, List<ClassSlot?>> timetableData = {
  for (final entry in daySchedules.entries)
    entry.key: entry.value.map((e) => e is ClassSlot ? e : null).toList(),
};
