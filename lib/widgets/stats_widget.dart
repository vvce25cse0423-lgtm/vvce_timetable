// lib/widgets/stats_widget.dart
// Stats summary card showing subject counts for the week

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/timetable_data.dart';
import '../models/timetable_model.dart';
import '../utils/app_theme.dart';

class WeeklyStatsWidget extends StatelessWidget {
  final bool isDark;

  const WeeklyStatsWidget({super.key, required this.isDark});

  Map<SubjectType, int> _countSubjects() {
    final Map<SubjectType, int> counts = {};
    for (final slots in timetableData.values) {
      for (final slot in slots) {
        if (slot != null && slot.type != SubjectType.free) {
          counts[slot.type] = (counts[slot.type] ?? 0) + 1;
        }
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final counts = _countSubjects();
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            'Weekly Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: entries.length,
            itemBuilder: (context, i) {
              final type = entries[i].key;
              final count = entries[i].value;
              final color = AppTheme.getSubjectColor(type, isDark);
              final icon = AppTheme.getSubjectIcon(type);

              return Animate(
                effects: [
                  FadeEffect(delay: Duration(milliseconds: i * 70)),
                  ScaleEffect(
                    begin: const Offset(0.8, 0.8),
                    delay: Duration(milliseconds: i * 70),
                  ),
                ],
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: color, size: 22),
                      const SizedBox(height: 4),
                      Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                      Text(
                        _shortName(type),
                        style: TextStyle(
                          fontSize: 9,
                          color: isDark ? Colors.white54 : Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _shortName(SubjectType type) {
    switch (type) {
      case SubjectType.mathematics:
        return 'MATH';
      case SubjectType.chemistry:
        return 'CHEM';
      case SubjectType.programming:
        return 'PLCS';
      case SubjectType.electronics:
        return 'IECK';
      case SubjectType.ai:
        return 'AI';
      case SubjectType.english:
        return 'ENG';
      case SubjectType.lab:
        return 'LAB';
      case SubjectType.physicalEducation:
        return 'PE';
      case SubjectType.free:
        return 'FREE';
    }
  }
}
