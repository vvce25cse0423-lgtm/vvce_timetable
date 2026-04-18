// lib/data/timetable_data.dart
// Complete timetable data for VVCE Mysore - 2nd Semester CSE Section G

import '../models/timetable_model.dart';

/// Time slots for the day
const List<String> timeSlots = [
  '08:30 - 09:20',
  '09:20 - 10:10',
  '10:10 - 11:00',
  '11:00 - 11:50', // After recess
  '11:50 - 12:40',
  '12:40 - 13:30', // Lunch
  '13:30 - 14:20',
  '14:20 - 15:10',
  '15:10 - 16:00',
];

/// Start times for slots (for ongoing detection)
const List<String> slotStartTimes = [
  '08:30',
  '09:20',
  '10:10',
  '11:00',
  '11:50',
  '12:40',
  '13:30',
  '14:20',
  '15:10',
];

const List<String> slotEndTimes = [
  '09:20',
  '10:10',
  '11:00',
  '11:50',
  '12:40',
  '13:30',
  '14:20',
  '15:10',
  '16:00',
];

/// VVCE 2nd Semester CSE Section G Timetable
/// Subject Codes:
/// MAT - Mathematics (Calculus & Linear Algebra)
/// CHE - Engineering Chemistry
/// PLCS - Programming Logic & Computational Skills (C Programming)
/// IECK - Introduction to Electrical & Civil Engineering
/// AIK - Artificial Intelligence & Knowledge Representation
/// ENG - Communicative English
/// CHELAB - Chemistry Lab
/// PLCSLAB - PLCS Lab
/// PE - Physical Education / Sports

final Map<String, List<ClassSlot?>> timetableData = {
  'Monday': [
    const ClassSlot(
      subjectCode: 'MAT',
      subjectName: 'Mathematics',
      faculty: 'Dr. Kavitha R',
      room: 'Room 301',
      startTime: '08:30',
      endTime: '09:20',
      type: SubjectType.mathematics,
    ),
    const ClassSlot(
      subjectCode: 'CHE',
      subjectName: 'Engineering Chemistry',
      faculty: 'Dr. Roopa M',
      room: 'Room 302',
      startTime: '09:20',
      endTime: '10:10',
      type: SubjectType.chemistry,
    ),
    const ClassSlot(
      subjectCode: 'PLCS',
      subjectName: 'C Programming',
      faculty: 'Prof. Suresh K',
      room: 'Room 201',
      startTime: '10:10',
      endTime: '11:00',
      type: SubjectType.programming,
    ),
    // Recess 11:00 - 11:15 (shown as part of slot)
    const ClassSlot(
      subjectCode: 'IECK',
      subjectName: 'Electrical & Civil Engg.',
      faculty: 'Prof. Ramesh B',
      room: 'Room 401',
      startTime: '11:00',
      endTime: '11:50',
      type: SubjectType.electronics,
    ),
    const ClassSlot(
      subjectCode: 'AIK',
      subjectName: 'Artificial Intelligence',
      faculty: 'Dr. Priya S',
      room: 'Room 202',
      startTime: '11:50',
      endTime: '12:40',
      type: SubjectType.ai,
    ),
    null, // Lunch Break
    const ClassSlot(
      subjectCode: 'ENG',
      subjectName: 'Communicative English',
      faculty: 'Prof. Anitha D',
      room: 'Room 101',
      startTime: '13:30',
      endTime: '14:20',
      type: SubjectType.english,
    ),
    const ClassSlot(
      subjectCode: 'PLCS',
      subjectName: 'C Programming',
      faculty: 'Prof. Suresh K',
      room: 'Room 201',
      startTime: '14:20',
      endTime: '15:10',
      type: SubjectType.programming,
    ),
    null, // Free Period
  ],
  'Tuesday': [
    const ClassSlot(
      subjectCode: 'ENG',
      subjectName: 'Communicative English',
      faculty: 'Prof. Anitha D',
      room: 'Room 101',
      startTime: '08:30',
      endTime: '09:20',
      type: SubjectType.english,
    ),
    const ClassSlot(
      subjectCode: 'MAT',
      subjectName: 'Mathematics',
      faculty: 'Dr. Kavitha R',
      room: 'Room 301',
      startTime: '09:20',
      endTime: '10:10',
      type: SubjectType.mathematics,
    ),
    const ClassSlot(
      subjectCode: 'AIK',
      subjectName: 'Artificial Intelligence',
      faculty: 'Dr. Priya S',
      room: 'Room 202',
      startTime: '10:10',
      endTime: '11:00',
      type: SubjectType.ai,
    ),
    const ClassSlot(
      subjectCode: 'IECK',
      subjectName: 'Electrical & Civil Engg.',
      faculty: 'Prof. Ramesh B',
      room: 'Room 401',
      startTime: '11:00',
      endTime: '11:50',
      type: SubjectType.electronics,
    ),
    const ClassSlot(
      subjectCode: 'CHE',
      subjectName: 'Engineering Chemistry',
      faculty: 'Dr. Roopa M',
      room: 'Room 302',
      startTime: '11:50',
      endTime: '12:40',
      type: SubjectType.chemistry,
    ),
    null, // Lunch Break
    // CHELAB - 3 hour lab (13:30 - 16:30)
    const ClassSlot(
      subjectCode: 'CHELAB',
      subjectName: 'Chemistry Lab',
      faculty: 'Dr. Roopa M',
      room: 'Chem Lab',
      startTime: '13:30',
      endTime: '14:20',
      type: SubjectType.lab,
    ),
    const ClassSlot(
      subjectCode: 'CHELAB',
      subjectName: 'Chemistry Lab',
      faculty: 'Dr. Roopa M',
      room: 'Chem Lab',
      startTime: '14:20',
      endTime: '15:10',
      type: SubjectType.lab,
    ),
    const ClassSlot(
      subjectCode: 'CHELAB',
      subjectName: 'Chemistry Lab',
      faculty: 'Dr. Roopa M',
      room: 'Chem Lab',
      startTime: '15:10',
      endTime: '16:00',
      type: SubjectType.lab,
    ),
  ],
  'Wednesday': [
    const ClassSlot(
      subjectCode: 'PLCS',
      subjectName: 'C Programming',
      faculty: 'Prof. Suresh K',
      room: 'Room 201',
      startTime: '08:30',
      endTime: '09:20',
      type: SubjectType.programming,
    ),
    const ClassSlot(
      subjectCode: 'IECK',
      subjectName: 'Electrical & Civil Engg.',
      faculty: 'Prof. Ramesh B',
      room: 'Room 401',
      startTime: '09:20',
      endTime: '10:10',
      type: SubjectType.electronics,
    ),
    const ClassSlot(
      subjectCode: 'MAT',
      subjectName: 'Mathematics',
      faculty: 'Dr. Kavitha R',
      room: 'Room 301',
      startTime: '10:10',
      endTime: '11:00',
      type: SubjectType.mathematics,
    ),
    const ClassSlot(
      subjectCode: 'CHE',
      subjectName: 'Engineering Chemistry',
      faculty: 'Dr. Roopa M',
      room: 'Room 302',
      startTime: '11:00',
      endTime: '11:50',
      type: SubjectType.chemistry,
    ),
    const ClassSlot(
      subjectCode: 'ENG',
      subjectName: 'Communicative English',
      faculty: 'Prof. Anitha D',
      room: 'Room 101',
      startTime: '11:50',
      endTime: '12:40',
      type: SubjectType.english,
    ),
    null, // Lunch Break
    const ClassSlot(
      subjectCode: 'AIK',
      subjectName: 'Artificial Intelligence',
      faculty: 'Dr. Priya S',
      room: 'Room 202',
      startTime: '13:30',
      endTime: '14:20',
      type: SubjectType.ai,
    ),
    const ClassSlot(
      subjectCode: 'PE',
      subjectName: 'Physical Education',
      faculty: 'Coach Manjunath',
      room: 'Sports Ground',
      startTime: '14:20',
      endTime: '15:10',
      type: SubjectType.physicalEducation,
    ),
    null, // Free
  ],
  'Thursday': [
    const ClassSlot(
      subjectCode: 'AIK',
      subjectName: 'Artificial Intelligence',
      faculty: 'Dr. Priya S',
      room: 'Room 202',
      startTime: '08:30',
      endTime: '09:20',
      type: SubjectType.ai,
    ),
    const ClassSlot(
      subjectCode: 'ENG',
      subjectName: 'Communicative English',
      faculty: 'Prof. Anitha D',
      room: 'Room 101',
      startTime: '09:20',
      endTime: '10:10',
      type: SubjectType.english,
    ),
    const ClassSlot(
      subjectCode: 'CHE',
      subjectName: 'Engineering Chemistry',
      faculty: 'Dr. Roopa M',
      room: 'Room 302',
      startTime: '10:10',
      endTime: '11:00',
      type: SubjectType.chemistry,
    ),
    const ClassSlot(
      subjectCode: 'MAT',
      subjectName: 'Mathematics',
      faculty: 'Dr. Kavitha R',
      room: 'Room 301',
      startTime: '11:00',
      endTime: '11:50',
      type: SubjectType.mathematics,
    ),
    const ClassSlot(
      subjectCode: 'PLCS',
      subjectName: 'C Programming',
      faculty: 'Prof. Suresh K',
      room: 'Room 201',
      startTime: '11:50',
      endTime: '12:40',
      type: SubjectType.programming,
    ),
    null, // Lunch Break
    // PLCS Lab - 3 hours
    const ClassSlot(
      subjectCode: 'PLCSLAB',
      subjectName: 'Programming Lab',
      faculty: 'Prof. Suresh K',
      room: 'CS Lab 1',
      startTime: '13:30',
      endTime: '14:20',
      type: SubjectType.lab,
    ),
    const ClassSlot(
      subjectCode: 'PLCSLAB',
      subjectName: 'Programming Lab',
      faculty: 'Prof. Suresh K',
      room: 'CS Lab 1',
      startTime: '14:20',
      endTime: '15:10',
      type: SubjectType.lab,
    ),
    const ClassSlot(
      subjectCode: 'PLCSLAB',
      subjectName: 'Programming Lab',
      faculty: 'Prof. Suresh K',
      room: 'CS Lab 1',
      startTime: '15:10',
      endTime: '16:00',
      type: SubjectType.lab,
    ),
  ],
  'Friday': [
    const ClassSlot(
      subjectCode: 'IECK',
      subjectName: 'Electrical & Civil Engg.',
      faculty: 'Prof. Ramesh B',
      room: 'Room 401',
      startTime: '08:30',
      endTime: '09:20',
      type: SubjectType.electronics,
    ),
    const ClassSlot(
      subjectCode: 'PLCS',
      subjectName: 'C Programming',
      faculty: 'Prof. Suresh K',
      room: 'Room 201',
      startTime: '09:20',
      endTime: '10:10',
      type: SubjectType.programming,
    ),
    const ClassSlot(
      subjectCode: 'ENG',
      subjectName: 'Communicative English',
      faculty: 'Prof. Anitha D',
      room: 'Room 101',
      startTime: '10:10',
      endTime: '11:00',
      type: SubjectType.english,
    ),
    const ClassSlot(
      subjectCode: 'AIK',
      subjectName: 'Artificial Intelligence',
      faculty: 'Dr. Priya S',
      room: 'Room 202',
      startTime: '11:00',
      endTime: '11:50',
      type: SubjectType.ai,
    ),
    const ClassSlot(
      subjectCode: 'MAT',
      subjectName: 'Mathematics',
      faculty: 'Dr. Kavitha R',
      room: 'Room 301',
      startTime: '11:50',
      endTime: '12:40',
      type: SubjectType.mathematics,
    ),
    null, // Lunch Break
    const ClassSlot(
      subjectCode: 'IECK',
      subjectName: 'Electrical & Civil Engg.',
      faculty: 'Prof. Ramesh B',
      room: 'Room 401',
      startTime: '13:30',
      endTime: '14:20',
      type: SubjectType.electronics,
    ),
    const ClassSlot(
      subjectCode: 'CHE',
      subjectName: 'Engineering Chemistry',
      faculty: 'Dr. Roopa M',
      room: 'Room 302',
      startTime: '14:20',
      endTime: '15:10',
      type: SubjectType.chemistry,
    ),
    null, // Free
  ],
};

const List<String> weekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
];
