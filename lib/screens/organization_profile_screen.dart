// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vollify/controllers/organization_controller.dart';
import 'package:vollify/controllers/user_controller.dart';
import 'package:vollify/services/opportunity_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OrganizationProfileScreen extends StatelessWidget {
  const OrganizationProfileScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url.startsWith('http') ? url : 'https://$url');
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildSocialMediaLinks(String links) {
    if (links.isEmpty) return const SizedBox();
    final uriList =
        links
            .split(',')
            .map((link) => link.trim())
            .where((link) => link.isNotEmpty)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          uriList.map((link) {
            return GestureDetector(
              onTap: () => _launchUrl(link),
              child: Text(
                link,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orgController = Get.put(OrganizationController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF20331B), // Match Home screen
        title: const Text(
          'Organization Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Back arrow icon color
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white), // Settings icon color
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final name = orgController.name.value;
        final email = orgController.email.value;
        final location = orgController.location.value;
        final socialMedia = orgController.socialMedia.value;
        final contact = orgController.contact.value;
        final imagePath = orgController.imageUrl.value;

        return FutureBuilder(
          future: orgController.fetchOrganizationData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: OpportunityService().fetchOpportunitiesByOrganization(
                orgController.id.value,
              ),
              builder: (context, snapshot) {
                final opportunities = snapshot.data ?? [];

                return Container(
                  color: Colors.white, // Ensure white background
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile Picture
                        Center(
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: imagePath.isNotEmpty
                                ? NetworkImage(imagePath)
                                : const AssetImage('assets/profile_placeholder.png')
                                    as ImageProvider,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Organization Name
                        Center(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF20331B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Email
                        Center(
                          child: Text(
                            email,
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Location
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF354C2B), width: 1.2),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.location_on, color: Color(0xFF4E653D)),
                            title: const Text('Location', style: TextStyle(color: Color(0xFF354C2B))),
                            subtitle: Text(location, style: const TextStyle(color: Color(0xFF354C2B))),
                          ),
                        ),

                        // Social Media Links
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF354C2B), width: 1.2),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.link, color: Color(0xFF4E653D)),
                            title: const Text('Social Media Links', style: TextStyle(color: Color(0xFF354C2B))),
                            subtitle: _buildSocialMediaLinks(
                              socialMedia,
                            ),
                          ),
                        ),

                        // Contact Number
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF354C2B), width: 1.2),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.phone, color: Color(0xFF4E653D)),
                            title: const Text('Contact Number', style: TextStyle(color: Color(0xFF354C2B))),
                            subtitle: Text(contact, style: const TextStyle(color: Color(0xFF354C2B))),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Opportunities Posted Section
                        const Text(
                          'Opportunities Posted',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF20331B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (opportunities.isEmpty)
                          const Text(
                            'No opportunities posted yet.',
                            style: TextStyle(color: Color(0xFF354C2B)),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: opportunities.length,
                            itemBuilder: (context, index) {
                              final opportunity = opportunities[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                elevation: 2,
                                color: const Color(0xFFC3CA92), // Card background for opportunities
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.event,
                                    color: Color(0xFF4E653D),
                                  ),
                                  title: Text(
                                    opportunity['title'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF20331B),
                                    ),
                                  ),
                                  subtitle: Text(
                                    opportunity['description'] ?? '',
                                    style: const TextStyle(color: Color(0xFF354C2B)),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Color(0xFF4E653D),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        final Color iconColor = const Color(0xFF697E50);
                                        final Color bgColor = const Color(0xFFE5EAD2); // lighter shade of #C3CA92
                                        return Dialog(
                                          backgroundColor: bgColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Title
                                                  Row(
                                                    children: [
                                                      Icon(Icons.event, color: iconColor),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          opportunity['title'] ?? 'Opportunity Details',
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                            color: Color(0xFF20331B),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                  // Description
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons.description, color: iconColor),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          opportunity['description'] ?? '',
                                                          style: const TextStyle(fontSize: 16),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 14),
                                                  // Domain
                                                  if (opportunity['domain'] != null) ...[
                                                    Row(
                                                      children: [
                                                        Icon(Icons.category, color: iconColor),
                                                        const SizedBox(width: 8),
                                                        Expanded(
                                                          child: Text(
                                                            'Domain: ${opportunity['domain']}',
                                                            style: const TextStyle(fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 14),
                                                  ],
                                                  // Volunteers Required
                                                  if (opportunity['volunteers_required'] != null) ...[
                                                    Row(
                                                      children: [
                                                        Icon(Icons.people, color: iconColor),
                                                        const SizedBox(width: 8),
                                                        Expanded(
                                                          child: Text(
                                                            'Volunteers Required: ${opportunity['volunteers_required']}',
                                                            style: const TextStyle(fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 14),
                                                  ],
                                                  // Skills Required
                                                  if (opportunity['skills_required'] != null) ...[
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Icon(Icons.build, color: iconColor),
                                                        const SizedBox(width: 8),
                                                        Expanded(
                                                          child: Text(
                                                            'Skills Required: ${opportunity['skills_required']}',
                                                            style: const TextStyle(fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 14),
                                                  ],
                                                  // Location
                                                  if (opportunity['location'] != null) ...[
                                                    Row(
                                                      children: [
                                                        Icon(Icons.location_on, color: iconColor),
                                                        const SizedBox(width: 8),
                                                        Expanded(
                                                          child: Text(
                                                            'Location: ${opportunity['location']}',
                                                            style: const TextStyle(fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 20),
                                                  ],
                                                  // Close button
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: iconColor,
                                                        foregroundColor: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                                      ),
                                                      onPressed: () => Navigator.of(context).pop(),
                                                      child: const Text(
                                                        'Close',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                        const SizedBox(height: 32),

                        // Edit Profile Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditOrganizationProfileScreen(
                                    name: name,
                                    email: email,
                                    location: location,
                                    socialMedia: socialMedia,
                                    contact: contact,
                                    imagePath: imagePath,
                                  ),
                                ),
                              );
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
                  ),
                );
              },
            );
          },
        );
      }),
      backgroundColor: Colors.white, // Match signup page background
    );
  }

}

class EditOrganizationProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String location;
  final String socialMedia;
  final String contact;
  final String? imagePath;

  const EditOrganizationProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.location,
    required this.socialMedia,
    required this.contact,
    this.imagePath,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditOrganizationProfileScreenState createState() =>
      _EditOrganizationProfileScreenState();
}

class _EditOrganizationProfileScreenState
    extends State<EditOrganizationProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;
  late TextEditingController _socialMediaController;
  late TextEditingController _contactNumberController;

  // ignore: unused_field
  bool _isSaving = false;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _locationController = TextEditingController(text: widget.location);
    _socialMediaController = TextEditingController(text: widget.socialMedia);
    _contactNumberController = TextEditingController(text: widget.contact);
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
        child: Padding(
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
                  decoration: const InputDecoration(labelText: 'Organization Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the organization name';
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
                      return 'Please enter the email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _socialMediaController,
                  decoration: const InputDecoration(labelText: 'Social Media Links'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the social media links';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactNumberController,
                  decoration: const InputDecoration(labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the contact number';
                    }
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Please enter a valid contact number';
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
                        final orgController = Get.find<OrganizationController>();

                        String? imageUrl = orgController.imageUrl.value;
                        if (_profileImage != null) {
                          final fileExt = _profileImage!.path.split('.').last;
                          final fileName =
                              'org_${orgController.id.value}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

                          await supabase.storage
                              .from('profileimage')
                              .upload(fileName, _profileImage!);

                          imageUrl = supabase.storage
                              .from('profileimage')
                              .getPublicUrl(fileName);
                        }

                        final updates = {
                          'email': _emailController.text.trim(),
                          'phone_number': _contactNumberController.text.trim(),
                          'org_name': _nameController.text.trim(),
                          'location': _locationController.text.trim(),
                          'social_media_links':
                              _socialMediaController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList(),
                          'contact_number': _contactNumberController.text.trim(),
                          'profile_image': imageUrl,
                          'updated_at': DateTime.now().toIso8601String(),
                        };

                        await orgController.uploadOrganizationData(
                          name: _nameController.text.trim(),
                          location: _locationController.text.trim(),
                          contact: _contactNumberController.text.trim(),
                          socialMediaLinks: _socialMediaController.text.trim(),
                          imageUrl: imageUrl,
                          updates: updates,
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        print('❌ Error updating profile: $e');
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
