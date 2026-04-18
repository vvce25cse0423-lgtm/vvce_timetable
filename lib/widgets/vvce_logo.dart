// lib/widgets/vvce_logo.dart
// VVCE Logo widget - draws the college logo using Flutter canvas

import 'package:flutter/material.dart';

/// Renders the VVCE college emblem programmatically
class VvceLogo extends StatelessWidget {
  final double size;
  final bool isDark;

  const VvceLogo({super.key, this.size = 100, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _VvceLogoPainter(isDark: isDark),
      ),
    );
  }
}

class _VvceLogoPainter extends CustomPainter {
  final bool isDark;
  _VvceLogoPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer circle - gold ring
    final ringPaint = Paint()
      ..color = const Color(0xFFFFB300)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06;
    canvas.drawCircle(center, radius * 0.92, ringPaint);

    // Inner circle - filled
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF1A237E) : const Color(0xFF1A237E)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.82, bgPaint);

    // Inner gold circle border
    final innerRingPaint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;
    canvas.drawCircle(center, radius * 0.72, innerRingPaint);

    // Draw "VVCE" text in the center using a TextPainter
    _drawText(
      canvas,
      'VVCE',
      center.translate(0, -size.height * 0.08),
      size.width * 0.22,
      Colors.white,
      FontWeight.w900,
    );

    _drawText(
      canvas,
      'MYSORE',
      center.translate(0, size.height * 0.14),
      size.width * 0.09,
      const Color(0xFFFFD54F),
      FontWeight.w600,
    );

    // Decorative torch flame shape at top
    final torchPaint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..style = PaintingStyle.fill;

    final torchPath = Path();
    final torchTop = Offset(center.dx, center.dy - radius * 0.55);
    torchPath.moveTo(torchTop.dx, torchTop.dy - radius * 0.25);
    torchPath.quadraticBezierTo(
      torchTop.dx + radius * 0.15,
      torchTop.dy - radius * 0.05,
      torchTop.dx,
      torchTop.dy,
    );
    torchPath.quadraticBezierTo(
      torchTop.dx - radius * 0.15,
      torchTop.dy - radius * 0.05,
      torchTop.dx,
      torchTop.dy - radius * 0.25,
    );
    canvas.drawPath(torchPath, torchPaint);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset center,
    double fontSize,
    Color color,
    FontWeight weight,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: weight,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_VvceLogoPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
