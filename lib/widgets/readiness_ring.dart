import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/pad_theme.dart';

/// Circular skill-readiness gauge — the app's signature element.
/// Shows how much of a mission's required skills a student covers.
class ReadinessRing extends StatelessWidget {
  final int percent; // 0-100
  final double size;
  final String? caption;

  const ReadinessRing({
    super.key,
    required this.percent,
    this.size = 52,
    this.caption,
  });

  Color get _color {
    if (percent >= 70) return Pad.signal;
    if (percent >= 40) return Pad.ember;
    return const Color(0xFF8B9490);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingPainter(
              progress: percent / 100,
              color: _color,
              track: isDark ? Pad.nightBorder : const Color(0xFFEAE4D5),
            ),
            child: Center(
              child: Text(
                '$percent%',
                style: Pad.display(
                    size: size * 0.26,
                    weight: FontWeight.w700,
                    color: _color),
              ),
            ),
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: 4),
          Text(caption!,
              style: Pad.mono(
                  size: 9,
                  color: Theme.of(context).textTheme.bodySmall?.color)),
        ],
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color track;

  _RingPainter(
      {required this.progress, required this.color, required this.track});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 3;
    final stroke = size.width * 0.10;

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress.clamp(0.0, 1.0),
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
