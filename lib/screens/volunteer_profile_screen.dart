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
        title: const Text('Volunteer Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Obx(() {
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

                  // Volunteer Name
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Skills
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('Skills'),
                    subtitle: Text(user.skills?.join(', ') ?? ''),
                  ),

                  // Experience
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: const Text('Experience'),
                    subtitle: Text(user.experience ?? ''),
                  ),

                  // Phone Number
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone Number'),
                    subtitle: Text(user.phoneNumber ?? ''),
                  ),

                  // Edit Profile Button
                  ElevatedButton(
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
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            );
          },
        );
      }),
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
  // ignore: unused_field
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
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
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
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
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
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
