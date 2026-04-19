// lib/screens/splash_screen.dart
// Splash screen with VVCE logo and smooth animations

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_theme.dart';
import '../utils/prefs_service.dart';
import '../widgets/vvce_logo.dart';
import 'login_screen.dart';
import 'timetable_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Navigate after 3 seconds
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;

    final prefs = await PrefsService.getInstance();
    if (!mounted) return;

    final isLoggedIn = prefs.isLoggedIn && prefs.studentName.isNotEmpty;
    final navigator = Navigator.of(context);

    navigator.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            isLoggedIn ? const TimetableScreen() : const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B6E),
              Color(0xFF1A237E),
              Color(0xFF283593),
              Color(0xFF1565C0),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background circles
            ..._buildDecorativeCircles(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with animations
                  const VvceLogo(size: 130, isDark: true)
                      .animate()
                      .scale(
                        begin: const Offset(0.3, 0.3),
                        duration: 800.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 600.ms),

                  const SizedBox(height: 30),

                  // College name
                  const Text(
                    'VVCE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                    ),
                  )
                      .animate(delay: 400.ms)
                      .slideY(begin: 0.5)
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 6),

                  const Text(
                    'Vivekananda Vidyavardhaka\nCollege of Engineering',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 0.5,
                    ),
                  )
                      .animate(delay: 500.ms)
                      .slideY(begin: 0.5)
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 16),

                  // Gold divider
                  Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                      .animate(delay: 600.ms)
                      .scaleX(begin: 0)
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 16),

                  // Semester info
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Text(
                      '2nd Sem • CSE • Section G',
                      style: TextStyle(
                        color: Color(0xFFFFD54F),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                      .animate(delay: 700.ms)
                      .slideY(begin: 0.5)
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 60),

                  // Loading indicator
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      color: AppTheme.accentGold,
                      strokeWidth: 2.5,
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  )
                      .animate(delay: 900.ms)
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 12),

                  Text(
                    'Loading your timetable...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  )
                      .animate(delay: 1000.ms)
                      .fadeIn(duration: 400.ms),
                ],
              ),
            ),

            // Bottom brand
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Mysore, Karnataka',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Built by Nitin Mahadev',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ).animate(delay: 1200.ms).fadeIn(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDecorativeCircles() {
    return [
      // Top-left large circle
      Positioned(
        top: -80,
        left: -80,
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.04),
          ),
        ),
      ),
      // Bottom-right medium circle
      Positioned(
        bottom: -60,
        right: -60,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.accentGold.withOpacity(0.08),
          ),
        ),
      ),
      // Middle-right small circle
      Positioned(
        top: 200,
        right: -30,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
    ];
  }
}
