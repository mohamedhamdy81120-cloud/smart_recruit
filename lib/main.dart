import 'package:flutter/material.dart';
import '../screens/dream_job.dart'; // استورد صفحة البداية
import 'theme/app_theme.dart';

void main() {
  runApp(const SmartRecruitApp());
}

class SmartRecruitApp extends StatelessWidget {
  const SmartRecruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartRecruit',
      theme: AppTheme.lightTheme,
      home: const DreamJobScreen(), // البداية من هنا
    );
  }
}
