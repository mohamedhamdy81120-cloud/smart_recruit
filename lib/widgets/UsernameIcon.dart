import 'package:flutter/material.dart';

class UsernameIcon extends StatelessWidget {
  const UsernameIcon({super.key, this.size = 36});

  final double size; // تقدر تغير الحجم بسهولة

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _UsernameIconPainter()),
    );
  }
}

class _UsernameIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const gradient = LinearGradient(
      colors: [Color(0xFF6EC6FF), Color(0xFF8E7DFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    // دائرة خارجية
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - paint.strokeWidth / 2,
      paint,
    );

    // رأس الشخص (صغيرة دائرة)
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.35),
      size.width * 0.18,
      paint,
    );

    // جسم الشخص (نصف دائرة)
    final bodyRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.75),
      width: size.width * 0.7,
      height: size.height * 0.5,
    );
    canvas.drawArc(bodyRect, 3.14, 3.14, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
