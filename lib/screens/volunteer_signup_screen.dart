import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vollify/services/auth_service.dart';

class VolunteerSignupScreen extends StatefulWidget {
  const VolunteerSignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VolunteerSignupScreenState createState() => _VolunteerSignupScreenState();
}

class _VolunteerSignupScreenState extends State<VolunteerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signUpVolunteer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await AuthService().signUpVolunteer(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        skills: _skillsController.text.trim(),
        experience: _experienceController.text.trim(),
      );

      Get.snackbar(
        'Signup Successful',
        'Welcome ${_firstNameController.text.trim()}!',
        backgroundColor: Colors.green[700],
        colorText: Colors.white,
      );

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

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Color(0xFF20331B)),
      filled: true,
      // ignore: deprecated_member_use
      fillColor: Colors.white.withOpacity(0.9),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Signup'),
        backgroundColor: const Color(0xFF20331B),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFC3CA92), Color(0xFF20331B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: _firstNameController,
                  decoration: _buildInputDecoration('First Name', Icons.person),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your first name'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: _buildInputDecoration(
                    'Last Name',
                    Icons.person_outline,
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your last name'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: _buildInputDecoration('Email', Icons.email),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _skillsController,
                  decoration: _buildInputDecoration('Skills', Icons.star),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your skills'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _experienceController,
                  decoration: _buildInputDecoration('Experience', Icons.work),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your experience'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: _buildInputDecoration(
                    'Phone Number',
                    Icons.phone,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      // ignore: curly_braces_in_flow_control_structures
                      return 'Please enter your phone number';
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: _buildInputDecoration('Password', Icons.lock),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: _buildInputDecoration(
                    'Confirm Password',
                    Icons.lock_outline,
                  ),
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
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUpVolunteer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF20331B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
