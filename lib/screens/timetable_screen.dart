// lib/screens/timetable_screen.dart
// Main timetable screen with day navigation and subject cards

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui' show FontFeature;
import '../data/timetable_data.dart';
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
  String _studentName = '';
  String _studentUSN = '';
  bool _isDark = false;
  bool _showStats = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Default to today (Mon=0 ... Fri=4), fallback to Monday for weekend
    final weekday = DateTime.now().weekday;
    _selectedDayIndex = (weekday >= 1 && weekday <= 5) ? weekday - 1 : 0;

    _tabController = TabController(
      length: weekDays.length,
      vsync: this,
      initialIndex: _selectedDayIndex,
    );
    _pageController = PageController(initialPage: _selectedDayIndex);

    _loadStudent();
  }

  Future<void> _loadStudent() async {
    final prefs = await PrefsService.getInstance();
    setState(() {
      _studentName = prefs.studentName;
      _studentUSN = prefs.studentUSN;
      _isDark = prefs.isDarkMode;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await PrefsService.getInstance();
    final newVal = !_isDark;
    await prefs.setDarkMode(newVal);
    setState(() => _isDark = newVal);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout?'),
        content: const Text(
            'Your session will be cleared. You can log in again anytime.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final prefs = await PrefsService.getInstance();
      await prefs.logout();
      if (!mounted) return;
      final navigator = Navigator.of(context);
      navigator.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _onDaySelected(int index) {
    setState(() => _selectedDayIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? AppTheme.darkTheme() : AppTheme.lightTheme(),
      child: Builder(builder: (ctx) => _buildScaffold(ctx)),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final isDarkNow = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkNow
        ? AppTheme.backgroundDark
        : AppTheme.backgroundLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Custom App Bar
          _buildAppBar(context, isDarkNow),

          // Stats Toggle Section
          AnimatedCrossFade(
            firstChild: WeeklyStatsWidget(isDark: isDarkNow),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _showStats
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),

          // Day Selector
          DaySelector(
            days: weekDays,
            selectedIndex: _selectedDayIndex,
            onDaySelected: _onDaySelected,
            isDark: isDarkNow,
          ),

          const SizedBox(height: 4),

          // Schedule List
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _selectedDayIndex = i),
              itemCount: weekDays.length,
              itemBuilder: (context, index) {
                return _buildDaySchedule(
                  weekDays[index],
                  isDarkNow,
                  index == _selectedDayIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B6E), Color(0xFF1A237E), Color(0xFF283593)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
                  // Logo
                  const VvceLogo(size: 40, isDark: true),
                  const SizedBox(width: 10),

                  // College Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppConstants.collegeShort,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          '2nd Sem • CSE • Sec G',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats toggle
                  _iconBtn(
                    icon: _showStats
                        ? Icons.bar_chart_rounded
                        : Icons.bar_chart_outlined,
                    tooltip: 'Weekly Stats',
                    onTap: () => setState(() => _showStats = !_showStats),
                    active: _showStats,
                  ),

                  // Dark mode toggle
                  _iconBtn(
                    icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                    onTap: _toggleTheme,
                  ),

                  // Logout
                  _iconBtn(
                    icon: Icons.logout_rounded,
                    tooltip: 'Logout',
                    onTap: _logout,
                    isDestructive: true,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Student info row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          _studentName.isNotEmpty
                              ? _studentName[0].toUpperCase()
                              : 'S',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _studentName.isNotEmpty ? _studentName : 'Student',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _studentUSN.isNotEmpty ? _studentUSN : 'USN',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Current time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 30)),
                          builder: (context, _) {
                            final now = TimeOfDay.now();
                            return Text(
                              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: AppTheme.accentGold,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFeatures: const <FontFeature>[],
                              ),
                            );
                          },
                        ),
                        Text(
                          _getDayLabel(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 10,
                          ),
                        ),
                      ],
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
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool active = false,
    bool isDestructive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: active
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(active ? 0.3 : 0.1),
            ),
          ),
          child: Icon(
            icon,
            color: isDestructive
                ? Colors.redAccent[100]
                : active
                    ? AppTheme.accentGold
                    : Colors.white70,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildDaySchedule(String dayName, bool isDark, bool isActive) {
    final slots = timetableData[dayName] ?? [];
    final isToday = _isTodayName(dayName);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        // Day header
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Text(
                dayName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppTheme.primaryBlue,
                ),
              ),
              if (isToday) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                '${slots.where((s) => s != null).length} classes',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
        ),

        // Slot cards
        ...slots.asMap().entries.map((entry) {
          final index = entry.key;
          final slot = entry.value;
          final timeRange = timeSlots[index];

          if (slot == null) {
            // Lunch is slot index 5
            return BreakCard(
              timeRange: timeRange,
              isLunch: index == 5,
              isDark: isDark,
              animationIndex: index,
            );
          }

          return SubjectCard(
            slot: slot,
            timeRange: timeRange,
            isOngoing: isToday && slot.isOngoing(),
            isDark: isDark,
            animationIndex: index,
          );
        }),
      ],
    );
  }

  bool _isTodayName(String dayName) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final weekday = DateTime.now().weekday;
    if (weekday < 1 || weekday > 5) return false;
    return days[weekday - 1] == dayName;
  }

  String _getDayLabel() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[DateTime.now().weekday - 1];
  }
}
