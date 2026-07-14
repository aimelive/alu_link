import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/application_provider.dart';
import '../providers/language_provider.dart';
import '../models/opportunity_model.dart';
import '../models/application_model.dart';
import '../theme/pad_theme.dart';
import '../widgets/readiness_ring.dart';

/// Full mission brief with the student's readiness and the
/// "request to join" action. Skills the student already has
/// are highlighted in the requirements list.
class MissionDetailScreen extends StatefulWidget {
  final OpportunityModel mission;
  final int readiness;

  const MissionDetailScreen({
    super.key,
    required this.mission,
    required this.readiness,
  });

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen> {
  bool _applying = false;

  Future<void> _apply() async {
    setState(() => _applying = true);

    final auth = context.read<AuthProvider>();
    final applications = context.read<ApplicationProvider>();
    final lang = context.read<LanguageProvider>();
    final user = auth.user!;

    final application = ApplicationModel(
      id: '',
      opportunityId: widget.mission.id,
      opportunityTitle: widget.mission.title,
      studentId: user.uid,
      studentName: user.name,
      matchScore: widget.readiness,
      appliedAt: DateTime.now(),
    );

    await applications.apply(application);

    if (mounted) {
      setState(() => _applying = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.t('application_sent'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mission = widget.mission;
    final lang = context.watch<LanguageProvider>();
    final auth = context.watch<AuthProvider>();
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final mySkills =
        (auth.user?.skills ?? []).map((s) => s.trim().toLowerCase()).toSet();

    return Scaffold(
      appBar: AppBar(title: Text(lang.t('mission_brief'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mission.category.toUpperCase(),
                style: Pad.mono(size: 11, color: Pad.ember)),
            const SizedBox(height: 6),
            Text(mission.title, style: Pad.display(size: 26)),
            const SizedBox(height: 6),
            Text(mission.startupName,
                style: TextStyle(fontSize: 15, color: muted)),
            const SizedBox(height: 20),
            // Readiness panel
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ReadinessRing(percent: widget.readiness, size: 70),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lang.t('your_readiness'),
                              style: Pad.display(size: 15)),
                          const SizedBox(height: 4),
                          Text(lang.t('readiness_hint'),
                              style:
                                  TextStyle(fontSize: 12.5, color: muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(lang.t('about_role'), style: Pad.display(size: 16)),
            const SizedBox(height: 8),
            Text(mission.description,
                style: const TextStyle(fontSize: 14.5, height: 1.55)),
            const SizedBox(height: 24),
            Text(lang.t('required_skills'), style: Pad.display(size: 16)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: mission.requiredSkills.map((s) {
                final has = mySkills.contains(s.trim().toLowerCase());
                return Chip(
                  avatar: has
                      ? const Icon(Icons.check_circle,
                          size: 16, color: Pad.signal)
                      : null,
                  label: Text(s),
                  backgroundColor: has
                      ? Pad.signal.withValues(alpha: 0.14)
                      : Theme.of(context).chipTheme.backgroundColor,
                );
              }).toList(),
            ),
            const SizedBox(height: 36),
            ElevatedButton.icon(
              onPressed: _applying ? null : _apply,
              icon: _applying
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.rocket_launch_rounded, size: 20),
              label: Text(lang.t('apply_now')),
            ),
          ],
        ),
      ),
    );
  }
}
