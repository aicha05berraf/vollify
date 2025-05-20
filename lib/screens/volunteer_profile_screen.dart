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
        backgroundColor: const Color(0xFF20331B), 
        title: const Text(
          'Volunteer Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), 
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ), 
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
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final user = snapshot.data;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    
                    CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          user?.imageUrl != null && user!.imageUrl!.isNotEmpty
                              ? NetworkImage(user.imageUrl!)
                              : const AssetImage(
                                    'assets/profile_placeholder.png',
                                  )
                                  as ImageProvider,
                    ),
                    const SizedBox(height: 16),

                    
                    Text(
                      user!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF20331B), 
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF354C2B), 
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF354C2B),
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.85),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(
                          Icons.star,
                          color: Color(0xFF4E653D),
                        ),
                        title: const Text(
                          'Skills',
                          style: TextStyle(color: Color(0xFF354C2B)),
                        ),
                        subtitle: Text(
                          user.skills?.join(', ') ?? '',
                          style: const TextStyle(color: Color(0xFF354C2B)),
                        ),
                      ),
                    ),

                    
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF354C2B),
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.85),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(
                          Icons.work,
                          color: Color(0xFF4E653D),
                        ),
                        title: const Text(
                          'Experience',
                          style: TextStyle(color: Color(0xFF354C2B)),
                        ),
                        subtitle: Text(
                          user.experience ?? '',
                          style: const TextStyle(color: Color(0xFF354C2B)),
                        ),
                      ),
                    ),

                    
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF354C2B),
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.85),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(
                          Icons.phone,
                          color: Color(0xFF4E653D),
                        ),
                        title: const Text(
                          'Phone Number',
                          style: TextStyle(color: Color(0xFF354C2B)),
                        ),
                        subtitle: Text(
                          user.phoneNumber ?? '',
                          style: const TextStyle(color: Color(0xFF354C2B)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditVolunteerProfileScreen(
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
                          backgroundColor: const Color(
                            0xFF20331B,
                          ), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white, 
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
        backgroundColor: const Color(
          0xFF20331B,
        ), 
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), 
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white, 
        child:
            _isSaving
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
                                backgroundImage:
                                    _profileImage != null
                                        ? FileImage(_profileImage!)
                                        : (widget.imagePath != null
                                            ? NetworkImage(widget.imagePath!)
                                            : const AssetImage(
                                                  'assets/profile_placeholder.png',
                                                )
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
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Color(
                                        0xFF697E50,
                                      ), 
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
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
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
                          decoration: const InputDecoration(
                            labelText: 'Experience',
                          ),
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
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                          ),
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
                                final userController =
                                    Get.find<UserController>();
                                String? imageUrl =
                                    userController.user.value?.imageUrl;

                                
                                if (_profileImage != null) {
                                  final fileExt =
                                      _profileImage!.path.split('.').last;
                                  final fileName =
                                      'vol_${userController.user.value!.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

                                  await supabase.storage
                                      .from('profileimage')
                                      .upload(fileName, _profileImage!);

                                  imageUrl = supabase.storage
                                      .from('profileimage')
                                      .getPublicUrl(fileName);
                                }

                                
                                final nameParts = _nameController.text
                                    .trim()
                                    .split(' ');
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
                                  'experience':
                                      _experienceController.text.trim(),
                                  if (imageUrl != null)
                                    'profile_image': imageUrl,
                                  'updated_at':
                                      DateTime.now().toIso8601String(),
                                };
                                
                                final upserted =
                                    await supabase.from('users').upsert({
                                      'id': userController.user.value!.id,
                                      'role': 'volunteer',
                                      ...updates,
                                    }).select();
                                
                                if (upserted.isEmpty) {
                                  throw Exception(
                                    'Nothing was updated - upsert returned empty list.',
                                  );
                                }

                                
                                await userController.fetchUserById(
                                  userController.user.value!.id,
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                  ),
                                );
                              } finally {
                                setState(() => _isSaving = false);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF20331B,
                            ), 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white, 
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
