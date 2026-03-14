import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cv_storage_screen.dart'; // تأكد من مسار الاستيراد الصحيح

class AdminCVScreen extends StatefulWidget {
  const AdminCVScreen({super.key});

  @override
  State<AdminCVScreen> createState() => _AdminCVScreenState();
}

class _AdminCVScreenState extends State<AdminCVScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadCVs();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  Future<void> _loadCVs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('all_cvs') ?? [];
    cvListNotifier.value = stored;
  }

  Future<void> _deleteCV(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedList = List<String>.from(cvListNotifier.value);
    updatedList.remove(fileName);
    await prefs.setStringList('all_cvs', updatedList);
    cvListNotifier.value = updatedList;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3D3E),
        title: const Text("Admin CVs"),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(w * 0.06),
              child: Column(
                children: [
                  // 🔍 Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search CVs...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },
                  ),
                  SizedBox(height: h * 0.03),

                  Expanded(
                    child: ValueListenableBuilder<List<String>>(
                      valueListenable: cvListNotifier,
                      builder: (_, storedCVs, __) {
                        final filteredCVs = storedCVs
                            .where((cv) => cv
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                            .toList();

                        if (filteredCVs.isEmpty) {
                          return Center(
                            child: Text(
                              "No CVs found",
                              style: TextStyle(
                                  fontSize: w * 0.045, color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredCVs.length,
                          itemBuilder: (_, index) {
                            final cvName = filteredCVs[index];
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              margin: EdgeInsets.only(bottom: h * 0.02),
                              padding: EdgeInsets.all(w * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.05),
                                    blurRadius: 8,
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.description,
                                      color: Colors.blueAccent),
                                  SizedBox(width: w * 0.03),
                                  Expanded(
                                    child: Text(
                                      cvName,
                                      style: TextStyle(
                                          fontSize: w * 0.04,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteCV(cvName),
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
