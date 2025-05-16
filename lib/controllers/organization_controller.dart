//import 'dart:convert';

// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrganizationController extends GetxController {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  var name = ''.obs;
  var email = ''.obs;
  var location = ''.obs;
  var socialMedia = ''.obs;
  var contact = ''.obs;
  var imageUrl = ''.obs;
  var id = ''.obs;

  void setOrganization({
    required String name,
    required String email,
    required String location,
    required String socialMedia,
    required String contact,
    String? imageUrl,
    required String id,
  }) {
    this.name.value = name;
    this.email.value = email;
    this.location.value = location;
    this.socialMedia.value = socialMedia;
    this.contact.value = contact;
    this.imageUrl.value = imageUrl ?? '';
    this.id.value = id;
  }

  void clearOrganization() {
    name.value = '';
    email.value = '';
    location.value = '';
    socialMedia.value = '';
    contact.value = '';
    imageUrl.value = '';
    id.value = '';
  }

  Future<void> updateOrganization(
    String userId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      updatedData.removeWhere((key, value) => value == null);

      await supabase.from('users').update(updatedData).eq('id', userId);

      print('✅ Organization updated successfully!');
    } catch (e) {
      print('❌ Error updating organization: $e');
      rethrow;
    }
  }

  // Add this method to your OrganizationController
  Future<void> uploadOrganizationData({
    required String name,
    required String location,
    required String contact,
    required String socialMediaLinks,
    String? imageUrl,
    Map<String, dynamic>? updates,
  }) async {
    print(
      'Organization ID used for filtering: ${Get.find<OrganizationController>().id.value}',
    );
    final userId = id.value;
    final supabase = Supabase.instance.client;

    await supabase
        .from('users')
        .update(
          updates ??
              {
                'org_name': name,
                'location': location,
                'contact_number': contact,
                'social_media_links': socialMediaLinks.split(','),
                if (imageUrl != null) 'profile_image': imageUrl,
                'updated_at': DateTime.now().toIso8601String(),
              },
        )
        .eq('id', userId);

    // Refresh local observable data
    await fetchOrganizationData();
  }

  Future<void> fetchOrganizationData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    id.value = user.id;

    final response =
        await supabase
            .from('users')
            .select()
            .eq('id', user.id)
            .eq('role', 'organization')
            .single();

    final data = response;
    name.value = data['org_name'] ?? '';
    email.value = data['email'] ?? '';
    location.value = data['location'] ?? '';
    contact.value = data['contact_number'] ?? '';
    socialMedia.value = (data['social_media_links'] as List?)?.join(', ') ?? '';
    imageUrl.value = data['profile_image'] ?? '';
  }
}
