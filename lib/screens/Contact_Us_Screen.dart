import 'package:flutter/material.dart';
import 'admin_complaints_screen.dart';
import 'package:intl/intl.dart';

const primaryColor = Color(0xFF2E7D32);

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  String subject = "General Inquiry";

  // Controllers for inputs
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Temporary complaints list (shared with AdminComplaintsScreen)
  final List<Map<String, dynamic>> complaints = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slide = Tween<Offset>(
      begin: const Offset(0, .1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.dispose();
  }

  // ===== Widgets =====

  Widget _inputField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _radioItem(String value) {
    return Expanded(
      child: RadioListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(value),
        value: value,
        groupValue: subject,
        onChanged: (val) {
          setState(() => subject = val!);
        },
      ),
    );
  }

  Widget _sendButton(double width) {
    return SizedBox(
      width: width,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (emailController.text.isEmpty || messageController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please enter email and message")),
            );
            return;
          }

          // Add complaint to list
          complaints.add({
            "firstName": firstNameController.text.trim(),
            "lastName": lastNameController.text.trim(),
            "email": emailController.text.trim(),
            "phone": phoneController.text.trim(),
            "subject": subject,
            "message": messageController.text.trim(),
            "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
            "response": "",
            "status": "pending",
          });

          // Navigate to AdminComplaintsScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminComplaintsScreen(complaints: complaints),
            ),
          );
        },
        child: const Text(
          "Send Message",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ===== Build UI =====

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallPhone = width < 360;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Logo Here",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.07,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                /// Header
                Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: isSmallPhone ? 24 : 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Any question or remarks?\nJust write us a message!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                /// Inputs
                _inputField("First Name", firstNameController),
                _inputField("Last Name", lastNameController),
                _inputField("Email", emailController),
                _inputField("Phone Number", phoneController),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Subject?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _radioItem("General Inquiry"),
                    _radioItem("Technical Inquiry"),
                  ],
                ),
                Row(
                  children: [
                    _radioItem("Billing Inquiry"),
                    _radioItem("Other Inquiry"),
                  ],
                ),

                const SizedBox(height: 20),
                _inputField("Write your message...", messageController,
                    maxLines: 4),

                const SizedBox(height: 30),
                _sendButton(double.infinity),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
