//import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:vollify/controllers/user_controller.dart';
import 'package:vollify/models/user_model.dart';
import 'package:vollify/services/user_service.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  final UserService userService = UserService();

  Future<UserModel?> signUpVolunteer({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required List<String> skills,
    required String experience,
    String? profileImage,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception('Sign up failed ❌');

    await supabase.from('users').insert({
      'id': user.id,
      'email': email,
      'role': 'volunteer',
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'skills': skills,
      'experience': experience,
      'profile_image': profileImage,
    });

    //print('User ID: ${user.id}');

    final userData =
        await supabase.from('users').select().eq('id', user.id).single();
    return UserModel.fromJson(userData);
  }

  Future<UserModel?> signUpOrganization({
    required String email,
    required String password,
    required String orgName,
    required String location,
    required List<String> socialMediaLinks,
    required String contactNumber,
    String? profileImage,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception('Sign up failed ❌');

    await supabase.from('users').insert({
      'id': user.id,
      'email': email,
      'role': 'organization',
      'org_name': orgName,
      'location': location,
      'social_media_links': socialMediaLinks,
      'contact_number': contactNumber,
      'profile_image': profileImage,
    });

    final userData =
        await supabase.from('users').select().eq('id', user.id).single();
    return UserModel.fromJson(userData);
  }

  Future<UserModel> signIn(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) throw Exception('Sign in failed ❌');

    final userData =
        await supabase.from('users').select().eq('id', user.id).single();
    return UserModel.fromJson(userData);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<UserModel> fetchUserDetails(String userId) async {
    final userData =
        await supabase.from('users').select().eq('id', userId).single();
    return UserModel.fromJson(userData);
  }
}
