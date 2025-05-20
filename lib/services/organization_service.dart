import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vollify/controllers/user_controller.dart';

class OrganizationService {
  final _client = Supabase.instance.client;

  Future<void> createOrganization(Map<String, dynamic> organizationData) async {
    try {
      await _client.from('organizations').insert(organizationData);
    } catch (e) {
      throw Exception('Failed to create organization: $e');
    }
  }

  Future<Map<String, dynamic>> getOrganizationById(String id) async {
    try {
      final response =
          await _client.from('organizations').select().eq('id', id).single();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch organization: $e');
    }
  }

  Future<void> updateOrganization(String id, Map<String, dynamic> data) async {
    final response = await supabase.from('organizations').upsert({
      'id': id,
      ...data,
    });

    if (response.error != null) {
      throw response.error!;
    }
  }
}
