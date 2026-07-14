import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'mission_board_tab.dart';
import 'journey_tab.dart';
import 'crew_card_tab.dart';

/// Student shell: Missions board, Journey tracker, Crew card.
class ExplorerShell extends StatefulWidget {
  const ExplorerShell({super.key});

  @override
  State<ExplorerShell> createState() => _ExplorerShellState();
}

class _ExplorerShellState extends State<ExplorerShell> {
  int _index = 0;

  final List<Widget> _tabs = [
    const MissionBoardTab(),
    const JourneyTab(),
    const CrewCardTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      body: SafeArea(child: _tabs[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view_rounded),
            label: lang.t('missions'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.route_outlined),
            selectedIcon: const Icon(Icons.route_rounded),
            label: lang.t('journey'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.badge_outlined),
            selectedIcon: const Icon(Icons.badge_rounded),
            label: lang.t('crew_card'),
          ),
        ],
      ),
    );
  }
}
