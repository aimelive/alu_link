import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/pad_theme.dart';
import 'command_deck_tab.dart';
import 'launch_mission_tab.dart';
import 'venture_tab.dart';

/// Venture (startup) shell: Command deck, Launch, Venture profile.
class FounderShell extends StatefulWidget {
  const FounderShell({super.key});

  @override
  State<FounderShell> createState() => _FounderShellState();
}

class _FounderShellState extends State<FounderShell> {
  int _index = 0;

  final List<Widget> _tabs = [
    const CommandDeckTab(),
    const LaunchMissionTab(),
    const VentureTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final lang = context.watch<LanguageProvider>();

    final titles = [
      lang.t('my_opportunities'),
      lang.t('post_opportunity'),
      lang.t('my_profile'),
    ];
    final eyebrows = ['VENTURE HQ', 'NEW MISSION', 'IDENTITY'];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(eyebrows[_index], style: Pad.mono(size: 9, color: Pad.ember)),
            Text(titles[_index]),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => lang.toggle(),
            child: Text(lang.isFrench ? 'EN' : 'FR',
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          IconButton(
            icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => theme.toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logOut(),
          ),
        ],
      ),
      body: _tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: lang.t('my_roles'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.rocket_launch_outlined),
            selectedIcon: const Icon(Icons.rocket_launch_rounded),
            label: lang.t('post'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront_rounded),
            label: lang.t('profile'),
          ),
        ],
      ),
    );
  }
}
