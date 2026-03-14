import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  String firstName = "First";
  String lastName = "Last";
  String username = "username";
  String email = "username@gmail.com";
  String phone = "";
  String gender = "";
  String birthDate = "";

  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();

    _loadSavedProfile();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ================= LOAD =================
  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      firstName = prefs.getString('firstName') ?? firstName;
      lastName = prefs.getString('lastName') ?? lastName;
      email = prefs.getString('email') ?? email;
      phone = prefs.getString('phone') ?? phone;
      gender = prefs.getString('gender') ?? gender;
      birthDate = prefs.getString('birthDate') ?? birthDate;

      final imagePath = prefs.getString('profileImage');
      if (imagePath != null && File(imagePath).existsSync()) {
        profileImage = File(imagePath);
      }
    });
  }

  // ================= SAVE =================
  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('gender', gender);
    await prefs.setString('birthDate', birthDate);
  }

  /// 📷 Pick image
  Future<void> _pickProfileImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', picked.path);

      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  // ================= LOGOUT =================
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
          )
        ],
      ),
      body: FadeTransition(
        opacity: _fadeController,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.06),
          child: Column(
            children: [
              /// PROFILE IMAGE
              Stack(
                children: [
                  CircleAvatar(
                    radius: size.width * 0.14,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        profileImage != null ? FileImage(profileImage!) : null,
                    child: profileImage == null
                        ? Icon(Icons.person_outline,
                            size: size.width * 0.14,
                            color: Colors.grey.shade600)
                        : null,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickProfileImage,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF17B978),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                "$firstName $lastName",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(email, style: const TextStyle(color: Colors.grey)),

              if (phone.isNotEmpty)
                Text(phone, style: const TextStyle(color: Colors.grey)),

              if (gender.isNotEmpty)
                Text("Gender: $gender",
                    style: const TextStyle(color: Colors.grey)),

              if (birthDate.isNotEmpty)
                Text("Birth: $birthDate",
                    style: const TextStyle(color: Colors.grey)),

              const SizedBox(height: 24),

              /// EDIT PROFILE
              SizedBox(
                width: size.width * 0.45,
                height: size.height * 0.055,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF054208),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                          firstName: firstName,
                          lastName: lastName,
                          username: username,
                          email: email,
                          phone: phone,
                          gender: gender,
                          birthDate: birthDate,
                        ),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        firstName = result['firstName'];
                        lastName = result['lastName'];
                        username = result['username'];
                        email = result['email'];
                        phone = result['phone'];
                        gender = result['gender'];
                        birthDate = result['birthDate'];
                      });

                      await _saveProfileData();
                    }
                  },
                  child: const Text("Edit Profile"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
