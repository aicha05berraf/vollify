

// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:vollify/models/user_model.dart';
import 'package:vollify/models/volunteer_model.dart';
import 'package:vollify/models/organization_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UserController extends GetxController {
  

  Rxn<UserModel> user =
      Rxn<
        UserModel
      >(); 

  void setUser(UserModel newUser) {
    user.value = newUser;
  }

  void clearUser() {
    user.value = null;
  }

  bool get isVolunteer => user.value is VolunteerModel;
  bool get isOrganization => user.value is OrganizationModel;

  Future<void> fetchUser(Map<String, dynamic> updates) async {
    try {
      final supabase = Supabase.instance.client;

      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final userData =
          await supabase
              .from('users')
              .upsert({'id': currentUser.id, 'role': 'volunteer', ...updates})
              .select()
              .single();

      user.value = UserModel.fromJson(userData);
    } catch (e) {
      print('😵 Error fetching user: $e');
      rethrow;
    }
  }

  Future<UserModel> fetchUserById(String id) async {
    final data = await supabase.from('users').select().eq('id', id).single();
    final model = UserModel.fromJson(data);
    user.value = model;
    return model;
  }

  Future<void> uploadVolunteerData({
    required String name,
    required String phone,
    required String skills,
    required String experience,
    required String? imageUrl,
    required Map<String, dynamic> updates,
  }) async {
    final userId = user.value?.id;
    if (userId == null) throw 'No user ID found';

    
    final response = await supabase
        .from('users')
        .update(updates)
        .eq('id', userId);

    if (response == null || response.error != null) {
      print('❌ Error updating user: ${response.error?.message}');
      return;
    }

    
    await fetchUserById(userId);
  }
}

final supabase = Supabase.instance.client;


