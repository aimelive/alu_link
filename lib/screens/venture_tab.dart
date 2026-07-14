import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../theme/pad_theme.dart';

/// The venture's public identity, plus a live clearance badge
/// streamed straight from Firestore (flipped by mission control).
class VentureTab extends StatefulWidget {
  const VentureTab({super.key});

  @override
  State<VentureTab> createState() => _VentureTabState();
}

class _VentureTabState extends State<VentureTab> {
  final _bio = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _bio.text = context.read<AuthProvider>().user?.bio ?? '';
  }

  @override
  void dispose() {
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final lang = context.read<LanguageProvider>();
    await context.read<AuthProvider>().updateBio(_bio.text.trim());
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.t('profile_saved'))),
      );
    }
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Pad.runway,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: Pad.display(size: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: Pad.display(size: 18)),
                        const SizedBox(height: 2),
                        Text(user.email,
                            style: TextStyle(color: muted, fontSize: 13)),
                        const SizedBox(height: 8),
                        // Live clearance badge from Firestore
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            final data = snapshot.data?.data()
                                as Map<String, dynamic>?;
                            final verified = data?['verified'] ?? false;
                            final color =
                                verified ? Pad.signal : const Color(0xFF8B9490);
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                      verified
                                          ? Icons.verified_rounded
                                          : Icons.pending_rounded,
                                      size: 14,
                                      color: color),
                                  const SizedBox(width: 5),
                                  Text(
                                    (verified
                                            ? lang.t('verified')
                                            : lang.t('not_verified'))
                                        .toUpperCase(),
                                    style: Pad.mono(size: 9, color: color),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(lang.t('about_org'), style: Pad.display(size: 18)),
          const SizedBox(height: 4),
          Text(lang.t('about_org_hint'),
              style: TextStyle(color: muted, fontSize: 13)),
          const SizedBox(height: 14),
          TextField(
            controller: _bio,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText:
                  'e.g. A student-led venture building logistics tools for Kigali markets.',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text(lang.t('save_profile')),
          ),
        ],
      ),
    );
  }
}
