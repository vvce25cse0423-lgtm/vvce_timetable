// lib/data/timetable_data.dart
// VVCE 2nd Sem CSE Section G — C-Cycle w.e.f 23.02.2026

import '../models/timetable_model.dart';

const List<String> weekDays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
];

// Legacy timeSlots (kept for stats widget)
const List<String> timeSlots = [
  '08:00 - 09:00', '09:00 - 10:00', '10:00 - 10:30',
  '10:30 - 11:30', '11:30 - 12:30', '12:30 - 13:30',
  '13:30 - 14:30', '14:30 - 15:30', '15:30 - 16:30',
];

const List<String> slotStartTimes = [
  '08:00','09:00','10:00','10:30','11:30','12:30','13:30','14:30','15:30',
];
const List<String> slotEndTimes = [
  '09:00','10:00','10:30','11:30','12:30','13:30','14:30','15:30','16:30',
];

// ─────────────────────────────────────────────────────────────────────────────
// daySchedules — List<dynamic> of ClassSlot | BreakEntry per day
// ─────────────────────────────────────────────────────────────────────────────

final Map<String, List<dynamic>> daySchedules = {

  // ── MONDAY ────────────────────────────────────────────────────────────────
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
    // Communicative Skills-II: 13:30-15:30 (2 hrs)
    // Faculty: Prof. Niranjan Sarja + Prof. Kirti Gupta | Rooms: M-501 / AB-07
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
    // Maths Lab: 10:30-12:30 (2 hrs, single card)
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
  // Chem Lab 10:30-12:30 (2 hrs) — group-based faculty & room
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
    // Applied Chemistry Lab — 10:30 to 12:30 — group-specific faculty & room
    ClassSlot(
      subjectCode: '1BCHESL206',
      subjectName: 'Applied Chemistry Lab',
      faculty: 'Dr. Anitha Sudhir',      // default (G1)
      room: 'G-202',                      // default (G1)
      startTime: '10:30',
      endTime: '12:30',
      type: SubjectType.lab,
      groupFaculty: const {
        'G1': 'Dr. Anitha Sudhir',
        'G2': 'Dr. Vrushabendra B',
        'G3': 'Dr. Sowmya P T',
      },
      groupRoom: const {
        'G1': 'G-202',
        'G2': 'G-201',
        'G3': 'G-003',
      },
    ),
  ],

  // ── THURSDAY ──────────────────────────────────────────────────────────────
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
  // Python Lab: 08:00-10:00 (2 hrs, single card)
  // Tea Break: 10:00-10:30
  // Maths: 10:30-11:30
  // Python: 11:30-12:30
  // Lunch: 12:30-13:30
  // Project Lab: 13:30-14:30 (single card)
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
    // Project-Based Learning — 3 faculty, room M-402
    const ClassSlot(
      subjectCode: '1BPBLK209',
      subjectName: 'Project-Based Learning',
      faculty: 'Prof. Sathwik Shetty\nProf. Uday\nProf. Keerthana',
      room: 'M-402',
      startTime: '13:30',
      endTime: '14:30',
      type: SubjectType.lab,
    ),
  ],
};

// Legacy map for stats_widget compatibility
final Map<String, List<ClassSlot?>> timetableData = {
  for (final e in daySchedules.entries)
    e.key: e.value.map((s) => s is ClassSlot ? s : null).toList(),
};
