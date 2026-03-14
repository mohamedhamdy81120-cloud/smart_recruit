import 'package:flutter/material.dart';
import 'admin_panel.dart';
import 'add_admin_job.dart';
import 'admin_complaints_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fade;

  // Dummy complaints list for testing
  final List<Map<String, dynamic>> complaints = [
    {
      "email": "user1@example.com",
      "subject": "App crash",
      "message": "The app crashes when I try to upload a file.",
      "response": "",
      "date": "2026-03-03"
    },
    {
      "email": "user2@example.com",
      "subject": "Payment issue",
      "message": "Payment not processed after submit.",
      "response": "",
      "date": "2026-03-02"
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Widget _dashboardButton({
    required Color color,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 12),
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // ===== Top Gradient Header =====
                Container(
                  height: size.height * 0.2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F3D3E), Color(0xFF17B978)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Admin Dashboard",
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ===== Buttons =====
                _dashboardButton(
                  color: Colors.green,
                  icon: Icons.dashboard,
                  title: "Admin Panel",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminPanel()),
                    );
                  },
                  width: size.width,
                ),

                _dashboardButton(
                  color: Colors.orange,
                  icon: Icons.add,
                  title: "Add Admin Job",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AddAdminJobScreen()),
                    );
                  },
                  width: size.width,
                ),

                // ===== New Button: User Complaints =====
                _dashboardButton(
                  color: Colors.redAccent,
                  icon: Icons.feedback_outlined,
                  title: "User Complaints",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminComplaintsScreen(
                          complaints: complaints,
                        ),
                      ),
                    );
                  },
                  width: size.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
