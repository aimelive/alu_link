import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../theme/pad_theme.dart';

/// Admin screen: clear (verify) ALU ventures so only recognized
/// ventures operate on the pad.
class MissionControlScreen extends StatelessWidget {
  const MissionControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();
    final db = FirebaseFirestore.instance;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ADMIN', style: Pad.mono(size: 9, color: Pad.ember)),
            Text(lang.t('admin_verify')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => lang.toggle(),
            child: Text(lang.isFrench ? 'EN' : 'FR',
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logOut(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Text(lang.t('admin_sub'),
                style: TextStyle(color: muted, fontSize: 13.5)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection('users')
                  .where('role', isEqualTo: 'startup')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(lang.t('no_orgs'),
                          style: TextStyle(color: muted, fontSize: 15)),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final id = docs[i].id;
                    final name = data['name'] ?? 'Unnamed';
                    final email = data['email'] ?? '';
                    final verified = data['verified'] ?? false;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: verified
                                    ? Pad.signal
                                    : const Color(0xFF8B9490),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: Pad.display(
                                    size: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: Pad.display(size: 15)),
                                  const SizedBox(height: 2),
                                  Text(email,
                                      style: TextStyle(
                                          color: muted, fontSize: 12.5)),
                                ],
                              ),
                            ),
                            if (verified)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.verified_rounded,
                                      size: 16, color: Pad.signal),
                                  const SizedBox(width: 4),
                                  Text(lang.t('verified').toUpperCase(),
                                      style: Pad.mono(
                                          size: 8.5, color: Pad.signal)),
                                ],
                              )
                            else
                              ElevatedButton(
                                onPressed: () => db
                                    .collection('users')
                                    .doc(id)
                                    .update({'verified': true}),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 38),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                ),
                                child: Text(lang.t('verify')),
                              ),
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
      ),
    );
  }
}
