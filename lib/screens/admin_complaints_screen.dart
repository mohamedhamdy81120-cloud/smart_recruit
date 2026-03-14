import 'package:flutter/material.dart';

class AdminComplaintsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> complaints;

  const AdminComplaintsScreen({super.key, required this.complaints});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen> {
  void _replyToComplaint(int index) {
    final TextEditingController replyController =
        TextEditingController(text: widget.complaints[index]["response"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reply to Complaint"),
        content: TextField(
          controller: replyController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Type your reply here",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.complaints[index]["response"] =
                    replyController.text.trim();
                widget.complaints[index]["status"] = "replied";
              });
              Navigator.pop(context);
            },
            child: const Text("Send Reply"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text("User Complaints"),
        centerTitle: true,
      ),
      body: widget.complaints.isEmpty
          ? const Center(child: Text("No complaints yet"))
          : ListView.builder(
              padding: EdgeInsets.all(size.width * 0.04),
              itemCount: widget.complaints.length,
              itemBuilder: (context, index) {
                final complaint = widget.complaints[index];
                return Card(
                  margin: EdgeInsets.only(bottom: size.height * 0.02),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint["subject"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.045),
                        ),
                        SizedBox(height: size.height * 0.005),
                        Text(
                          "From: ${complaint["email"]}  |  Date: ${complaint["date"]}",
                          style: TextStyle(
                              fontSize: size.width * 0.035, color: Colors.grey),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          complaint["message"],
                          style: TextStyle(fontSize: size.width * 0.04),
                        ),
                        if ((complaint["response"] ?? "").isNotEmpty) ...[
                          Divider(height: size.height * 0.03),
                          Text(
                            "Response:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.04),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            complaint["response"],
                            style: TextStyle(fontSize: size.width * 0.04),
                          ),
                        ],
                        SizedBox(height: size.height * 0.01),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _replyToComplaint(index),
                            child: Text(
                              (complaint["response"] ?? "").isEmpty
                                  ? "Reply"
                                  : "Edit Reply",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
