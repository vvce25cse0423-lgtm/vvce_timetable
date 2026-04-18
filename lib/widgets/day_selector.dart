// lib/widgets/day_selector.dart
// Horizontal day tab selector widget

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DaySelector extends StatelessWidget {
  final List<String> days;
  final int selectedIndex;
  final Function(int) onDaySelected;
  final bool isDark;

  const DaySelector({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final isToday = _isTodayIndex(index);

          return Animate(
            effects: [
              FadeEffect(delay: Duration(milliseconds: index * 80)),
              SlideEffect(
                begin: const Offset(0, -0.3),
                delay: Duration(milliseconds: index * 80),
              ),
            ],
            child: GestureDetector(
              onTap: () => onDaySelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary
                      : isDark
                          ? Colors.white.withOpacity(0.06)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primary.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ],
                  border: isToday && !isSelected
                      ? Border.all(
                          color: primary.withOpacity(0.5),
                          width: 1.5,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isToday)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      days[index].substring(0, 3),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : isDark
                                ? Colors.white70
                                : Colors.black54,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isTodayIndex(int index) {
    final weekday = DateTime.now().weekday; // 1=Mon, 5=Fri
    return weekday >= 1 && weekday <= 5 && weekday - 1 == index;
  }
}
