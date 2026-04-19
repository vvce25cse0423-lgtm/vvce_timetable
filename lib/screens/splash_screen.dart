// lib/screens/splash_screen.dart
// Splash screen — real VVCE logo, device-lock check, smooth animations

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_theme.dart';
import '../utils/prefs_service.dart';
import 'login_screen.dart';
import 'timetable_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;

    final prefs = await PrefsService.getInstance();

    if (prefs.isLoggedIn && prefs.studentName.isNotEmpty) {
      // Check if this is the same device that logged in
      final sameDevice = await prefs.isCurrentDevice();
      if (!mounted) return;

      if (!sameDevice) {
        // Different device — show blocked screen then stay on login
        _showDeviceBlockedDialog();
        return;
      }

      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const TimetableScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ));
    } else {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ));
    }
  }

  void _showDeviceBlockedDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70, height: 70,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.devices_other_rounded,
                    color: Colors.orange, size: 38),
              ),
              const SizedBox(height: 16),
              const Text('Already Logged In',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Text(
                'Your account is already logged in on another device.\n\n'
                'Please log out from that device first to continue here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.55),
                    height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoginScreen(),
                      transitionsBuilder: (_, a, __, child) =>
                          FadeTransition(opacity: a, child: child),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('OK', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            _circle(top: -80, left: -80, size: 250, opacity: 0.04),
            _circle(bottom: -60, right: -60, size: 200, opacity: 0.08,
                color: AppTheme.accentGold),
            _circle(top: 200, right: -30, size: 100, opacity: 0.05),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Real VVCE Logo from assets
                  Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentGold.withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/vvce_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.3, 0.3),
                        duration: 800.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 600.ms),

                  const SizedBox(height: 28),

                  const Text('VVCE',
                      style: TextStyle(
                        color: Colors.white, fontSize: 42,
                        fontWeight: FontWeight.w900, letterSpacing: 6,
                      ))
                      .animate(delay: 400.ms)
                      .slideY(begin: 0.5)
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 6),

                  const Text(
                    'Vidya Vardhaka College\nof Engineering',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70, fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.5, letterSpacing: 0.5,
                    ),
                  )
                      .animate(delay: 500.ms)
                      .slideY(begin: 0.5)
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 16),

                  // Gold divider
                  Container(
                    width: 60, height: 3,
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ).animate(delay: 600.ms).scaleX(begin: 0).fadeIn(duration: 400.ms),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Text(
                      '2nd Sem • CSE • Section G',
                      style: TextStyle(
                        color: Color(0xFFFFD54F), fontSize: 13,
                        fontWeight: FontWeight.w600, letterSpacing: 0.5,
                      ),
                    ),
                  ).animate(delay: 700.ms).slideY(begin: 0.5).fadeIn(duration: 500.ms),

                  const SizedBox(height: 50),

                  SizedBox(
                    width: 36, height: 36,
                    child: CircularProgressIndicator(
                      color: AppTheme.accentGold,
                      strokeWidth: 2.5,
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  ).animate(delay: 900.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: 12),

                  Text('Loading your timetable...',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 12))
                      .animate(delay: 1000.ms)
                      .fadeIn(duration: 400.ms),
                ],
              ),
            ),

            // Bottom: location + built by
            Positioned(
              bottom: 36, left: 0, right: 0,
              child: Column(
                children: [
                  Text('Mysore, Karnataka',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 6),
                  Text('Built by Nitin Mahadev',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('v1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 10, letterSpacing: 1.5,
                          fontWeight: FontWeight.w500)),
                ],
              ).animate(delay: 1200.ms).fadeIn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle({
    double? top, double? bottom, double? left, double? right,
    required double size, required double opacity,
    Color color = Colors.white,
  }) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(opacity),
        ),
      ),
    );
  }
}
