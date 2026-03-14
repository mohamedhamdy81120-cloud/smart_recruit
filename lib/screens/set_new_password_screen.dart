import 'package:flutter/material.dart';
import 'success_screen.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallHeight = size.height < 700;
    final double spacing =
        isSmallHeight ? size.height * 0.02 : size.height * 0.03;
    const primaryGreen = Color(0xFF17B978);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07, vertical: spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: spacing),

              // Title
              Text(
                "Set a new password",
                style: TextStyle(
                  fontSize: size.width < 360 ? 22 : 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.015),

              // Subtitle
              Text(
                "Create a new password. Ensure it differs from previous ones for security",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: size.width < 360 ? 13 : 15,
                ),
              ),
              SizedBox(height: spacing),

              // Password Field
              buildPasswordField(
                label: "Password",
                obscure: obscurePassword,
                toggle: () =>
                    setState(() => obscurePassword = !obscurePassword),
                size: size,
              ),
              SizedBox(height: spacing),

              // Confirm Password Field
              buildPasswordField(
                label: "Confirm Password",
                obscure: obscureConfirm,
                toggle: () => setState(() => obscureConfirm = !obscureConfirm),
                size: size,
              ),
              SizedBox(height: spacing * 1.5),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: size.height * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SuccessScreen()),
                    );
                  },
                  child: Text(
                    "Update Password",
                    style: TextStyle(
                      fontSize: size.width < 360 ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Password Field Builder
  Widget buildPasswordField({
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    required Size size,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: size.width < 360 ? 13 : 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: size.height * 0.01),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.018,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }
}
