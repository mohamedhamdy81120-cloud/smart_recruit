import 'package:flutter/material.dart';

class PasswordIcon extends StatelessWidget {
  const PasswordIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF6EC6FF), Color(0xFF4A90E2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: const Icon(
        Icons.lock_outline,
        size: 26,
        color: Colors.white,
      ),
    );
  }
}
