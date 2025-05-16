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
      appBar: AppBar(title: Text('Post Opportunity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Domain Field
              TextFormField(
                controller: _domainController,
                decoration: InputDecoration(labelText: 'Domain'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the domain';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Number of Volunteers Required Field
              TextFormField(
                controller: _volunteersRequiredController,
                decoration: InputDecoration(
                  labelText: 'Number of Volunteers Required',
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
              SizedBox(height: 16),

              // Skills Required Field
              TextFormField(
                controller: _skillsRequiredController,
                decoration: InputDecoration(labelText: 'Skills Required'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the required skills';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Location Field
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

              // Email Field
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

              // Phone Number Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
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
              SizedBox(height: 32),

              // Post Opportunity Button
              ElevatedButton(
                onPressed: _postOpportunity,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Post Opportunity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
