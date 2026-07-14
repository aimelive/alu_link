import 'package:flutter/material.dart';
import '../models/opportunity_model.dart';
import '../theme/pad_theme.dart';
import 'readiness_ring.dart';

/// A mission on the board: venture monogram, brief, skill tags,
/// and the student's readiness ring on the right.
class MissionCard extends StatelessWidget {
  final OpportunityModel mission;
  final int readiness;
  final VoidCallback onTap;

  const MissionCard({
    super.key,
    required this.mission,
    required this.readiness,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Pad.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Venture monogram tile
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Pad.runway,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  mission.startupName.isNotEmpty
                      ? mission.startupName[0].toUpperCase()
                      : '?',
                  style: Pad.display(size: 20, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mission.category.toUpperCase(),
                        style: Pad.mono(size: 10, color: Pad.ember)),
                    const SizedBox(height: 3),
                    Text(mission.title,
                        style: Pad.display(size: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(mission.startupName,
                        style: TextStyle(fontSize: 13, color: muted)),
                    if (mission.requiredSkills.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: mission.requiredSkills
                            .take(3)
                            .map((s) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: muted?.withValues(alpha: 0.3) ??
                                            Colors.grey),
                                  ),
                                  child: Text(s,
                                      style: TextStyle(
                                          fontSize: 11, color: muted)),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ReadinessRing(percent: readiness, caption: 'READY'),
            ],
          ),
        ),
      ),
    );
  }
}
