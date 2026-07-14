import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../theme/pad_theme.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    await auth.logIn(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final lang = context.watch<LanguageProvider>();
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top utility row: language + theme toggles
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => lang.toggle(),
                    child: Text(lang.isFrench ? 'EN' : 'FR',
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  IconButton(
                    icon: Icon(
                        theme.isDark ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () => theme.toggle(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Identity block
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Pad.ember,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.rocket_launch_rounded,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(height: 20),
              Text(lang.t('welcome'), style: Pad.display(size: 30)),
              const SizedBox(height: 6),
              Text(lang.t('tagline'),
                  style: TextStyle(fontSize: 15, color: muted)),
              const SizedBox(height: 32),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: lang.t('email')),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(labelText: lang.t('password')),
              ),
              const SizedBox(height: 20),
              if (auth.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(lang.t('wrong_details'),
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
                    : Text(lang.t('login')),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                child: Text(lang.t('no_account')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
