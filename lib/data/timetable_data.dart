// lib/data/timetable_data.dart
// VVCE Mysore - 2nd Semester CSE Section G
// C-Cycle Timetable dated 12.02.2026, w.e.f 23.02.2026 (V 1.0)

import '../models/timetable_model.dart';

/// Time slots matching the official timetable:
/// 08:00-09:00 | 09:00-10:00 | Tea Break 10:00-10:30
/// 10:30-11:30 | 11:30-12:30 | Lunch 12:30-13:30
/// 13:30-14:30 | 14:30-15:30 | 15:30-16:30

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

// Index 2 = Tea Break, Index 5 = Lunch Break

final Map<String, List<ClassSlot?>> timetableData = {

  'Monday': [
    null, // 08:00-09:00 empty
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
      faculty: 'Prof. Ichha Jinesh',
      room: 'M-501',
      startTime: '13:30',
      endTime: '14:30',
      type: SubjectType.english,
    ),
    const ClassSlot(
      subjectCode: '1BENGK208',
      subjectName: 'Communicative Skills -II',
      faculty: 'Prof. Kirti Gupta',
      room: 'M-501',
      startTime: '14:30',
      endTime: '15:30',
      type: SubjectType.english,
    ),
    const ClassSlot(
      subjectCode: '1BKBKK210',
      subjectName: 'Samskruthika Kannada',
      faculty: 'Ms. Ashwini H B',
      room: 'M-101',
      startTime: '15:30',
      endTime: '16:30',
      type: SubjectType.kannada,
    ),
  ],

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
      subjectCode: '1BMATS201',
      subjectName: 'Applied Mathematics Lab',
      faculty: 'Prof. Deepa R Acharya',
      room: 'A-308',
      startTime: '10:30',
      endTime: '11:30',
      type: SubjectType.lab,
    ),
    const ClassSlot(
      subjectCode: '1BMATS201',
      subjectName: 'Applied Mathematics Lab',
      faculty: 'Prof. Deepa R Acharya',
      room: 'A-308',
      startTime: '11:30',
      endTime: '12:30',
      type: SubjectType.lab,
    ),
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
    null, // 15:30 empty
  ],

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
    const ClassSlot(
      subjectCode: '1BCHESL206',
      subjectName: 'Applied Chemistry Lab',
      faculty: 'Dr. Anitha Sudhir',
      room: 'G-202',
      startTime: '11:30',
      endTime: '12:30',
      type: SubjectType.lab,
    ),
    null, // Lunch Break
    null, // 13:30 empty
    null, // 14:30 empty
    null, // 15:30 empty
  ],

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
    null, // 15:30 empty
  ],

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
    const ClassSlot(
      subjectCode: '1BPLCSL207',
      subjectName: 'Python Programming Lab',
      faculty: 'Prof. Susan Shaju',
      room: 'M-317',
      startTime: '09:00',
      endTime: '10:00',
      type: SubjectType.lab,
    ),
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
    const ClassSlot(
      subjectCode: '1BPBLK209',
      subjectName: 'Project-Based Learning',
      faculty: 'Prof. Kavyashree G',
      room: 'D-012',
      startTime: '14:30',
      endTime: '15:30',
      type: SubjectType.lab,
    ),
    null, // 15:30 empty
  ],
};

const List<String> weekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
];
