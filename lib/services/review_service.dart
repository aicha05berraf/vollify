import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchReviewsForUser(String userId) async {
    final data = await supabase
        .from('reviews')
        .select(
          '*, users!reviewer_id(first_name, last_name), opportunities(title)',
        )
        .eq('reviewee_id', userId);

    return List<Map<String, dynamic>>.from(data)
        .map(
          (review) => {
            'opportunity_title': review['opportunities']?['title'] ?? '',
            'reviewer_name':
                '${review['users']?['first_name'] ?? ''} ${review['users']?['last_name'] ?? ''}',
            'comment': review['comment'] ?? '',
            'rating': review['rating'] ?? 0,
            'created_at': review['created_at'],
          },
        )
        .toList();
  }

  Future<void> addReview(Map<String, dynamic> data) async {
    await supabase.from('reviews').insert(data);
  }
}
