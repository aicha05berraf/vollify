// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicationService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchApplicationsByUser(
    String userId,
  ) async {
    final data = await supabase
        .from('applications')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> fetchApplicationsByOpportunity(
    String opportunityId,
  ) async {
    final data = await supabase
        .from('applications')
        .select()
        .eq('opportunity_id', opportunityId);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> applyToOpportunity(Map<String, dynamic> data) async {
    await supabase.from('applications').insert(data);
  }

  Future<void> updateApplicationStatus(String id, String status) async {
    await supabase.from('applications').update({'status': status}).eq('id', id);
  }

  Future<List<Map<String, dynamic>>> fetchApplicationsForOrganization(
    String orgId,
  ) async {
    if (orgId.isEmpty) {
      print('❌ orgId is empty!');
      return [];
    }

    print('Fetching applications for orgId: $orgId');

    final opportunityResponse = await supabase
        .from('opportunities')
        .select('id')
        .eq('organization_id', orgId);

    print('🎯 Fetched opportunity IDs: $opportunityResponse');

    final opportunityIds =
        opportunityResponse
            .map((o) => o['id'] as String?)
            .whereType<String>()
            .toList();

    if (opportunityIds.isEmpty) {
      print('😶 No matching opportunities found for this org.');
      return [];
    }

    final data = await supabase
        .from('applications')
        .select('''
         id,
         volunteer_id,
         opportunity_id,
         organization_id,
         status,
        users!volunteer_id (
          first_name,
          last_name,
          skills
        ),
        opportunities!opportunity_id (
          title,
          organization_id
        )
      ''')
        .inFilter('opportunity_id', opportunityIds);

    print('📦 Applications fetched: $data');

    return List<Map<String, dynamic>>.from(data)
        .map(
          (app) => {
            'id': app['id'],
            'user_id': app['user_id'],
            'opportunity_id': app['opportunity_id'],
            'volunteer_id': app['volunteer_id'],
            'status': app['status'],
            'volunteer_name':
                '${app['users']?['first_name'] ?? ''} ${app['users']?['last_name'] ?? ''}',
            'skills': app['users']?['skills'] ?? '',
            'opportunity_title': app['opportunities']?['title'] ?? '',
            'organization_id': app['organization_id'],
          },
        )
        .toList();
  }
}
