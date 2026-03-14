import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import './login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // قائمة لتخزين المستخدمين محليًا
  final List<Map<String, String>> _localUsers = [];

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmController.text) {
        _showMessage("كلمات السر غير متطابقة!");
        return;
      }

      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final passwordHash =
          sha256.convert(utf8.encode(passwordController.text)).toString();

      // التحقق من وجود المستخدم محليًا
      final exists = _localUsers.any((user) => user['name'] == name);
      if (exists) {
        _showMessage("المستخدم موجود بالفعل!");
        return;
      }

      // إضافة المستخدم إلى القائمة المحلية
      _localUsers.add({
        'name': name,
        'email': email,
        'password': passwordHash,
        'status': 'pending',
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("تم"),
            content:
                const Text("تم إنشاء حسابك محليًا، في انتظار موافقة المسؤول."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text("OK"))
            ],
          );
        },
      );
    }
  }

  void _showMessage(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("تنبيه"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallHeight = size.height < 700;
    final double fieldSpacing =
        isSmallHeight ? size.height * 0.02 : size.height * 0.03;
    final double buttonHeight =
        isSmallHeight ? size.height * 0.065 : size.height * 0.07;
    final double titleFont = size.width < 360 ? 28 : 32;
    final double subtitleFont = size.width < 360 ? 14 : 16;
    const primaryGreen = Color(0xFF17B978);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F3D3E),
              Color(0xFF1B6B5F),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: isSmallHeight ? size.height * 0.02 : size.height * 0.03,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.05),
                  Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  Text(
                    "Create your account to get started",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: subtitleFont,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  buildField(
                      controller: emailController,
                      label: "Email",
                      hint: "Enter your Email",
                      icon: Icons.email_outlined,
                      size: size),
                  buildField(
                      controller: nameController,
                      label: "Name",
                      hint: "Enter your Name",
                      icon: Icons.person_outline,
                      size: size),
                  buildField(
                      controller: passwordController,
                      label: "Password",
                      hint: "Enter your Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      size: size),
                  buildField(
                      controller: confirmController,
                      label: "Confirm Password",
                      hint: "Match your Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      size: size),
                  SizedBox(height: fieldSpacing),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _register,
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width < 360 ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: size.width < 360 ? 12 : 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width < 360 ? 12 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
    required IconData icon,
    required Size size,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: size.width < 360 ? 12 : 14,
          ),
        ),
        SizedBox(height: size.height * 0.008),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "هذا الحقل مطلوب";
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white70),
            contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04, vertical: size.height * 0.018),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white38),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF17B978)),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.025),
      ],
    );
  }
}
