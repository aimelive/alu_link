import 'package:flutter/material.dart';
import '../theme/pad_theme.dart';
import 'auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthGate()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pad.nightBg,
      body: Center(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Pad.ember,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.rocket_launch_rounded,
                    color: Colors.white, size: 38),
              ),
              const SizedBox(height: 20),
              Text('LaunchPad ALU',
                  style: Pad.display(size: 28, color: Colors.white)),
              const SizedBox(height: 6),
              Text('MISSIONS · CREWS · VENTURES',
                  style: Pad.mono(size: 11, color: const Color(0xFF9DB4A9))),
            ],
          ),
        ),
      ),
    );
  }
}
