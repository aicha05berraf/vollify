// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';

class OpportunityService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchOpportunities() async {
    final response = await supabase.from('opportunities').select();

    if (response.isEmpty) {
      return [];
    }

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchOpportunitiesByOrganization(
    String organizationId,
  ) async {
    final data = await supabase
        .from('opportunities')
        .select()
        .eq('organization_id', organizationId);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> createOpportunity(Map<String, dynamic> data) async {
    await supabase.from('opportunities').insert(data);
  }

  Future<void> updateOpportunity(int id, Map<String, dynamic> data) async {
    await supabase.from('opportunities').update(data).eq('id', id);
  }

  Future<void> deleteOpportunity(int id) async {
    await supabase.from('opportunities').delete().eq('id', id);
  }

  Future<bool> applyToOpportunity(
    String opportunityId,
    String volunteerId,
  ) async {
    try {
      // Check for existing application
      final existing = await supabase
          .from('applications')
          .select()
          .eq('opportunity_id', opportunityId)
          .eq('volunteer_id', volunteerId);

      print('🔍 Existing applications: $existing');

      if (existing.isNotEmpty) {
        print('⚠️ Already applied.');
        return false;
      }

      // 👇 Fetch the opportunity to get its organization_id
      final opportunity =
          await supabase
              .from('opportunities')
              .select('organization_id')
              .eq('id', opportunityId)
              .single();

      final orgId = opportunity['organization_id'];
      print('🏢 Found organization_id: $orgId');

      // ❗ Check if orgId is null
      if (orgId == null) {
        print('🚨 organization_id is null! Cannot apply.');
        return false;
      }

      // ✅ Insert with organization_id
      final response = await supabase.from('applications').insert({
        'opportunity_id': opportunityId,
        'volunteer_id': volunteerId,
        'organization_id': orgId, // 👈 THIS FIXES EVERYTHING
        'status': 'pending',
      });

      print('✅ Insert response: $response');

      return true;
    } catch (e) {
      print('❌ Error applying: $e');
      return false;
    }
  }
}
