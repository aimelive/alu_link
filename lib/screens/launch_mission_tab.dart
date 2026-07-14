import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/opportunity_provider.dart';
import '../providers/language_provider.dart';
import '../models/opportunity_model.dart';
import '../utils/departments.dart';
import '../theme/pad_theme.dart';

/// Form for launching a new mission onto the board.
class LaunchMissionTab extends StatefulWidget {
  const LaunchMissionTab({super.key});

  @override
  State<LaunchMissionTab> createState() => _LaunchMissionTabState();
}

class _LaunchMissionTabState extends State<LaunchMissionTab> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _skills = TextEditingController();
  String _category = Departments.all.first;
  bool _posting = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _skills.dispose();
    super.dispose();
  }

  Future<void> _launch() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _posting = true);

    final auth = context.read<AuthProvider>();
    final opportunities = context.read<OpportunityProvider>();
    final lang = context.read<LanguageProvider>();
    final user = auth.user!;

    final skillList = _skills.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final mission = OpportunityModel(
      id: '',
      startupId: user.uid,
      startupName: user.name,
      title: _title.text.trim(),
      description: _description.text.trim(),
      category: _category,
      requiredSkills: skillList,
    );

    await opportunities.postOpportunity(mission);

    if (mounted) {
      setState(() => _posting = false);
      _title.clear();
      _description.clear();
      _skills.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.t('posted'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _title,
              decoration: InputDecoration(
                labelText: lang.t('opp_title'),
                hintText: 'e.g. Product Design Intern, Growth Analyst',
              ),
              validator: (v) =>
                  v!.trim().isEmpty ? lang.t('title_required') : null,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: InputDecoration(labelText: lang.t('category')),
              items: Departments.all
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _description,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: lang.t('opp_description'),
                alignLabelWithHint: true,
                hintText:
                    'What the mission is, what the crew member will do, and what they will learn.',
              ),
              validator: (v) =>
                  v!.trim().isEmpty ? lang.t('desc_required') : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _skills,
              decoration: InputDecoration(
                labelText: lang.t('skills_csv'),
                hintText: 'Flutter, Figma, Copywriting',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _posting ? null : _launch,
              icon: _posting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.rocket_launch_rounded, size: 20),
              label: Text(lang.t('post_opportunity')),
            ),
            const SizedBox(height: 10),
            Text(
              'Skills you list here drive each student\'s readiness ring.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color),
            ),
          ],
        ),
      ),
    );
  }
}
