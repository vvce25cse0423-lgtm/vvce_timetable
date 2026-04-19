// lib/data/student_data.dart
// Section G Student List — C-Cycle V1.0 (20.02.2026)
// Source: SECTION WISE STUDENT LIST CSE SECTION-G

/// A student record with USN, name, and group
class StudentRecord {
  final String usn;
  final String name;
  final String group;
  const StudentRecord(this.usn, this.name, this.group);
}

/// Complete student list for CSE Section G
const List<StudentRecord> sectionGStudents = [
  // ── GROUP G1 ────────────────────────────────────────────────────
  StudentRecord('4EV25CS117', 'MONISHA G K',         'G1'),
  StudentRecord('4EV25CS121', 'NAYANA M M',          'G1'),
  StudentRecord('4EV25CS125', 'NISHCHITH RAJU',      'G1'),
  StudentRecord('4EV25CS126', 'NISHCHITHA H S',      'G1'),
  StudentRecord('4EV25CS127', 'NISHKA KIRAN',        'G1'),
  StudentRecord('4EV25CS128', 'NITHIN MANJUNATH J K','G1'),
  StudentRecord('4EV25CS129', 'NITHYASHREE R B',     'G1'),
  StudentRecord('4EV25CS130', 'NYRUTHYA N M',        'G1'),
  StudentRecord('4EV25CS131', 'P NAVYASHREE',        'G1'),
  StudentRecord('4EV25CS132', 'PALGUNI N RAJ',       'G1'),
  StudentRecord('4EV25CS133', 'POOJA N',             'G1'),
  StudentRecord('4EV25CS135', 'POORVIKA M P',        'G1'),
  StudentRecord('4EV25CS136', 'PRAJWAL GONI',        'G1'),
  StudentRecord('4EV25CS138', 'PRATHAM T C',         'G1'),
  StudentRecord('4EV25CS139', 'PRATHAP M M',         'G1'),
  StudentRecord('4EV25CS140', 'PREETHAM M N',        'G1'),
  StudentRecord('4EV25CS141', 'PREETHAM S P',        'G1'),
  StudentRecord('4EV25CS142', 'PREETHI P',           'G1'),
  StudentRecord('4EV25CS143', 'PREETI SAJJAN',       'G1'),
  StudentRecord('4EV25CS144', 'PREETAM RAJ M',       'G1'),
  StudentRecord('4TV25CS120', 'NAMRATHA SURESH',     'G1'),
  StudentRecord('4TV25CS131', 'NITIN MAHADEV B K',   'G1'),

  // ── GROUP G2 ────────────────────────────────────────────────────
  StudentRecord('4TV25CS133', 'PALLAVI AMBIGER',     'G2'),
  StudentRecord('4TV25CS135', 'POOJA B M',           'G2'),
  StudentRecord('4TV25CS137', 'PRAKRUTHI J',         'G2'),
  StudentRecord('4TV25CS141', 'PRASHAMSA K SHANKAR', 'G2'),
  StudentRecord('4TV25CS142', 'PRATHAM J',           'G2'),
  StudentRecord('4TV25CS143', 'PRATHEEK M',          'G2'),
  StudentRecord('4TV25CS144', 'PRATHIKSHA D',        'G2'),
  StudentRecord('4TV25CS145', 'PRATHIKSHA H K',      'G2'),
  StudentRecord('4TV25CS146', 'PRATIBHA G N',        'G2'),
  StudentRecord('4TV25CS147', 'PREETHAM C M',        'G2'),
  StudentRecord('4TV25CS149', 'PREETHAM M P',        'G2'),
  StudentRecord('4TV25CS150', 'PREETHAM R',          'G2'),
  StudentRecord('4TV25CS151', 'PREETHAM SANTHOSH',   'G2'),
  StudentRecord('4TV25CS152', 'PREETHAM U',          'G2'),
  StudentRecord('4TV25CS153', 'PREETHAM Y M',        'G2'),
  StudentRecord('4TV25CS154', 'PRISHA THIMMAIAH A',  'G2'),
  StudentRecord('4TV25CS155', 'PRIYA P',             'G2'),
  StudentRecord('4TV25CS156', 'PRIYALAKSHMI M',      'G2'),
  StudentRecord('4TV25CS157', 'PRIYANKA AMARAVATHI', 'G2'),
  StudentRecord('4TV25CS158', 'PRIYANKA M',          'G2'),
  StudentRecord('4TV25CS160', 'PURVI ARADHYA',       'G2'),

  // ── GROUP G3 ────────────────────────────────────────────────────
  StudentRecord('4TV25CS162', 'RAKESH SHREEKANTH M M','G3'),
  StudentRecord('4VV25CS129', 'NAMITHA R REDDY',     'G3'),
  StudentRecord('4VV25CS130', 'NAMRATHA ANANYA K',   'G3'),
  StudentRecord('4VV25CS131', 'NANDAN J M',          'G3'),
  StudentRecord('4VV25CS132', 'NARENDRA S N',        'G3'),
  StudentRecord('4VV25CS133', 'NEHA PRASAD S',       'G3'),
  StudentRecord('4VV25CS134', 'NIHAL URS M K',       'G3'),
  StudentRecord('4VV25CS135', 'NIJAN D',             'G3'),
  StudentRecord('4VV25CS136', 'NIRANJAN SWAMY M',    'G3'),
  StudentRecord('4VV25CS137', 'NIREK JAIN THONIKADAVU','G3'),
  StudentRecord('4VV25CS138', 'NISCHAL S KUMAR',     'G3'),
  StudentRecord('4VV25CS139', 'NITHYASHREE S',       'G3'),
  StudentRecord('4VV25CS140', 'PANCHAMI G',          'G3'),
  StudentRecord('4VV25CS141', 'PAREEKSHITH RAJ S Y', 'G3'),
  StudentRecord('4VV25CS142', 'PATTAN AYOOB KHAN',   'G3'),
  StudentRecord('4VV25CS143', 'PAVAN R',             'G3'),
  StudentRecord('4VV25CS144', 'PAVANI GOWDA S P',    'G3'),
  StudentRecord('4VV25CS145', 'POORVITH S G',        'G3'),
  StudentRecord('4VV25CS146', 'PRAGNA H',            'G3'),
  StudentRecord('4VV25CS147', 'PRAJWAL M',           'G3'),
  StudentRecord('4VV25CS148', 'PRAKRUTHI T S',       'G3'),
];

/// Validates USN + Name against the student list.
/// Returns the [StudentRecord] if found, null otherwise.
/// Comparison is case-insensitive and trims whitespace.
StudentRecord? validateStudent(String usn, String name) {
  final usnClean  = usn.trim().toUpperCase();
  final nameClean = name.trim().toUpperCase();
  try {
    return sectionGStudents.firstWhere(
      (s) => s.usn == usnClean && s.name == nameClean,
    );
  } catch (_) {
    return null;
  }
}
