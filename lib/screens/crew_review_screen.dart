import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/application_provider.dart';
import '../providers/language_provider.dart';
import '../models/opportunity_model.dart';
import '../models/application_model.dart';
import '../theme/pad_theme.dart';
import '../widgets/readiness_ring.dart';
import '../widgets/flight_path.dart';

/// Review crew requests for one mission, sorted by readiness,
/// and move each candidate along the pipeline.
class CrewReviewScreen extends StatelessWidget {
  final OpportunityModel mission;

  const CrewReviewScreen({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final applications = context.read<ApplicationProvider>();
    final lang = context.watch<LanguageProvider>();
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CREW REVIEW', style: Pad.mono(size: 9, color: Pad.ember)),
            Text(mission.title, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
      body: StreamBuilder<List<ApplicationModel>>(
        stream: applications.byOpportunityStream(mission.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final apps = snapshot.data ?? [];
          if (apps.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(lang.t('no_applicants'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 15)),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: apps.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final app = apps[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(app.studentName,
                                style: Pad.display(size: 17)),
                          ),
                          ReadinessRing(
                              percent: app.matchScore,
                              size: 46,
                              caption: 'READY'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FlightPath(status: app.status),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _stageButton(applications, app.id, 'shortlisted',
                              lang.t('shortlist'), Pad.sky),
                          _stageButton(applications, app.id, 'interview',
                              lang.t('interview'), Pad.gold),
                          _stageButton(applications, app.id, 'accepted',
                              lang.t('accept'), Pad.signal),
                          _stageButton(applications, app.id, 'rejected',
                              lang.t('reject'), Pad.clay),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _stageButton(ApplicationProvider provider, String appId,
      String status, String label, Color color) {
    return OutlinedButton(
      onPressed: () => provider.updateStatus(appId, status),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        visualDensity: VisualDensity.compact,
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}
