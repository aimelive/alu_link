import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/application_provider.dart';
import '../providers/language_provider.dart';
import '../models/application_model.dart';
import '../theme/pad_theme.dart';
import '../widgets/flight_path.dart';
import '../widgets/readiness_ring.dart';

/// Real-time tracker of the student's applications, each shown
/// as a flight path through the pipeline stages.
class JourneyTab extends StatelessWidget {
  const JourneyTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final applications = context.read<ApplicationProvider>();
    final lang = context.watch<LanguageProvider>();
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final uid = auth.user?.uid ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('FLIGHT LOG', style: Pad.mono(size: 10, color: Pad.ember)),
              const SizedBox(height: 4),
              Text(lang.t('my_applications'), style: Pad.display(size: 26)),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ApplicationModel>>(
            stream: applications.byStudentStream(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final apps = List.of(snapshot.data ?? <ApplicationModel>[]);
              apps.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

              if (apps.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(lang.t('no_applications'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted, fontSize: 15)),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                                child: Text(app.opportunityTitle,
                                    style: Pad.display(size: 16)),
                              ),
                              const SizedBox(width: 8),
                              ReadinessRing(
                                  percent: app.matchScore, size: 42),
                            ],
                          ),
                          const SizedBox(height: 14),
                          FlightPath(status: app.status),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
