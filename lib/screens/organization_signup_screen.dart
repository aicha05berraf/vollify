import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vollify/services/auth_service.dart';
//import 'package:vollify/services/user_service.dart';
//import 'package:vollify/services/organization_service.dart';
//import 'package:vollify/controllers/user_controller.dart';
//import 'package:vollify/models/user_model.dart';

class OrganizationSignupScreen extends StatefulWidget {
  const OrganizationSignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrganizationSignupScreenState createState() =>
      _OrganizationSignupScreenState();
}

class _OrganizationSignupScreenState extends State<OrganizationSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _socialMediaController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isLoading = false;
  final String? imageUrl = null; // Placeholder for image URL

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // 1. Create user in Supabase Auth
      await AuthService().signUpOrganization(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        orgName: _nameController.text.trim(),
        location: _locationController.text.trim(),
        socialMediaLinks: [_socialMediaController.text.trim()],
        contactNumber: _contactController.text.trim(),
      );
      /*
      final user = authResponse;
      if (user == null) throw Exception('Signup failed: No user returned.');

      final userId = user.id;

      // 2. Create user record in users table
      final userModel = UserModel(
        id: userId,
        email: _emailController.text.trim(),
        role: 'organization',
        createdAt: DateTime.now(),
      );
      //await UserService().createUser(userModel.toMap());

      // 3. Create organization record in organizations table
      /*await OrganizationService().createOrganization({
        'id': userId,
        'location': _locationController.text.trim(),
        'socialMedia': _socialMediaController.text.trim(),
      });
*/ */
      // 4. Set user in controller
      //Get.find<UserController>().setUser(userModel);
      Get.snackbar(
        'Signup Successful',
        'Welcome ${_nameController.text.trim()}',
        backgroundColor: Colors.green[700],
        colorText: Colors.white,
      );
      // 5. Navigate to organization home
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Signup Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Organization Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter the organization name'
                            : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
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
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter the location'
                            : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _socialMediaController,
                decoration: InputDecoration(labelText: 'Social Media Links'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter social media links'
                            : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Please enter a valid contact number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                child:
                    _isLoading ? CircularProgressIndicator() : Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
