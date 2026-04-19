// lib/screens/timetable_screen.dart
// Main timetable screen — group-aware, live class indicator, auto today tab

import 'dart:async';
import '../utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/timetable_data.dart';
import '../models/timetable_model.dart';
import '../utils/app_theme.dart';
import '../utils/prefs_service.dart';
import '../widgets/day_selector.dart';
import '../widgets/subject_card.dart';
import '../widgets/stats_widget.dart';
import '../widgets/vvce_logo.dart';
import 'login_screen.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with TickerProviderStateMixin {
  late int _selectedDayIndex;
  late TabController _tabController;
  late PageController _pageController;

  String _studentName = '';
  String _studentUSN = '';
  String _studentGroup = 'G1'; // G1, G2 or G3
  bool _isDark = false;
  bool _showStats = false;

  // Timer to refresh "ongoing" highlight every minute
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    // Auto-open today's tab (Mon=0..Fri=4), weekend defaults to Monday
    final weekday = DateTime.now().weekday;
    _selectedDayIndex = (weekday >= 1 && weekday <= 5) ? weekday - 1 : 0;

    _tabController = TabController(
      length: weekDays.length,
      vsync: this,
      initialIndex: _selectedDayIndex,
    );
    _pageController = PageController(initialPage: _selectedDayIndex);

    _loadStudent();

    // Refresh every 60 seconds so the live indicator updates
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _loadStudent() async {
    final prefs = await PrefsService.getInstance();
    if (!mounted) return;
    setState(() {
      _studentName   = prefs.studentName;
      _studentUSN    = prefs.studentUSN;
      _studentGroup  = prefs.studentGroup;
      _isDark        = prefs.isDarkMode;
    });
    // Schedule today's notifications for returning users
    await NotificationService().scheduleNotificationsForToday();
  }

  Future<void> _toggleTheme() async {
    final prefs = await PrefsService.getInstance();
    await prefs.setDarkMode(!_isDark);
    if (mounted) setState(() => _isDark = !_isDark);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout?'),
        content: const Text('Your session will be cleared. You can log in again anytime.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      final prefs = await PrefsService.getInstance();
      await prefs.logout();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ));
    }
  }

  void _onDaySelected(int index) {
    setState(() => _selectedDayIndex = index);
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? AppTheme.darkTheme() : AppTheme.lightTheme(),
      child: Builder(builder: _buildScaffold),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          _buildAppBar(context, isDark),
          AnimatedCrossFade(
            firstChild: WeeklyStatsWidget(isDark: isDark),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _showStats ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
          DaySelector(
            days: weekDays,
            selectedIndex: _selectedDayIndex,
            onDaySelected: _onDaySelected,
            isDark: isDark,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _selectedDayIndex = i),
              itemCount: weekDays.length,
              itemBuilder: (_, index) =>
                  _buildDaySchedule(weekDays[index], isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B6E), Color(0xFF1A237E), Color(0xFF283593)],
        ),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const VvceLogo(size: 40, isDark: true),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('VVCE Mysore',
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                        Text('2nd Sem • CSE • Sec G',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
                      ],
                    ),
                  ),
                  _iconBtn(
                    icon: _showStats ? Icons.bar_chart_rounded : Icons.bar_chart_outlined,
                    tooltip: 'Weekly Stats', active: _showStats,
                    onTap: () => setState(() => _showStats = !_showStats),
                  ),
                  _iconBtn(
                    icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                    onTap: _toggleTheme,
                  ),
                  _iconBtn(
                    icon: Icons.logout_rounded, tooltip: 'Logout',
                    onTap: _logout, isDestructive: true,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                          color: AppTheme.accentGold,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          _studentName.isNotEmpty ? _studentName[0].toUpperCase() : 'S',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_studentName.isNotEmpty ? _studentName : 'Student',
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                          Text(_studentUSN.isNotEmpty ? _studentUSN : 'USN',
                              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
                        ],
                      ),
                    ),
                    // Group badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.accentGold.withOpacity(0.5)),
                      ),
                      child: Text(
                        _studentGroup,
                        style: const TextStyle(
                            color: AppTheme.accentGold, fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Live clock
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 30)),
                      builder: (_, __) {
                        final now = TimeOfDay.now();
                        final h = now.hour.toString().padLeft(2, '0');
                        final m = now.minute.toString().padLeft(2, '0');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('$h:$m',
                                style: const TextStyle(
                                    color: AppTheme.accentGold, fontSize: 16, fontWeight: FontWeight.w800)),
                            Text(_getDayLabel(),
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ).animate().slideY(begin: 0.3).fadeIn(duration: 400.ms, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon, required String tooltip,
    required VoidCallback onTap, bool active = false, bool isDestructive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: active ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(active ? 0.3 : 0.1)),
          ),
          child: Icon(icon,
            color: isDestructive ? Colors.redAccent[100] : active ? AppTheme.accentGold : Colors.white70,
            size: 18),
        ),
      ),
    );
  }

  Widget _buildDaySchedule(String dayName, bool isDark) {
    final entries = daySchedules[dayName] ?? [];
    final isToday = _isTodayName(dayName);
    final classCount = entries.whereType<ClassSlot>().length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        // Day header
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Text(dayName,
                style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppTheme.primaryBlue,
                )),
              if (isToday) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                  child: const Text('Today',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
              const Spacer(),
              Text('$classCount classes',
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38)),
            ],
          ),
        ),

        // Entries
        ...entries.asMap().entries.map((mapEntry) {
          final index = mapEntry.key;
          final entry = mapEntry.value;

          if (entry is BreakEntry) {
            return BreakCard(
              timeRange: entry.timeRange,
              isLunch: entry.isLunch,
              isTeaBreak: entry.isTeaBreak,
              isDark: isDark,
              animationIndex: index,
            );
          }

          if (entry is ClassSlot) {
            // Resolve faculty & room based on student's group
            final resolvedFaculty = entry.facultyForGroup(_studentGroup);
            final resolvedRoom    = entry.roomForGroup(_studentGroup);

            // Build a resolved copy to pass to the card
            final resolved = ClassSlot(
              subjectCode: entry.subjectCode,
              subjectName: entry.subjectName,
              faculty: resolvedFaculty,
              room: resolvedRoom,
              startTime: entry.startTime,
              endTime: entry.endTime,
              type: entry.type,
            );

            final timeRange = '${entry.startTime} - ${entry.endTime}';
            final ongoing = isToday && entry.isOngoing();

            return SubjectCard(
              slot: resolved,
              timeRange: timeRange,
              isOngoing: ongoing,
              isDark: isDark,
              animationIndex: index,
            );
          }

          return const SizedBox.shrink();
        }),
      ],
    );
  }

  bool _isTodayName(String dayName) {
    const days = ['Monday','Tuesday','Wednesday','Thursday','Friday'];
    final weekday = DateTime.now().weekday;
    if (weekday < 1 || weekday > 5) return false;
    return days[weekday - 1] == dayName;
  }

  String _getDayLabel() {
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return days[DateTime.now().weekday - 1];
  }
}
