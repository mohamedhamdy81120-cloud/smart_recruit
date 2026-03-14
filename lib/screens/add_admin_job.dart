import 'package:flutter/material.dart';

class AddAdminJobScreen extends StatefulWidget {
  const AddAdminJobScreen({super.key});

  @override
  State<AddAdminJobScreen> createState() => _AddAdminJobScreenState();
}

class _AddAdminJobScreenState extends State<AddAdminJobScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController companyController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fade;

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
    companyController.dispose();
    titleController.dispose();
    salaryController.dispose();
    locationController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  void _saveJob() {
    if (_formKey.currentState!.validate()) {
      // هنا ممكن تعمل حفظ البيانات في قاعدة بيانات أو API
      final jobData = {
        "company": companyController.text,
        "title": titleController.text,
        "salary": salaryController.text,
        "location": locationController.text,
        "tags": tagsController.text.split(',').map((e) => e.trim()).toList(),
      };

      // مؤقتاً عرض رسالة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job added successfully!")),
      );

      // بعد الحفظ ممكن ترجع للصفحة الرئيسية
      Navigator.pop(context, jobData);
    }
  }

  Widget _inputField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter $label";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Admin Job"),
        backgroundColor: const Color(0xFF0F3D3E),
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.03,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _inputField("Company Name", companyController),
                _inputField("Job Title", titleController),
                _inputField("Salary", salaryController),
                _inputField("Location / Type", locationController),
                _inputField("Tags (comma separated)", tagsController),
                const SizedBox(height: 30),
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _saveJob,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF17B978),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Save Job",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
