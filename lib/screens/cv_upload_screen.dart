import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CVUploadScreen extends StatefulWidget {
  const CVUploadScreen({super.key});

  @override
  State<CVUploadScreen> createState() => _CVUploadScreenState();
}

class _CVUploadScreenState extends State<CVUploadScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedFileName;
  File? _selectedFile;
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
    _loadSavedCV();
  }

  Future<void> _loadSavedCV() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedFileName = prefs.getString('cv_file_name');
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _selectedFileName = _selectedFile!.path.split('/').last;
      });
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  Future<void> _uploadCV() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file first')),
      );
      return;
    }

    setState(() => _isUploading = true);

    // محاكاة رفع الملف
    await Future.delayed(const Duration(seconds: 2));

    // حفظ اسم الملف في SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cv_file_name', _selectedFileName!);

    setState(() => _isUploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "تم الرفع بنجاح، بانتظار الترشيح للوظيفة",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF17B978),
        duration: Duration(seconds: 3),
      ),
    );
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
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: _pickFile,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: size.height * 0.12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _selectedFileName != null
                          ? Colors.teal.shade50
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        if (_selectedFileName != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _selectedFileName!,
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
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF26C6DA),
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
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Upload',
                          style: TextStyle(
                            fontSize: isSmall ? 16 : 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
