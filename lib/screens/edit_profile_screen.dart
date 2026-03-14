import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phone;
  final String gender;
  final String birthDate;

  const EditProfileScreen({
    super.key,
    this.firstName = "",
    this.lastName = "",
    this.username = "",
    this.email = "",
    this.phone = "",
    this.gender = "",
    this.birthDate = "",
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  String? gender;
  DateTime? birthDate;

  String countryCode = "02";
  String countryFlag = "🇪🇬";

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    gender = widget.gender.isEmpty ? null : widget.gender;

    if (widget.birthDate.isNotEmpty) {
      final parts = widget.birthDate.split('/');
      birthDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text("Edit Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06, vertical: isSmallScreen ? 10 : 20),
        child: Column(
          children: [
            /// 🔵 PROFILE ICON
            Container(
              width: size.width * 0.32,
              height: size.width * 0.32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF4FACFE), Color(0xFF8E44AD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(Icons.person_outline,
                    size: size.width * 0.18, color: Colors.white),
              ),
            ),

            SizedBox(height: size.height * 0.02),

            _buildTextField("First Name", firstNameController, size),
            _buildTextField("Last Name", lastNameController, size),
            _buildTextField("Username", usernameController, size),
            _buildTextField("Email", emailController, size),
            _buildPhoneField(size),
            _buildDatePicker(context, size),
            _buildGenderDropdown(size),
            SizedBox(height: size.height * 0.03),

            /// 💾 Save
            _buildButton(
              text: "Save",
              icon: Icons.save,
              onTap: () {
                Navigator.pop(context, {
                  "firstName": firstNameController.text.trim(),
                  "lastName": lastNameController.text.trim(),
                  "username": usernameController.text.trim(),
                  "email": emailController.text.trim(),
                  "phone": phoneController.text.trim(),
                  "gender": gender ?? "",
                  "birthDate": birthDate == null
                      ? ""
                      : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}",
                });
              },
              size: size,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, Size size) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.025),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.black26)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.blue)),
        ),
      ),
    );
  }

  Widget _buildPhoneField(Size size) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.025),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (country) {
                  setState(() {
                    countryCode = country.phoneCode;
                    countryFlag = country.flagEmoji;
                  });
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(countryFlag,
                      style: TextStyle(fontSize: size.width * 0.045)),
                  SizedBox(width: size.width * 0.015),
                  Text("+$countryCode",
                      style: TextStyle(fontSize: size.width * 0.04)),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.black26)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.blue)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.025),
      child: TextField(
        readOnly: true,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: birthDate ?? DateTime(2000),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );

          if (picked != null) setState(() => birthDate = picked);
        },
        decoration: InputDecoration(
          labelText: "Birth",
          hintText: birthDate == null
              ? ""
              : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}",
          suffixIcon: const Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(Size size) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.025),
      child: DropdownButtonFormField<String>(
        initialValue: gender,
        hint: const Text("Gender"),
        items: const [
          DropdownMenuItem(value: "Male", child: Text("Male")),
          DropdownMenuItem(value: "Female", child: Text("Female")),
        ],
        onChanged: (value) {
          setState(() => gender = value);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    required Size size,
  }) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.07,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: size.width * 0.06),
        label: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: size.width * 0.045)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E3A5D),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
