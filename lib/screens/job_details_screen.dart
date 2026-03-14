import 'package:flutter/material.dart';
import 'apply_waiting_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobTitle;
  final String companyName;

  const JobDetailsScreen(
      {required this.jobTitle, required this.companyName, super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _tag(String text, double fontSize) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: TextStyle(fontSize: fontSize)),
      );

  Widget _tabButton(String text, int index) {
    final isActive = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: isActive ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, double fontSize) => Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(title,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)));

  Widget _bullet(String text, double fontSize) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("•  "),
            Expanded(child: Text(text, style: TextStyle(fontSize: fontSize))),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isSmall = w < 360;
    final fontSmall = isSmall ? 12.0 : 14.0;
    final fontNormal = isSmall ? 14.0 : 16.0;
    final fontTitle = isSmall ? 16.0 : 18.0;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.06, vertical: h * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Header
                  Container(
                    padding: EdgeInsets.all(w * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: w * 0.065,
                              backgroundColor: Colors.blue,
                              child: Text(widget.companyName[0],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: w * 0.07,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(width: w * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.companyName,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontNormal)),
                                  Text(widget.jobTitle,
                                      style: TextStyle(
                                          fontSize: fontTitle,
                                          fontWeight: FontWeight.bold)),
                                  Text("Bandung, Jawa Barat",
                                      style: TextStyle(
                                          fontSize: fontSmall,
                                          color: Colors.grey)),
                                ],
                              ),
                            ),
                            Icon(Icons.bookmark_border, size: fontTitle + 4),
                          ],
                        ),
                        SizedBox(height: h * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _tag("Remote", fontSmall),
                            _tag("Intermediate", fontSmall),
                            _tag("Full Time", fontSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  // Tabs
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        _tabButton("Description", 0),
                        _tabButton("Company", 1),
                      ],
                    ),
                  ),
                  if (selectedTab == 0) ...[
                    _sectionTitle("Job Description", fontTitle),
                    Text(
                      "We are currently looking for a web developer with 2 years experience, and can operate our product, namely web builder, we will recruit candidates on a full time basis and can work from anywhere.",
                      style:
                          TextStyle(color: Colors.grey, fontSize: fontNormal),
                    ),
                    _sectionTitle("A Must Have Skill", fontTitle),
                    _bullet("JavaScript", fontNormal),
                    _bullet("HTML, CSS", fontNormal),
                    _bullet(
                        "Mastering web builder especially Webflow", fontNormal),
                    _bullet("PHP", fontNormal),
                  ] else ...[
                    _sectionTitle("Company", fontTitle),
                    Text(
                      "Webflow is a modern web development platform focusing on visual web builder solutions.",
                      style:
                          TextStyle(color: Colors.grey, fontSize: fontNormal),
                    ),
                  ],
                  SizedBox(height: h * 0.03),
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ApplyWaitingScreen()),
                        );
                      },
                      child: Text("Apply Job",
                          style: TextStyle(fontSize: fontNormal)),
                    ),
                  ),
                  SizedBox(height: h * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
