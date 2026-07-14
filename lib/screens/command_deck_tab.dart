import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/opportunity_provider.dart';
import '../providers/language_provider.dart';
import '../models/opportunity_model.dart';
import '../theme/pad_theme.dart';
import 'crew_review_screen.dart';

/// The venture's command deck: every mission it has launched,
/// with live status and crew-review, close and delete actions.
class CommandDeckTab extends StatelessWidget {
  const CommandDeckTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final opportunities = context.read<OpportunityProvider>();
    final lang = context.watch<LanguageProvider>();
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final uid = auth.user?.uid ?? '';

    return StreamBuilder<List<OpportunityModel>>(
      stream: opportunities.byStartupStream(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final missions = snapshot.data ?? [];
        if (missions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(lang.t('no_posts'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, fontSize: 15)),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: missions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final mission = missions[i];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mission.category.toUpperCase(),
                                  style:
                                      Pad.mono(size: 9, color: Pad.ember)),
                              const SizedBox(height: 3),
                              Text(mission.title,
                                  style: Pad.display(size: 16)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: mission.open
                                ? Pad.signal.withValues(alpha: 0.15)
                                : Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            mission.open
                                ? lang.t('open').toUpperCase()
                                : lang.t('closed').toUpperCase(),
                            style: Pad.mono(
                                size: 9,
                                color:
                                    mission.open ? Pad.signal : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CrewReviewScreen(mission: mission),
                              ),
                            ),
                            icon: const Icon(Icons.group_rounded, size: 16),
                            label: Text(lang.t('view_applicants'),
                                style: const TextStyle(fontSize: 12.5)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (mission.open)
                          OutlinedButton(
                            onPressed: () =>
                                opportunities.closeOpportunity(mission.id),
                            child: Text(lang.t('close_role'),
                                style: const TextStyle(fontSize: 12.5)),
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Pad.clay, size: 20),
                          tooltip: lang.t('delete_role'),
                          onPressed: () =>
                              opportunities.deleteOpportunity(mission.id),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
