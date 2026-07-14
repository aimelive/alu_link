import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/opportunity_provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../models/opportunity_model.dart';
import '../utils/match_calculator.dart';
import '../utils/departments.dart';
import '../theme/pad_theme.dart';
import '../widgets/mission_card.dart';
import 'mission_detail_screen.dart';

/// The mission board: live feed of open missions with search,
/// department filters and per-mission readiness rings.
class MissionBoardTab extends StatefulWidget {
  const MissionBoardTab({super.key});

  @override
  State<MissionBoardTab> createState() => _MissionBoardTabState();
}

class _MissionBoardTabState extends State<MissionBoardTab> {
  final _searchController = TextEditingController();
  String _query = '';
  String _category = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesFilters(OpportunityModel opp) {
    if (_category != 'All' && opp.category != _category) return false;
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return opp.title.toLowerCase().contains(q) ||
        opp.startupName.toLowerCase().contains(q) ||
        opp.category.toLowerCase().contains(q) ||
        opp.requiredSkills.any((s) => s.toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final opportunities = context.read<OpportunityProvider>();
    final lang = context.watch<LanguageProvider>();
    final mySkills = auth.user?.skills ?? [];
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    final categories = ['All', ...Departments.all];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MISSION BOARD',
                        style: Pad.mono(size: 10, color: Pad.ember)),
                    const SizedBox(height: 4),
                    Text(lang.t('missions_hero'), style: Pad.display(size: 26)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => lang.toggle(),
                child: Text(lang.isFrench ? 'EN' : 'FR',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
              IconButton(
                icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => theme.toggle(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v.trim()),
            decoration: InputDecoration(
              hintText: lang.t('search_hint'),
              prefixIcon: const Icon(Icons.search),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Department filter rail
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final c = categories[i];
              final selected = _category == c;
              return ChoiceChip(
                label: Text(c == 'All' ? lang.t('all') : c),
                selected: selected,
                showCheckmark: false,
                selectedColor: Pad.runway,
                labelStyle: TextStyle(
                  color: selected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                onSelected: (_) => setState(() => _category = c),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Live mission feed
        Expanded(
          child: StreamBuilder<List<OpportunityModel>>(
            stream: opportunities.openOpportunitiesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final all = snapshot.data ?? [];
              final missions = all.where(_matchesFilters).toList()
                ..sort((a, b) =>
                    MatchCalculator.score(mySkills, b.requiredSkills).compareTo(
                        MatchCalculator.score(mySkills, a.requiredSkills)));

              if (missions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(lang.t('no_results'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted, fontSize: 15)),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: missions.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Text(
                      '${missions.length} ${lang.t('open_missions')}'
                          .toUpperCase(),
                      style: Pad.mono(size: 10, color: muted),
                    );
                  }
                  final mission = missions[i - 1];
                  final readiness =
                      MatchCalculator.score(mySkills, mission.requiredSkills);
                  return MissionCard(
                    mission: mission,
                    readiness: readiness,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MissionDetailScreen(
                            mission: mission, readiness: readiness),
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
