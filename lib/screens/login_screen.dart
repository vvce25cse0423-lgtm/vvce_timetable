// lib/screens/login_screen.dart
// Login screen with modern gradient UI and validation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_theme.dart';
import '../utils/prefs_service.dart';
import '../widgets/vvce_logo.dart';
import 'timetable_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usnController = TextEditingController();
  final _sectionController = TextEditingController(text: 'G');

  bool _isLoading = false;
  bool _obscureHint = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usnController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate brief processing
    await Future.delayed(const Duration(milliseconds: 600));

    final prefs = await PrefsService.getInstance();
    await prefs.saveStudent(
      name: _nameController.text,
      usn: _usnController.text,
      section: _sectionController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const TimetableScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

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
            colors: [
              Color(0xFF0D1B6E),
              Color(0xFF1A237E),
              Color(0xFF283593),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.06),

                // Header Section
                _buildHeader(),

                SizedBox(height: size.height * 0.05),

                // Form Card
                _buildFormCard(),

                const SizedBox(height: 20),

                // Footer
                Text(
                  'VVCE Mysore • Academic Year 2024-25',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                ).animate(delay: 800.ms).fadeIn(),

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
            .scale(
              begin: const Offset(0.5, 0.5),
              duration: 700.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 500.ms),

        const SizedBox(height: 16),

        const Text(
          'VVCE TimeTable',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ).animate(delay: 200.ms).slideY(begin: 0.4).fadeIn(duration: 400.ms),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '2nd Semester • CSE • Section G',
            style: TextStyle(
              color: Color(0xFFFFD54F),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            const Text(
              'Welcome! 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryBlue,
              ),
            ).animate(delay: 400.ms).slideX(begin: -0.3).fadeIn(),

            const SizedBox(height: 4),

            Text(
              'Enter your details to view your personalized timetable',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withOpacity(0.45),
              ),
            ).animate(delay: 450.ms).fadeIn(),

            const SizedBox(height: 28),

            // Name Field
            _buildField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'e.g., Arjun Kumar',
              icon: Icons.person_rounded,
              delay: 500,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your name';
                if (v.trim().length < 2) return 'Name is too short';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // USN Field
            _buildField(
              controller: _usnController,
              label: 'USN',
              hint: 'e.g., 4VV23CS001',
              icon: Icons.badge_rounded,
              delay: 600,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your USN';
                if (v.trim().length < 6) return 'USN seems too short';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Section Field
            _buildField(
              controller: _sectionController,
              label: 'Section',
              hint: 'G',
              icon: Icons.group_rounded,
              delay: 700,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                LengthLimitingTextInputFormatter(2),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your section';
                return null;
              },
            ),

            const SizedBox(height: 30),

            // Login Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: AppTheme.primaryBlue.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View My Timetable',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
              ),
            ).animate(delay: 800.ms).slideY(begin: 0.4).fadeIn(),
          ],
        ),
      ),
    ).animate(delay: 350.ms).slideY(begin: 0.3).fadeIn(duration: 500.ms);
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required int delay,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.words,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
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
          ),
        ),
      ],
    ).animate(delay: Duration(milliseconds: delay)).slideX(begin: -0.2).fadeIn(duration: 400.ms);
  }
}
