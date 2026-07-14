import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../theme/pad_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _role = 'student';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.signUp(
      name: _name.text,
      email: _email.text,
      password: _password.text,
      role: _role,
    );
    if (ok && mounted) {
      Navigator.pop(context);
    }
  }

  Widget _roleCard(String value, IconData icon, String label) {
    final selected = _role == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _role = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            color: selected
                ? Pad.ember.withValues(alpha: 0.14)
                : Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? Pad.ember
                  : (isDark ? Pad.nightBorder : const Color(0xFFDDD5C4)),
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 26,
                  color: selected
                      ? Pad.ember
                      : Theme.of(context).textTheme.bodySmall?.color),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.5,
                      fontWeight:
                          selected ? FontWeight.w800 : FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(title: Text(lang.t('join_app'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(lang.t('i_am_a'),
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: muted)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _roleCard('student', Icons.group_rounded,
                      lang.t('student_role')),
                  const SizedBox(width: 12),
                  _roleCard('startup', Icons.rocket_launch_rounded,
                      lang.t('organization')),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: lang.t('full_name')),
                validator: (v) =>
                    v!.trim().isEmpty ? lang.t('name_required') : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: lang.t('email')),
                validator: (v) {
                  final email = v!.trim();
                  final ok = RegExp(r'^[\w.\-]+@[\w\-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(email);
                  return ok ? null : lang.t('valid_email');
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(labelText: lang.t('password')),
                validator: (v) {
                  final p = v ?? '';
                  final longEnough = p.length >= 6;
                  final hasCapital = RegExp(r'[A-Z]').hasMatch(p);
                  final hasNumber = RegExp(r'\d').hasMatch(p);
                  if (longEnough && hasCapital && hasNumber) return null;
                  return lang.t('password_rule');
                },
              ),
              const SizedBox(height: 24),
              if (auth.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(auth.error!,
                      style: const TextStyle(color: Pad.clay)),
                ),
              ElevatedButton(
                onPressed: auth.loading ? null : _submit,
                child: auth.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(lang.t('signup')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
