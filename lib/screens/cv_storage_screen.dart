import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 👑 ValueNotifier لتحديث الـ CVs مباشرة في Admin Screen
ValueNotifier<List<String>> cvListNotifier = ValueNotifier([]);

class CVStorageScreen extends StatefulWidget {
  const CVStorageScreen({super.key});

  @override
  State<CVStorageScreen> createState() => _CVStorageScreenState();
}

class _CVStorageScreenState extends State<CVStorageScreen>
    with SingleTickerProviderStateMixin {
  String? _cvFileName;
  bool _isUploading = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _loadStoredCV();
  }

  /// تحميل CVs المخزنة مسبقًا
  Future<void> _loadStoredCV() async {
    final prefs = await SharedPreferences.getInstance();
    final storedCVs = prefs.getStringList('all_cvs') ?? [];
    if (storedCVs.isNotEmpty) {
      setState(() => _cvFileName = storedCVs.last);
      cvListNotifier.value = storedCVs;
    }
  }

  /// اختيار الملف من الجهاز
  Future<void> _pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.name.isNotEmpty) {
      setState(() {
        _cvFileName = result.files.single.name;
      });
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  /// رفع وحفظ CV
  Future<void> _uploadCV() async {
    if (_cvFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a CV first')),
      );
      return;
    }

    setState(() => _isUploading = true);

    await Future.delayed(const Duration(seconds: 2)); // محاكاة رفع الملف

    final prefs = await SharedPreferences.getInstance();
    final storedCVs = prefs.getStringList('all_cvs') ?? [];
    if (!storedCVs.contains(_cvFileName)) {
      storedCVs.add(_cvFileName!);
      await prefs.setStringList('all_cvs', storedCVs);
      cvListNotifier.value = storedCVs; // Live update للـ Admin
    }

    setState(() => _isUploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "تم حفظ الـ CV بنجاح، بانتظار الترشيح للوظيفة",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF17B978),
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// حذف CV المخزن
  Future<void> _clearCV() async {
    final prefs = await SharedPreferences.getInstance();
    final storedCVs = prefs.getStringList('all_cvs') ?? [];
    storedCVs.remove(_cvFileName);
    await prefs.setStringList('all_cvs', storedCVs);
    cvListNotifier.value = storedCVs;

    setState(() => _cvFileName = null);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload CV"),
        backgroundColor: const Color(0xFF0F3D3E),
        actions: [
          if (_cvFileName != null)
            IconButton(
              onPressed: _clearCV,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: _pickCV,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: size.height * 0.12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _cvFileName != null
                          ? Colors.teal.shade50
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: Colors.grey.shade400, width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (_cvFileName != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _cvFileName!,
                                style: TextStyle(
                                  fontSize: isSmall ? 14 : 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: isSmall ? 50 : 56,
                              height: isSmall ? 50 : 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF26C6DA),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF26C6DA)
                                        .withOpacity(0.38),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: isSmall ? 55 : 60,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _uploadCV,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Upload & Save',
                          style: TextStyle(fontSize: 17),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
