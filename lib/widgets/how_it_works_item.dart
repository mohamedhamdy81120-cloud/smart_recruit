import 'package:flutter/material.dart';

class HowItWorksItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const HowItWorksItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF17B978)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
