// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vollify/controllers/user_controller.dart';
import 'dart:io';

class VolunteerProfileScreen extends StatelessWidget {
  const VolunteerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF20331B), // Match Home screen
        title: const Text(
          'Volunteer Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Back arrow icon color
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white), // Settings icon color
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white, 
        child: Obx(() {
          final user = userController.user.value;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return FutureBuilder(
            future: userController.fetchUserById(user.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          user.imageUrl != null && user.imageUrl!.isNotEmpty
                              ? NetworkImage(user.imageUrl!)
                              : const AssetImage('assets/profile_placeholder.png')
                                  as ImageProvider,
                    ),
                    const SizedBox(height: 16),

                    // Volunteer Name (clear, bold, dark)
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF20331B), // Dark green for clarity
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // Email (clear, regular, dark)
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF354C2B), // Forest green for clarity
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Skills
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF354C2B), width: 1.2),
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.85),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.star, color: Color(0xFF4E653D)),
                        title: const Text('Skills', style: TextStyle(color: Color(0xFF354C2B))),
                        subtitle: Text(
                          user.skills?.join(', ') ?? '',
                          style: const TextStyle(color: Color(0xFF354C2B)),
                        ),
                      ),
                    ),

                    // Experience
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF354C2B), width: 1.2),
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.85),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.work, color: Color(0xFF4E653D)),
                        title: const Text('Experience', style: TextStyle(color: Color(0xFF354C2B))),
                        subtitle: Text(
                          user.experience ?? '',
                          style: const TextStyle(color: Color(0xFF354C2B)),
                        ),
                      ),
                    ),

                    // Phone Number
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF354C2B), width: 1.2),
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.85),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.phone, color: Color(0xFF4E653D)),
                        title: const Text('Phone Number', style: TextStyle(color: Color(0xFF354C2B))),
                        subtitle: Text(
                          user.phoneNumber ?? '',
                          style: const TextStyle(color: Color(0xFF354C2B)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditVolunteerProfileScreen(
                                name: user.name,
                                email: user.email,
                                skills: user.skills?.join(', ') ?? '',
                                experience: user.experience ?? '',
                                phone: user.phoneNumber ?? '',
                                imagePath: user.imageUrl,
                              ),
                            ),
                          );
                          await userController.fetchUserById(user.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF20331B), // Match AppBar
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white, // Button text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class EditVolunteerProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String skills;
  final String experience;
  final String phone;
  final String? imagePath;

  const EditVolunteerProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.skills,
    required this.experience,
    required this.phone,
    this.imagePath,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditVolunteerProfileScreenState createState() =>
      _EditVolunteerProfileScreenState();
}

class _EditVolunteerProfileScreenState
    extends State<EditVolunteerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _skillsController;
  late TextEditingController _experienceController;
  late TextEditingController _phoneController;

  final supabase = Supabase.instance.client;
  File? _profileImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _skillsController = TextEditingController(text: widget.skills);
    _experienceController = TextEditingController(text: widget.experience);
    _phoneController = TextEditingController(text: widget.phone);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color(0xFF20331B), // Match ProfilePage/HomeScreen
      title: const Text(
        'Edit Profile',
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white), // Back arrow icon color
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
      ),
      body: Container(
      color: Colors.white, // Ensure background matches Profile Page
      child: _isSaving
        ? const Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
            children: [
              Center(
              child: Stack(
                children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : (widget.imagePath != null
                      ? NetworkImage(widget.imagePath!)
                      : const AssetImage('assets/profile_placeholder.png')
                        as ImageProvider),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                    Icons.edit,
                    color: Color(0xFF697E50), // Profile image change icon color
                    size: 24,
                    ),
                  ),
                  ),
                ),
                ],
              ),
              ),
              const SizedBox(height: 16),
              TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                return 'Please enter your name';
                }
                return null;
              },
              ),
              const SizedBox(height: 16),
              TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
                }
                return null;
              },
              ),
              const SizedBox(height: 16),
              TextFormField(
              controller: _skillsController,
              decoration: const InputDecoration(
                labelText: 'Skills (comma separated)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                return 'Please enter your skills';
                }
                return null;
              },
              ),
              const SizedBox(height: 16),
              TextFormField(
              controller: _experienceController,
              decoration: const InputDecoration(labelText: 'Experience'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                return 'Please enter your experience';
                }
                return null;
              },
              ),
              const SizedBox(height: 16),
              TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
                }
                if (!RegExp(r'^\d+$').hasMatch(value)) {
                return 'Please enter a valid phone number';
                }
                return null;
              },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                try {
                  setState(() => _isSaving = true);
                  final userController = Get.find<UserController>();
                  String? imageUrl = userController.user.value?.imageUrl;

                  // Handle image upload
                  if (_profileImage != null) {
                  final fileExt = _profileImage!.path.split('.').last;
                  final fileName =
                    'vol_${userController.user.value!.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

                  await supabase.storage
                    .from('profileimage')
                    .upload(fileName, _profileImage!);

                  imageUrl = supabase.storage
                    .from('profileimage')
                    .getPublicUrl(fileName);
                  }

                  // Prepare updates
                  final nameParts = _nameController.text.trim().split(' ');
                  final updates = {
                  'email': _emailController.text.trim(),
                  'phone_number': _phoneController.text.trim(),
                  'first_name': nameParts.first,
                  'last_name':
                    nameParts.length > 1
                      ? nameParts.sublist(1).join(' ')
                      : '',
                  'skills':
                    _skillsController.text
                      .split(',')
                      .map((s) => s.trim())
                      .toList(),
                  'experience': _experienceController.text.trim(),
                  if (imageUrl != null) 'profile_image': imageUrl,
                  'updated_at': DateTime.now().toIso8601String(),
                  };

                  final response = await supabase.from('users').upsert({
                  'id': userController.user.value!.id,
                  'role': 'volunteer',
                  ...updates,
                  });

                  if (response.error != null) throw response.error!;

                  // Update controller and go back
                  await userController.fetchUserById(
                  userController.user.value!.id,
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                } finally {
                  setState(() => _isSaving = false);
                }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF20331B), // Match AppBar
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                color: Colors.white, // Button text color
                fontWeight: FontWeight.bold,
                ),
              ),
              ),
            ],
            ),
          ),
          ),
      ),
    );
  }
}
