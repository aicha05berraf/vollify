import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:vollify/controllers/organization_controller.dart';
import 'package:vollify/services/auth_service.dart';
import 'package:vollify/controllers/user_controller.dart';
//import 'package:vollify/models/volunteer_model.dart';
//import 'package:vollify/models/organization_model.dart';
//import 'package:vollify/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final userModel = await AuthService().signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      //print('userModel role: ${userModel.role}');
      String role = userModel.role;

      final userController = Get.find<UserController>();
      // ignore: unused_local_variable
      final orgUser = User;
      userController.setUser(userModel);
      //UserModel orgUser = OrganizationModel as UserModel;

      /*final box = GetStorage();
      box.write('user_id', userModel.id);
      box.write('role', userModel.role);
      */

      /*String role;
      if (userModel is VolunteerModel) {
        role = 'volunteer';
      } else if (userModel is OrganizationModel) {
        role = 'organization';
      } else {
        throw Exception('Unknown user role');
      }
*/
      if (role == 'volunteer') {
        Get.offAllNamed('/volunteerHome');
      } else if (role == 'organization') {
        //Get.find<UserController>().user.value = orgUser;
        Get.offAllNamed('/organizationHome');
        //Get.find<UserController>().user.value = orgUser;
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed('/userType');
          },
        ),
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
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
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(onPressed: _login, child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
