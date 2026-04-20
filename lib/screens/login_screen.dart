// lib/screens/login_screen.dart
// Login — bulletproof validation + navigation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/student_data.dart';
import '../utils/app_theme.dart';
import '../utils/prefs_service.dart';
import '../utils/notification_service.dart';
import 'timetable_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _usnCtrl  = TextEditingController();
  bool _isLoading = false;

  // Fictional example hints — NOT real students
  static const _nameHints = [
    'e.g., ARJUN KUMAR S',
    'e.g., DIVYA SHARMA R',
    'e.g., RAHUL VERMA K',
    'e.g., SNEHA PATIL M',
    'e.g., KIRAN RAJ B',
    'e.g., MEENA LAKSHMI T',
    'e.g., SURESH BABU N',
  ];
  static const _usnHints = [
    'e.g., 4XX25CS001',
    'e.g., 4YY25CS002',
    'e.g., 4ZZ25CS003',
    'e.g., 4AB25CS004',
    'e.g., 4CD25CS005',
    'e.g., 4EF25CS006',
    'e.g., 4GH25CS007',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usnCtrl.dispose();
    super.dispose();
  }

  // ── Safely update loading state ──────────────────────────────────────────
  void _setLoading(bool v) {
    if (mounted) setState(() => _isLoading = v);
  }

  // ── Login ────────────────────────────────────────────────────────────────
  Future<void> _login() async {
    // 1. Dismiss keyboard
    FocusScope.of(context).unfocus();

    // 2. Validate form fields
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // 3. Prevent double-tap
    if (_isLoading) return;
    _setLoading(true);

    try {
      // 4. Normalize inputs
      final name = _nameCtrl.text.trim().toUpperCase();
      final usn  = _usnCtrl.text.trim().toUpperCase();

      // 5. Small UX delay
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) { _setLoading(false); return; }

      // 6. Validate credentials
      final record = validateStudent(usn, name);
      if (record == null) {
        _setLoading(false);
        _showErrorDialog();
        return;
      }

      // 7. Device-lock check (non-blocking — never prevents login)
      try {
        final prefs = await PrefsService.getInstance();
        final alreadyLoggedIn = prefs.isLoggedIn &&
            prefs.studentName.isNotEmpty &&
            prefs.studentUSN != usn;
        if (alreadyLoggedIn) {
          final same = await prefs.isCurrentDevice();
          if (!same && mounted) {
            _setLoading(false);
            _showAlreadyLoggedInDialog();
            return;
          }
        }
        // 8. Save student data
        await prefs.saveStudent(
          name: record.name, usn: record.usn,
          section: 'G', group: record.group,
        );
      } catch (e) {
        debugPrint('Device/save error (ignored): $e');
        // Even if device check fails — still save and continue
        try {
          final prefs = await PrefsService.getInstance();
          await prefs.saveStudent(
            name: record.name, usn: record.usn,
            section: 'G', group: record.group,
          );
        } catch (_) {}
      }

      if (!mounted) { _setLoading(false); return; }

      // 9. Schedule notifications (fire-and-forget, never blocks)
      NotificationService().requestPermission().then((_) =>
        NotificationService().scheduleNotificationsForToday()
      ).catchError((_) {});

      if (!mounted) { _setLoading(false); return; }

      // 10. GUARANTEED navigation — reset loading first, then navigate
      _setLoading(false);

      await Future.microtask(() {}); // flush setState
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const TimetableScreen(),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 450),
        ),
      );
    } catch (e, stack) {
      debugPrint('Login error: $e\n$stack');
      _setLoading(false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // ── Already logged in on another device ──────────────────────────────────
  void _showAlreadyLoggedInDialog() {
    if (!mounted) return;
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                      color: Colors.black87)),
              const SizedBox(height: 10),
              Text(
                'Your account is already active on another device.\n\n'
                'Log out from that device first, then try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13,
                    color: Colors.black.withOpacity(0.55), height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Understood',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Invalid credentials ───────────────────────────────────────────────────
  void _showErrorDialog() {
    if (!mounted) return;
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
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.error_outline_rounded,
                    color: Colors.red, size: 36),
              ),
              const SizedBox(height: 16),
              const Text('Invalid Credentials',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                      color: Colors.black87)),
              const SizedBox(height: 10),
              Text(
                'Name and USN do not match our records.\n\n'
                '• Enter name in CAPITAL LETTERS\n'
                '• Check USN spelling carefully\n'
                '• Use your official college name',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13,
                    color: Colors.black.withOpacity(0.55), height: 1.6),
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
    final nameHint = _nameHints[DateTime.now().second % _nameHints.length];
    final usnHint  = _usnHints[DateTime.now().second % _usnHints.length];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF0D1B6E), Color(0xFF1A237E), Color(0xFF283593)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05),
                _buildHeader(),
                SizedBox(height: size.height * 0.04),
                _buildFormCard(nameHint, usnHint),
                const SizedBox(height: 16),
                Text('VVCE Mysore • Academic Year 2025-26',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 11))
                    .animate(delay: 900.ms).fadeIn(),
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
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            color: Colors.white, shape: BoxShape.circle,
            boxShadow: [BoxShadow(
                color: const Color(0xFFFFB300).withOpacity(0.4),
                blurRadius: 20, spreadRadius: 2)],
          ),
          padding: const EdgeInsets.all(6),
          child: ClipOval(
            child: Image.asset('assets/images/vvce_logo.png',
                fit: BoxFit.contain),
          ),
        ).animate()
            .scale(begin: const Offset(0.5, 0.5), duration: 700.ms,
                curve: Curves.elasticOut)
            .fadeIn(duration: 500.ms),
        const SizedBox(height: 16),
        const Text('VVCE TimeTable',
            style: TextStyle(color: Colors.white, fontSize: 28,
                fontWeight: FontWeight.w800, letterSpacing: 1))
            .animate(delay: 200.ms).slideY(begin: 0.4).fadeIn(duration: 400.ms),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('2nd Semester • CSE • Section G',
              style: TextStyle(color: Color(0xFFFFD54F), fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ).animate(delay: 300.ms).slideY(begin: 0.4).fadeIn(duration: 400.ms),
      ],
    );
  }

  Widget _buildFormCard(String nameHint, String usnHint) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome! 👋',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800,
                    color: AppTheme.primaryBlue))
                .animate(delay: 400.ms).slideX(begin: -0.3).fadeIn(),
            const SizedBox(height: 4),
            Text('Enter your Name and USN exactly as per the official list',
                style: TextStyle(fontSize: 12,
                    color: Colors.black.withOpacity(0.45), height: 1.4))
                .animate(delay: 450.ms).fadeIn(),
            const SizedBox(height: 22),

            // Full Name
            _label('Full Name'),
            const SizedBox(height: 6),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.4)),
              ),
              child: Row(children: [
                const Icon(Icons.keyboard_capslock_rounded,
                    size: 14, color: Colors.amber),
                const SizedBox(width: 6),
                Text('Enter name in CAPITAL LETTERS only',
                    style: TextStyle(fontSize: 11,
                        color: Colors.amber[800], fontWeight: FontWeight.w600)),
              ]),
            ),
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500,
                  color: Colors.black87),
              decoration: _decor(nameHint, Icons.person_rounded),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your full name' : null,
            ).animate(delay: 500.ms).slideX(begin: -0.2).fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // USN
            _label('USN'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _usnCtrl,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _login(), // allow Enter key to submit
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                LengthLimitingTextInputFormatter(12),
              ],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500,
                  color: Colors.black87),
              decoration: _decor(usnHint, Icons.badge_rounded),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your USN' : null,
            ).animate(delay: 600.ms).slideX(begin: -0.2).fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Section frozen
            _label('Section'),
            const SizedBox(height: 6),
            Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.25)),
              ),
              child: Row(children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.group_rounded,
                      color: AppTheme.primaryBlue, size: 18),
                ),
                const SizedBox(width: 12),
                const Text('G', style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w700, color: AppTheme.primaryBlue)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Fixed', style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.w600, color: Colors.green)),
                ),
              ]),
            ).animate(delay: 700.ms).slideX(begin: -0.2).fadeIn(duration: 400.ms),

            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded, color: Colors.blue, size: 15),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  'Group (G1/G2/G3) is auto-assigned from your USN',
                  style: TextStyle(fontSize: 11, color: Colors.blue[700], height: 1.4),
                )),
              ]),
            ).animate(delay: 750.ms).fadeIn(),

            const SizedBox(height: 26),

            // ── Login Button ────────────────────────────────────────
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppTheme.primaryBlue.withOpacity(0.6),
                  elevation: 4,
                  shadowColor: AppTheme.primaryBlue.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isLoading
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Row(
                          key: ValueKey('text'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('View My Timetable',
                                style: TextStyle(fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                ),
              ),
            ).animate(delay: 850.ms).slideY(begin: 0.4).fadeIn(),
          ],
        ),
      ),
    ).animate(delay: 350.ms).slideY(begin: 0.3).fadeIn(duration: 500.ms);
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue)),
      );

  InputDecoration _decor(String hint, IconData icon) => InputDecoration(
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
