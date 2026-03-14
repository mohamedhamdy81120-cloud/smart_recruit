import 'package:flutter/material.dart';
import 'job_details_screen.dart';

class JobHomeScreen extends StatefulWidget {
  const JobHomeScreen({super.key});

  @override
  State<JobHomeScreen> createState() => _JobHomeScreenState();
}

class _JobHomeScreenState extends State<JobHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  List<Map<String, dynamic>> jobs = [
    {
      "company": "Amazon",
      "title": "Data Analyst",
      "salary": "8.000.000 - 12.000.000",
      "tags": ["Remote", "Intermediate", "Full Time"],
      "bookmarked": false,
    },
    {
      "company": "Webflow",
      "title": "Web Developer",
      "salary": "8.000.000 - 12.000.000",
      "tags": ["Remote", "Senior", "Full Time"],
      "bookmarked": false,
    },
    {
      "company": "Google",
      "title": "Mobile Developer",
      "salary": "10.000.000 - 15.000.000",
      "tags": ["Onsite", "Senior", "Full Time"],
      "bookmarked": false,
    },
  ];

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
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

  List<Map<String, dynamic>> get filteredJobs {
    if (searchQuery.isEmpty) return jobs;
    return jobs
        .where((job) =>
            job['company'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            job['title'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  Widget _jobCard({
    required Map<String, dynamic> job,
    required double width,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobDetailsScreen(
              jobTitle: job['title'],
              companyName: job['company'],
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: EdgeInsets.only(bottom: width * 0.04),
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Text(job['company'][0]),
                ),
                SizedBox(width: width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['company'],
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.04)),
                      Text(job['title'],
                          style: TextStyle(
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    job['bookmarked'] ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      job['bookmarked'] = !job['bookmarked'];
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: width * 0.03),
            Text(job['salary'],
                style: TextStyle(color: Colors.grey, fontSize: width * 0.04)),
            SizedBox(height: width * 0.03),
            Wrap(
              spacing: width * 0.02,
              runSpacing: width * 0.02,
              children: job['tags']
                  .map<Widget>(
                    (e) => Chip(
                      backgroundColor: Colors.grey.shade100,
                      label: Text(e, style: TextStyle(fontSize: width * 0.035)),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
                  /// 🔍 Search Field
                  TextField(
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search jobs...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.02),

                  Text("Recent Jobs",
                      style: TextStyle(
                          fontSize: w * 0.05, fontWeight: FontWeight.bold)),
                  SizedBox(height: h * 0.02),

                  ...filteredJobs.map((job) => _jobCard(job: job, width: w)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
