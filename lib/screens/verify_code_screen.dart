import 'dart:async';
import 'package:flutter/material.dart';
import 'set_new_password_screen.dart';

const primaryColor = Color(0xFF2E7D32);

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> controllers =
      List.generate(5, (_) => TextEditingController());

  late AnimationController pageAnimationController;
  late Animation<double> fadeAnimation;

  late List<AnimationController> otpControllers;
  late List<Animation<double>> otpAnimations;

  int secondsRemaining = 60;
  bool canResend = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Page fade animation
    pageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    fadeAnimation =
        CurvedAnimation(parent: pageAnimationController, curve: Curves.easeIn);
    pageAnimationController.forward();

    // OTP boxes animations
    otpControllers = List.generate(
      5,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    otpAnimations = otpControllers
        .map((controller) =>
            CurvedAnimation(parent: controller, curve: Curves.easeOutBack))
        .toList();

    // Play animations sequentially
    for (int i = 0; i < otpControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) otpControllers[i].forward();
      });
    }

    startTimer();
  }

  void startTimer() {
    secondsRemaining = 60;
    canResend = false;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    pageAnimationController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    timer.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Widget buildOtpBox(int index, double boxSize) {
    return ScaleTransition(
      scale: otpAnimations[index],
      child: FadeTransition(
        opacity: otpAnimations[index],
        child: SizedBox(
          width: boxSize,
          height: boxSize,
          child: TextField(
            controller: controllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(
              fontSize: boxSize * 0.5,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor.withOpacity(0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 4) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallPhone = size.width < 360;
    double boxSize = isSmallPhone ? 50 : 65;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.03),

                /// Back Button
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                /// Title
                Text(
                  "Check your email",
                  style: TextStyle(
                    fontSize: size.width * 0.065,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: size.height * 0.015),

                /// Subtitle
                Text(
                  "We sent a reset link to contact@dscode.com\nEnter the 5-digit code from your email",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: size.width * 0.04,
                  ),
                ),

                SizedBox(height: size.height * 0.05),

                /// OTP Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (index) => buildOtpBox(index, boxSize),
                  ),
                ),

                SizedBox(height: size.height * 0.05),

                /// Verify Button
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SetNewPasswordScreen()),
                      );
                    },
                    child: Text(
                      "Verify Code",
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                /// Resend Timer
                Center(
                  child: canResend
                      ? GestureDetector(
                          onTap: startTimer,
                          child: Text(
                            "Resend Email",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallPhone ? 14 : 16,
                            ),
                          ),
                        )
                      : Text(
                          "Resend available in 00:${secondsRemaining.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isSmallPhone ? 13 : 15,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
