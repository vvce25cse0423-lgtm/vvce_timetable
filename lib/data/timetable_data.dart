// lib/data/timetable_data.dart
// VVCE Mysore - 2nd Semester CSE Section G
// C-Cycle Timetable dated 12.02.2026, w.e.f 23.02.2026 (V 1.0)
// Updated per Nitin Mahadev's corrections

import '../models/timetable_model.dart';

/// Time slots matching the official timetable:
/// 08:00-09:00 | 09:00-10:00 | Tea Break 10:00-10:30
/// 10:30-11:30 | 11:30-12:30 | Lunch 12:30-13:30
/// 13:30-14:30 | 14:30-15:30 | 15:30-16:30
/// Index: 0       1             2(tea)
///        3       4             5(lunch)
///        6       7             8

const List<String> timeSlots = [
  '08:00 - 09:00',
  '09:00 - 10:00',
  '10:00 - 10:30',   // Tea Break
  '10:30 - 11:30',
  '11:30 - 12:30',
  '12:30 - 13:30',   // Lunch Break
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

final Map<String, List<ClassSlot?>> timetableData = {

  // ── MONDAY ──────────────────────────────────────────────────────────
  // Changes: Remove Free periods, Kannada removed,
  //          Comm Skills merged to 1 block, faculty → Prof. Niranjan Sarja, room AB-07
  'Monday': [
    null, // 08:00 - empty
    const ClassSlot(
      subjectCode: '1BAIAK204',
      subjectName: 'Intro to AI & Applications',
      faculty: 'Prof. Suraksha P',
      room: 'M-501',
      startTime: '09:00',
      endTime: '10:00',
      type: SubjectType.ai,
    ),
    null, // Tea Break
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
    null, // Lunch Break
    const ClassSlot(
      subjectCode: '1BENGK208',
      subjectName: 'Communicative Skills -II',
      faculty: 'Prof. Niranjan Sarja',
      room: 'AB-07',
      startTime: '13:30',
      endTime: '14:30',
      type: SubjectType.english,
    ),
    // Slot 7 (14:30) empty — Comm Skills now single block
    // Slot 8 (15:30) empty — Kannada removed
  ],

  // ── TUESDAY ─────────────────────────────────────────────────────────
  // Changes: Remove Free periods,
  //          Maths Lab merged to 1 block, code→1BMATS201L, add Prof. Pallavi
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
    null, // Tea Break
    const ClassSlot(
      subjectCode: '1BMATS201L',
      subjectName: 'Applied Mathematics Lab',
      faculty: 'Prof. Deepa R Acharya & Prof. Pallavi',
      room: 'A-308',
      startTime: '10:30',
      endTime: '11:30',
      type: SubjectType.lab,
    ),
    // Slot 4 (11:30) empty — Maths Lab now single block
    null, // Lunch Break
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
    // Slot 8 (15:30) removed
  ],

  // ── WEDNESDAY ───────────────────────────────────────────────────────
  // Changes: Chem Lab merged to 1 block, Lunch Break removed,
  //          free afternoon slots removed
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
    null, // Tea Break
    const ClassSlot(
      subjectCode: '1BCHESL206',
      subjectName: 'Applied Chemistry Lab',
      faculty: 'Dr. Anitha Sudhir',
      room: 'G-202',
      startTime: '10:30',
      endTime: '11:30',
      type: SubjectType.lab,
    ),
    // Slot 4 (11:30) — Chem Lab now single block, no second block
    // No Lunch Break on Wednesday
    // No afternoon slots on Wednesday
  ],

  // ── THURSDAY ────────────────────────────────────────────────────────
  // Changes: Remove free periods
  'Thursday': [
    null, // 08:00 empty
    const ClassSlot(
      subjectCode: '1BKSKK210',
      subjectName: 'Samskruthika Kannada',
      faculty: 'Ms. Ashwini H B',
      room: 'M-501',
      startTime: '09:00',
      endTime: '10:00',
      type: SubjectType.kannada,
    ),
    null, // Tea Break
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
    null, // Lunch Break
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
    // Slot 8 (15:30) removed — no free period
  ],

  // ── FRIDAY ──────────────────────────────────────────────────────────
  // Changes: Python Lab → single block, Project Lab → single block,
  //          free periods removed
  'Friday': [
    const ClassSlot(
      subjectCode: '1BPLCSL207',
      subjectName: 'Python Programming Lab',
      faculty: 'Prof. Susan Shaju',
      room: 'M-317',
      startTime: '08:00',
      endTime: '09:00',
      type: SubjectType.lab,
    ),
    // Slot 1 (09:00) — Python Lab now single block
    null, // Tea Break
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
    null, // Lunch Break
    const ClassSlot(
      subjectCode: '1BPBLK209',
      subjectName: 'Project-Based Learning',
      faculty: 'Prof. Kavyashree G',
      room: 'D-012',
      startTime: '13:30',
      endTime: '14:30',
      type: SubjectType.lab,
    ),
    // Slot 7 (14:30) — Project Lab now single block, removed free period
  ],
};

const List<String> weekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
];
