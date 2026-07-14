import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../theme/pad_theme.dart';

/// The student's crew card: identity header plus the skill deck
/// that powers readiness scoring across the board.
class CrewCardTab extends StatefulWidget {
  const CrewCardTab({super.key});

  @override
  State<CrewCardTab> createState() => _CrewCardTabState();
}

class _CrewCardTabState extends State<CrewCardTab> {
  final _skillController = TextEditingController();

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isEmpty) return;
    context.read<AuthProvider>().addSkill(skill);
    _skillController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();
    final user = auth.user;
    if (user == null) return const SizedBox();

    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Crew card header — dark panel like a boarding pass
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Pad.runway,
              borderRadius: BorderRadius.circular(Pad.cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('CREW CARD',
                        style: Pad.mono(size: 10, color: Pad.ember)),
                    const Spacer(),
                    const Icon(Icons.rocket_launch_rounded,
                        color: Colors.white54, size: 18),
                  ],
                ),
                const SizedBox(height: 14),
                Text(user.name,
                    style: Pad.display(size: 24, color: Colors.white)),
                const SizedBox(height: 4),
                Text(user.email,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 14),
                Text(
                  '${user.skills.length} SKILLS ON DECK',
                  style: Pad.mono(size: 10, color: Colors.white60),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(lang.t('my_skills'), style: Pad.display(size: 18)),
          const SizedBox(height: 4),
          Text(lang.t('skills_hint'),
              style: TextStyle(color: muted, fontSize: 13)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.skills
                .map((skill) => Chip(
                      label: Text(skill),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => auth.removeSkill(skill),
                    ))
                .toList(),
          ),
          if (user.skills.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(lang.t('no_skills'),
                  style: TextStyle(color: muted, fontSize: 13)),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillController,
                  onSubmitted: (_) => _addSkill(),
                  decoration: InputDecoration(
                    hintText: lang.t('add_skill_hint'),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _addSkill,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 20)),
                  child: Text(lang.t('add')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          OutlinedButton.icon(
            onPressed: () => auth.logOut(),
            icon: const Icon(Icons.logout, size: 18),
            label: Text(lang.t('logout')),
          ),
        ],
      ),
    );
  }
}
