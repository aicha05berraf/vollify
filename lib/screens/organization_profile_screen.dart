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
        title: Text('Organization Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
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
              return Center(child: CircularProgressIndicator());
            }

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: OpportunityService().fetchOpportunitiesByOrganization(
                orgController.id.value,
              ),
              builder: (context, snapshot) {
                final opportunities = snapshot.data ?? [];

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            imagePath.isNotEmpty
                                ? NetworkImage(imagePath)
                                : AssetImage('assets/profile_placeholder.png')
                                    as ImageProvider,
                      ),
                      SizedBox(height: 16),

                      // Organization Name
                      Text(
                        orgController.name.value,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Email
                      Text(
                        orgController.email.value,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),

                      // Location
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text('Location'),
                        subtitle: Text(orgController.location.value),
                      ),

                      // Social Media Links
                      ListTile(
                        leading: Icon(Icons.link),
                        title: Text('Social Media Links'),
                        subtitle: _buildSocialMediaLinks(
                          orgController.socialMedia.value,
                        ),
                      ),

                      // Contact Number
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Contact Number'),
                        subtitle: Text(orgController.contact.value),
                      ),

                      // Opportunities Posted
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Opportunities Posted',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: opportunities.length,
                          itemBuilder: (context, index) {
                            final opportunity = opportunities[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              elevation: 2,
                              child: ListTile(
                                leading: Icon(
                                  Icons.event,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text(
                                  opportunity['title'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  opportunity['description'] ?? '',
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap: () {
                                  _showOpportunityDetails(context, opportunity);
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      // Edit Profile Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditOrganizationProfileScreen(
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
                        child: Text('Edit Profile'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  void _showOpportunityDetails(
    BuildContext context,
    Map<String, dynamic> opportunity,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(opportunity['title'] ?? 'Opportunity Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Description
                if (opportunity['description'] != null) ...[
                  Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(opportunity['description']),
                  SizedBox(height: 12),
                ],

                // Domain
                if (opportunity['domain'] != null) ...[
                  Row(
                    children: [
                      Icon(Icons.category, size: 16),
                      SizedBox(width: 8),
                      Text('Domain: ${opportunity['domain']}'),
                    ],
                  ),
                  SizedBox(height: 8),
                ],

                // Volunteers Required
                if (opportunity['volunteers_required'] != null) ...[
                  Row(
                    children: [
                      Icon(Icons.people, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Volunteers Required: ${opportunity['volunteers_required']}',
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],

                // Skills Required
                if (opportunity['skills_required'] != null) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.build, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Skills Required: ${opportunity['skills_required']}',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],

                // Location
                if (opportunity['location'] != null) ...[
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 8),
                      Text('Location: ${opportunity['location']}'),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
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
      appBar: AppBar(title: Text('Edit Profile')),
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
                                  : AssetImage('assets/profile_placeholder.png')
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
                          padding: EdgeInsets.all(8),
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
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Organization Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the organization name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
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
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _socialMediaController,
                decoration: InputDecoration(labelText: 'Social Media Links'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the social media links';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contactNumberController,
                decoration: InputDecoration(labelText: 'Contact Number'),
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
              SizedBox(height: 32),
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
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
