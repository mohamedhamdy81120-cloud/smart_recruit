import 'package:flutter/material.dart';

class LoginShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0); // أعلى شمال
    path.lineTo(size.width * 0.50, 0);

    // أسفل يمين (مائل للداخل)
    path.lineTo(size.width, size.height * 0.50);

    // أسفل شمال
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
