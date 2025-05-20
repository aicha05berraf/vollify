import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vollify/models/user_model.dart';

class UserService {
  final _client = Supabase.instance.client;

  Future<UserModel> getUserById(String userId) async {
    try {
      final data =
          await _client.from('users').select().eq('id', userId).single();
      return UserModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }


  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      await _client.from('users').insert(userData);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> createVolunteer(Map<String, dynamic> volunteerData) async {
    try {
      await _client.from('users').insert(volunteerData);
    } catch (e) {
      throw Exception('Failed to create volunteer: $e');
    }
  }

  Future<void> createOrganization(Map<String, dynamic> organizationData) async {
    try {
      await _client.from('users').insert(organizationData);
    } catch (e) {
      throw Exception('Failed to create organization: $e');
    }
  }
}


