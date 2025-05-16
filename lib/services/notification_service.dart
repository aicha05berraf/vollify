import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchNotifications(String userId) async {
    try {
      final data = await supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> addNotification(Map<String, dynamic> data) async {
    await supabase.from('notifications').insert(data);
  }

  Future<void> markAsRead(int id) async {
    await supabase.from('notifications').update({'is_read': true}).eq('id', id);
  }
}
