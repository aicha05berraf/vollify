// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get.dart';
import 'package:vollify/services/opportunity_service.dart';
import 'package:vollify/controllers/organization_controller.dart';

class PostOpportunityScreen extends StatefulWidget {
  const PostOpportunityScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostOpportunityScreenState createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends State<PostOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _volunteersRequiredController =
      TextEditingController();
  final TextEditingController _skillsRequiredController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  //final TextEditingController _nameController = TextEditingController();

  void _postOpportunity() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get organization ID from controller
        final orgController = Get.find<OrganizationController>();
        await orgController.fetchOrganizationData();
        final orgName = orgController.name.value;

        await OpportunityService().createOpportunity({
          'organization_name': orgName,
          'organization_id': orgController.id.value,
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'domain': _domainController.text.trim(),
          'volunteers_required': int.parse(_volunteersRequiredController.text),
          'skills_required': _skillsRequiredController.text.trim(),
          'location': _locationController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          //'date': DateTime.now().toIso8601String(), // or use a date picker
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opportunity Posted Successfully!')),
        );

        // Clear the form
        _formKey.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        _domainController.clear();
        _volunteersRequiredController.clear();
        _skillsRequiredController.clear();
        _locationController.clear();
        _emailController.clear();
        _phoneController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post opportunity: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF20331B), // Match HomeScreen
        title: const Text(
          'Post Opportunity',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white, // Simple white background like signup page
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Domain Field
                TextFormField(
                  controller: _domainController,
                  decoration: const InputDecoration(
                    labelText: 'Domain',
                    prefixIcon: Icon(Icons.category),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the domain';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Number of Volunteers Required Field
                TextFormField(
                  controller: _volunteersRequiredController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Volunteers Required',
                    prefixIcon: Icon(Icons.people),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of volunteers required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Skills Required Field
                TextFormField(
                  controller: _skillsRequiredController,
                  decoration: const InputDecoration(
                    labelText: 'Skills Required',
                    prefixIcon: Icon(Icons.build),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the required skills';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Location Field
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
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

                // Phone Number Field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Post Opportunity Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _postOpportunity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF20331B), // Match AppBar
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    child: const Text(
                      'Post Opportunity',
                      style: TextStyle(color: Colors.white), // Button text color
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
