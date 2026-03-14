import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

// Screens
import 'home_screen.dart';
import 'admin_dashboard_screen.dart';
import 'register_screen.dart';
import 'forgot_password.dart';

// Widgets
import '../widgets/UsernameIcon.dart';
import '../widgets/PasswordField.dart';

// Theme / Clipper
import '../theme/login_shape_clipper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _btnController;
  late Animation<double> _btnScale;
  late AnimationController _fadeController;
  late Animation<double> _usernameOpacity;
  late Animation<double> _passwordOpacity;
  late Animation<double> _forgotOpacity;
  late Animation<double> _buttonOpacity;

  final String _adminUsernameHash =
      sha256.convert(utf8.encode("admin")).toString();
  final String _adminPasswordHash =
      sha256.convert(utf8.encode("admin123")).toString();

  final List<Map<String, String>> _localUsers = [
    {
      'name': 'test',
      'password': sha256.convert(utf8.encode('123456')).toString(),
      'status': 'approved',
    },
  ];

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _btnScale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _btnController, curve: Curves.easeOut),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _usernameOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: const Interval(0, 0.25)),
    );
    _passwordOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _fadeController, curve: const Interval(0.2, 0.45)),
    );
    _forgotOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _fadeController, curve: const Interval(0.4, 0.65)),
    );
    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: const Interval(0.6, 1.0)),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _btnController.dispose();
    _fadeController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onBtnTapDown(TapDownDetails details) => _btnController.forward();
  void _onBtnTapUp(TapUpDetails details) {
    _btnController.reverse();
    _login();
  }

  void _onBtnTapCancel() => _btnController.reverse();

  void _login() {
    if (_formKey.currentState!.validate()) {
      final username = usernameController.text.trim();
      final password = passwordController.text;
      final passwordHash = sha256.convert(utf8.encode(password)).toString();
      final usernameHash = sha256.convert(utf8.encode(username)).toString();

      if (usernameHash == _adminUsernameHash &&
          passwordHash == _adminPasswordHash) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        );
        return;
      }

      final user = _localUsers.firstWhere(
        (u) => u['name'] == username && u['password'] == passwordHash,
        orElse: () => {},
      );

      if (user.isEmpty) {
        _showMessage("المستخدم غير موجود أو كلمة المرور خاطئة.");
        return;
      }

      final status = user['status'] ?? 'pending';
      if (status == 'pending') {
        _showMessage("في انتظار موافقة المسؤول.");
      } else if (status == 'rejected') {
        _showMessage("تم رفض حسابك.");
      } else if (status == 'approved') {
        _showMessage("تم تسجيل الدخول بنجاح!", success: true);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        });
      }
    }
  }

  void _showMessage(String msg, {bool success = false}) {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(
            vertical: size.height * 0.03, horizontal: size.width * 0.05),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red,
                size: size.width * 0.2),
            SizedBox(height: size.height * 0.02),
            Text(msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size.width < 360 ? 16 : 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _animatedField(
      {required Widget child, required Animation<double> anim}) {
    return AnimatedBuilder(
      animation: anim,
      builder: (context, childWidget) {
        return Opacity(
          opacity: anim.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - anim.value)),
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topHeight = size.height * 0.35;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                SizedBox(
                  height: topHeight,
                  child: Stack(
                    children: [
                      Container(color: Colors.white),
                      Positioned(
                        width: size.width * 0.6,
                        height: topHeight * 0.7,
                        child: ClipPath(
                          clipper: LoginShapeClipper(),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF0F3D3E), Color(0xFF17B978)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 8,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Login",
                                style: TextStyle(
                                    fontSize: size.width * 0.1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            SizedBox(height: size.height * 0.01),
                            Container(
                              width: size.width * 0.12,
                              height: size.height * 0.005,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3)),
                            ),
                            SizedBox(height: size.height * 0.02),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFBFF391),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.06,
                        vertical: size.height * 0.03),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _animatedField(
                              anim: _usernameOpacity,
                              child: TextFormField(
                                controller: usernameController,
                                validator: (v) =>
                                    v!.isEmpty ? "Enter your username" : null,
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  labelStyle: TextStyle(
                                      fontSize: size.width * 0.045,
                                      fontWeight: FontWeight.bold),
                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: UsernameIcon(),
                                  ),
                                  border: const UnderlineInputBorder(),
                                ),
                              )),
                          SizedBox(height: size.height * 0.03),
                          _animatedField(
                            anim: _passwordOpacity,
                            child: PasswordField(
                              controller: passwordController,
                              validator: (v) =>
                                  v!.isEmpty ? "Enter your password" : null,
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),
                          _animatedField(
                            anim: _forgotOpacity,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgotPasswordScreen()));
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    color: const Color(0xFF054208),
                                    fontSize: size.width * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          _animatedField(
                            anim: _buttonOpacity,
                            child: Center(
                              child: GestureDetector(
                                onTapDown: _onBtnTapDown,
                                onTapUp: _onBtnTapUp,
                                onTapCancel: _onBtnTapCancel,
                                child: AnimatedBuilder(
                                  animation: _btnScale,
                                  builder: (context, child) => Transform.scale(
                                    scale: _btnScale.value,
                                    child: Container(
                                      width: size.width * 0.55,
                                      height: size.height * 0.09,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF17B978),
                                            Color(0xFF0F3D3E)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4))
                                        ],
                                      ),
                                      child: const Center(
                                          child: Text("Login",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
