import 'package:flutter/material.dart';

class ComplaintSentScreen extends StatelessWidget {
  final Map<String, dynamic> complaint;
  const ComplaintSentScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Sent")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline,
                  size: size.width * 0.2, color: Colors.green),
              SizedBox(height: size.height * 0.03),
              Text(
                "Your complaint has been sent successfully.\nPlease wait for the admin's response.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size.width * 0.045),
              ),
              SizedBox(height: size.height * 0.05),
              ElevatedButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text("Back to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
