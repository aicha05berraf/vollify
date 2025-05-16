import 'package:supabase_flutter/supabase_flutter.dart';

class VolunteerService {
  final _client = Supabase.instance.client;

  Future<void> createVolunteer(Map<String, dynamic> volunteerData) async {
    try {
      await _client.from('volunteers').insert(volunteerData);
    } catch (e) {
      throw Exception('Failed to create volunteer: $e');
    }
  }

  Future<Map<String, dynamic>> getVolunteerById(String id) async {
    try {
      final response =
          await _client.from('volunteers').select().eq('id', id).single();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch volunteer: $e');
    }
  }

  Future<void> updateVolunteer(String id, Map<String, dynamic> data) async {
    try {
      await _client.from('volunteers').update(data).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update volunteer: $e');
    }
  }
}
