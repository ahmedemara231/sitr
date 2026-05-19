import 'package:flutter/material.dart';
import '../../../../../../config/res/config_imports.dart';

/// Subtle dotted background used behind the contact-us conversation.
/// Mirrors the design's `dot-pattern` (32px grid, 0.8px dots).
class DotPatternBackground extends StatelessWidget {
  const DotPatternBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotPatternPainter(),
      child: child,
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  static const double _spacing = 32;
  static const double _radius = 0.8;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    for (double y = 0; y < size.height; y += _spacing) {
      for (double x = 0; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPatternPainter oldDelegate) => false;
}
