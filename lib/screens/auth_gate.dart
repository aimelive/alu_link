import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'explorer_shell.dart';
import 'founder_shell.dart';
import 'mission_control_screen.dart';

/// Routes the user to the correct shell based on their role.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return const LoginScreen();
    }

    switch (auth.user!.role) {
      case 'student':
        return const ExplorerShell();
      case 'startup':
        return const FounderShell();
      case 'admin':
        return const MissionControlScreen();
      default:
        return const ExplorerShell();
    }
  }
}
