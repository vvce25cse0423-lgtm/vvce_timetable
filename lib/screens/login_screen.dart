// lib/screens/login_screen.dart
// Login with student credential validation against official Section G list

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/student_data.dart';
import '../utils/app_theme.dart';
import '../utils/prefs_service.dart';
import '../utils/notification_service.dart';
import '../widgets/vvce_logo.dart';
import 'timetable_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _usnCtrl   = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usnCtrl.dispose();
    super.dispose();
  }

  // ── Login handler ─────────────────────────────────────────────────────────
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Small UX delay
    await Future.delayed(const Duration(milliseconds: 500));

    final enteredName = _nameCtrl.text.trim();
    final enteredUSN  = _usnCtrl.text.trim();

    // Validate against the official student list
    final record = validateStudent(enteredUSN, enteredName);

    if (!mounted) return;

    if (record == null) {
      // ── Invalid credentials ──────────────────────────────────────
      setState(() => _isLoading = false);
      _showErrorDialog();
      return;
    }

    // ── Valid — save and navigate ────────────────────────────────
    final prefs = await PrefsService.getInstance();
    await prefs.saveStudent(
      name:    record.name,
      usn:     record.usn,
      section: 'G',
      group:   record.group,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Schedule today's class notifications
    await NotificationService().requestPermission();
    await NotificationService().scheduleNotificationsForToday();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const TimetableScreen(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ── Error dialog for invalid credentials ─────────────────────────────────
  void _showErrorDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Error icon
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline_rounded,
                    color: Colors.red, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Invalid Credentials',
                style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please Try Again\n\nMake sure your Name and USN match exactly as per the official Section G student list.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.55),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Try Again',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1B6E), Color(0xFF1A237E), Color(0xFF283593)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.06),
                _buildHeader(),
                SizedBox(height: size.height * 0.05),
                _buildFormCard(),
                const SizedBox(height: 16),
                Text(
                  'VVCE Mysore • Academic Year 2025-26',
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
                ).animate(delay: 900.ms).fadeIn(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const VvceLogo(size: 90, isDark: true)
            .animate()
            .scale(begin: const Offset(0.5, 0.5), duration: 700.ms, curve: Curves.elasticOut)
            .fadeIn(duration: 500.ms),
        const SizedBox(height: 16),
        const Text('VVCE TimeTable',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 1))
            .animate(delay: 200.ms).slideY(begin: 0.4).fadeIn(duration: 400.ms),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('2nd Semester • CSE • Section G',
              style: TextStyle(color: Color(0xFFFFD54F), fontSize: 12, fontWeight: FontWeight.w500)),
        ).animate(delay: 300.ms).slideY(begin: 0.4).fadeIn(duration: 400.ms),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome! 👋',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue))
                .animate(delay: 400.ms).slideX(begin: -0.3).fadeIn(),
            const SizedBox(height: 4),
            Text('Enter your Name and USN exactly as per the official student list',
                style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.45), height: 1.4))
                .animate(delay: 450.ms).fadeIn(),
            const SizedBox(height: 24),

            // ── Name field ──────────────────────────────────────────
            _buildLabel('Full Name', delay: 500),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
              decoration: _inputDecoration('e.g., NITIN MAHADEV B K', Icons.person_rounded),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your full name';
                if (v.trim().length < 2) return 'Name is too short';
                return null;
              },
            ).animate(delay: 500.ms).slideX(begin: -0.2).fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // ── USN field ───────────────────────────────────────────
            _buildLabel('USN', delay: 600),
            const SizedBox(height: 8),
            TextFormField(
              controller: _usnCtrl,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                LengthLimitingTextInputFormatter(12),
              ],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
              decoration: _inputDecoration('e.g., 4TV25CS131', Icons.badge_rounded),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your USN';
                if (v.trim().length < 8) return 'USN seems too short';
                return null;
              },
            ).animate(delay: 600.ms).slideX(begin: -0.2).fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // ── Section (frozen) ────────────────────────────────────
            _buildLabel('Section', delay: 700),
            const SizedBox(height: 8),
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.group_rounded, color: AppTheme.primaryBlue, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text('G', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.primaryBlue)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Fixed',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.green)),
                  ),
                ],
              ),
            ).animate(delay: 700.ms).slideX(begin: -0.2).fadeIn(duration: 400.ms),

            const SizedBox(height: 10),

            // Info note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Group (G1/G2/G3) is auto-assigned based on your USN',
                      style: TextStyle(fontSize: 11, color: Colors.blue[700], height: 1.4),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 750.ms).fadeIn(),

            const SizedBox(height: 28),

            // ── Login button ────────────────────────────────────────
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: AppTheme.primaryBlue.withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('View My Timetable',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
              ),
            ).animate(delay: 850.ms).slideY(begin: 0.4).fadeIn(),
          ],
        ),
      ),
    ).animate(delay: 350.ms).slideY(begin: 0.3).fadeIn(duration: 500.ms);
  }

  Widget _buildLabel(String text, {required int delay}) {
    return Text(text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue))
        .animate(delay: Duration(milliseconds: delay)).fadeIn();
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
      prefixIcon: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryBlue, size: 18),
      ),
    );
  }
}
