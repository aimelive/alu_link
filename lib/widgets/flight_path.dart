import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/pad_theme.dart';

/// Horizontal stepper showing an application's stage along the
/// pipeline: requested -> shortlisted -> interview -> onboard.
/// A rejected application shows the path in clay red up to where
/// it ended.
class FlightPath extends StatelessWidget {
  final String status;

  const FlightPath({super.key, required this.status});

  static const _stages = ['applied', 'shortlisted', 'interview', 'accepted'];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final rejected = status == 'rejected';
    final reached =
        rejected ? 0 : _stages.indexOf(status).clamp(0, _stages.length - 1);
    final activeColor = rejected ? Pad.clay : Pad.statusColor(status);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final idle = isDark ? Pad.nightBorder : const Color(0xFFE3DCCB);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(_stages.length * 2 - 1, (i) {
            if (i.isOdd) {
              final done = (i ~/ 2) < reached;
              return Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: done ? activeColor : idle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }
            final idx = i ~/ 2;
            final done = idx <= reached;
            return Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? activeColor : Colors.transparent,
                border: Border.all(
                    color: done ? activeColor : idle, width: 2),
              ),
              child: done && idx == reached && !rejected
                  ? const Icon(Icons.circle, size: 5, color: Colors.white)
                  : null,
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          rejected
              ? lang.t('rejected').toUpperCase()
              : lang.t(_stages[reached]).toUpperCase(),
          style: Pad.mono(size: 10, color: activeColor),
        ),
      ],
    );
  }
}
