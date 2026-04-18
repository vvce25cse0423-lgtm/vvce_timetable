// lib/widgets/subject_card.dart
// Reusable card widget for displaying a single class/subject slot

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/timetable_model.dart';
import '../utils/app_theme.dart';

class SubjectCard extends StatelessWidget {
  final ClassSlot slot;
  final String timeRange;
  final bool isOngoing;
  final bool isDark;
  final int animationIndex;

  const SubjectCard({
    super.key,
    required this.slot,
    required this.timeRange,
    required this.isOngoing,
    required this.isDark,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getSubjectColor(slot.type, isDark);
    final icon = AppTheme.getSubjectIcon(slot.type);

    return Animate(
      effects: [
        FadeEffect(delay: Duration(milliseconds: animationIndex * 60)),
        SlideEffect(
          begin: const Offset(0.3, 0),
          delay: Duration(milliseconds: animationIndex * 60),
        ),
      ],
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isOngoing ? 0.4 : 0.15),
              blurRadius: isOngoing ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? color.withOpacity(0.12)
                      : color.withOpacity(0.08),
                  border: Border(
                    left: BorderSide(color: color, width: 4),
                  ),
                ),
                child: Row(
                  children: [
                    // Subject Icon Circle
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(width: 12),

                    // Subject Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Subject Code Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  slot.subjectCode,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isOngoing)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                          .animate(
                                            onPlay: (c) => c.repeat(),
                                          )
                                          .fadeOut(
                                            duration: 800.ms,
                                          )
                                          .then()
                                          .fadeIn(duration: 800.ms),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'NOW',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            slot.subjectName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 11,
                                color: isDark ? Colors.white60 : Colors.black45,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  slot.faculty,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.black45,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Right side: time + room
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 11,
                              color: color,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              timeRange.split(' - ')[0],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          timeRange.split(' - ')[1],
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white54 : Colors.black38,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_rounded,
                                  size: 10, color: color),
                              const SizedBox(width: 2),
                              Text(
                                slot.room,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Ongoing glow border
              if (isOngoing)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Break / Free period card
class BreakCard extends StatelessWidget {
  final String timeRange;
  final bool isLunch;
  final bool isDark;
  final int animationIndex;

  const BreakCard({
    super.key,
    required this.timeRange,
    required this.isLunch,
    required this.isDark,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(delay: Duration(milliseconds: animationIndex * 60)),
      ],
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isLunch ? Icons.lunch_dining_rounded : Icons.free_breakfast_rounded,
              color: isDark ? Colors.white38 : Colors.black38,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              isLunch ? 'Lunch Break' : 'Free Period',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white38 : Colors.black38,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(),
            Text(
              timeRange,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
