import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width >= 600;
    const primaryGreen = Color(0xFF17B978);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 80 : 24,
                    vertical: 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.05),

                      /// ✅ Check Icon
                      Container(
                        width: isTablet ? 160 : 120,
                        height: isTablet ? 160 : 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryGreen.withOpacity(0.1),
                          border: Border.all(
                            color: primaryGreen,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          size: isTablet ? 80 : 60,
                          color: primaryGreen,
                        ),
                      ),

                      SizedBox(height: size.height * 0.06),

                      /// Title
                      Text(
                        'Successful',
                        style: TextStyle(
                          fontSize: isTablet ? 28 : 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Description
                      Text(
                        'Congratulations! Your password has been changed.\nClick continue to login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: size.height * 0.08),

                      /// Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: isTablet ? 60 : 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            /// Navigate to Login and remove previous routes
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Continue to Login',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
