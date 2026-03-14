import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'register_screen.dart'; // استورد صفحة التسجيل

class DreamJobScreen extends StatefulWidget {
  const DreamJobScreen({super.key});

  @override
  State<DreamJobScreen> createState() => _DreamJobScreenState();
}

class _DreamJobScreenState extends State<DreamJobScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final titleFontSize = width * 0.08;
    final subtitleFontSize = width * 0.035;
    final chipFontSize = width * 0.038;
    final chipIconSize = width * 0.08;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ===== Animated Waves Background =====
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Positioned(
                        bottom: height * (0.08 + i * 0.05),
                        left: -50,
                        right: -50,
                        child: CustomPaint(
                          size: Size(width, height * 0.2),
                          painter: WavePainter(
                            amplitude: 12.0 + i * 8,
                            opacity: 0.06 + i * 0.04,
                            frequency: 1.5 + i * 0.2,
                            phase:
                                _controller.value * 2 * math.pi * (1 + i * 0.2),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            // ===== JOB CHIPS FLEXIBLE =====
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: height * 0.02),
                child: Wrap(
                  spacing: width * 0.03,
                  runSpacing: height * 0.015,
                  alignment: WrapAlignment.center,
                  children: [
                    jobChip("UI Designer", "assets/icons/ui.jpg",
                        fontSize: chipFontSize, iconSize: chipIconSize),
                    jobChip("Web Developer", "assets/icons/amazon.jpg",
                        fontSize: chipFontSize, iconSize: chipIconSize),
                    jobChip("Mobile Developer", "assets/icons/mobile.jpg",
                        fontSize: chipFontSize, iconSize: chipIconSize),
                    jobChip("Data Analyst", "assets/icons/analytics.jpg",
                        highlighted: true,
                        fontSize: chipFontSize,
                        iconSize: chipIconSize),
                    jobChip("Shopify Expert", "assets/icons/shopify.jpg",
                        fontSize: chipFontSize, iconSize: chipIconSize),
                  ],
                ),
              ),
            ),

            // ===== CONTENT =====
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(width * 0.06),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Find Your Dream\nJob Here",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Text(
                      "Here Is The Place Where You Can Find The Job Vacancies You Want",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.03),

                    // ===== Dots =====
                    Row(
                      children: [
                        dot(active: true),
                        dot(),
                        dot(),
                      ],
                    ),

                    SizedBox(height: height * 0.04),

                    // ===== BUTTON =====
                    SizedBox(
                      width: double.infinity,
                      height: height * 0.07,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          "Find Your Job",
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== JOB CHIP =====
  Widget jobChip(String title, String iconPath,
      {bool highlighted = false, double fontSize = 16, double iconSize = 40}) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween<double>(begin: 0.95, end: highlighted ? 1.05 : 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: highlighted ? -math.pi / 16 : 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: highlighted ? Colors.greenAccent : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(iconPath, width: iconSize, height: iconSize),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget dot({bool active = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ===== WAVE PAINTER =====
class WavePainter extends CustomPainter {
  final double amplitude;
  final double opacity;
  final double frequency;
  final double phase;

  WavePainter({
    required this.amplitude,
    required this.opacity,
    this.frequency = 1.0,
    this.phase = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    path.moveTo(0, size.height * 0.6);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.6 +
          math.sin(x / size.width * 2 * math.pi * frequency + phase) *
              amplitude;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
