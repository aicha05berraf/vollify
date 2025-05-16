// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vollify/services/review_service.dart';
//import 'package:vollify/services/application_service.dart';
import 'package:vollify/controllers/user_controller.dart';
//import 'package:vollify/services/user_service.dart';

class WriteReviewsScreen extends StatefulWidget {
  const WriteReviewsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WriteReviewsScreenState createState() => _WriteReviewsScreenState();
}

class _WriteReviewsScreenState extends State<WriteReviewsScreen> {
  List<Map<String, dynamic>> _opportunities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOpportunities();
  }

  Future<void> _fetchOpportunities() async {
    setState(() => _isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      print('🔍 Current logged in user ID: $userId');
      if (userId == null) throw Exception('User ID not found');

      final accepted = await Supabase.instance.client
          .from('applications')
          .select('''
          id,
          opportunity_id,
          organization_id,
          status,
          opportunities (title),
          users:users!applications_organization_id_fkey (org_name)
          ''')
          .eq('volunteer_id', userId)
          .eq('status', 'accepted');

      print('✅ Accepted applications: $accepted');

      _opportunities =
          accepted
              .map(
                (a) => {
                  'application_id': a['id'],
                  'opportunity_id': a['opportunity_id'],
                  'organization_id': a['organization_id'],
                  'title': a['opportunities']['title'] ?? '',
                  'organizationName': a['users']?['org_name'] ?? '',
                  'review': '',
                  'rating': 0,
                },
              )
              .toList();
    } catch (e) {
      print('🚨 Error fetching opportunities: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching opportunities')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitReview(int index) async {
    final userId = Get.find<UserController>().user.value?.id;
    final opportunity = _opportunities[index];
    if (opportunity['review'].isNotEmpty && opportunity['rating'] > 0) {
      try {
        await ReviewService().addReview({
          'reviewer_id': userId,
          'reviewee_id': opportunity['organization_id'],
          'opportunity_id': opportunity['opportunity_id'],
          'comment': opportunity['review'],
          'rating': opportunity['rating'],
          'created_at': DateTime.now().toIso8601String(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Review submitted for ${opportunity['title']}'),
          ),
        );
        setState(() {
          _opportunities[index]['review'] = '';
          _opportunities[index]['rating'] = 0;
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit review: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please write a review and select a rating before submitting',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Write Reviews')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    _opportunities.isEmpty
                        ? Center(child: Text('No opportunities to review yet.'))
                        : ListView.builder(
                          itemCount: _opportunities.length,
                          itemBuilder: (context, index) {
                            final opportunity = _opportunities[index];
                            return Card(
                              color: theme.cardColor,
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Opportunity Title
                                    Text(
                                      opportunity['title'],
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(height: 8),

                                    // Organization Name
                                    Text(
                                      'Organization: ${opportunity['organizationName']}',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.secondary,
                                          ),
                                    ),
                                    SizedBox(height: 16),

                                    // Review Text Field
                                    TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _opportunities[index]['review'] =
                                              value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Write your review',
                                        border: OutlineInputBorder(),
                                      ),
                                      maxLines: 3,

                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 16),
                                    // Rating Stars
                                    Row(
                                      children: List.generate(5, (starIndex) {
                                        return IconButton(
                                          icon: Icon(
                                            Icons.star,
                                            color:
                                                starIndex <
                                                        opportunity['rating']
                                                    ? Colors.amber
                                                    : Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _opportunities[index]['rating'] =
                                                  starIndex + 1;
                                            });
                                          },
                                        );
                                      }),
                                    ),
                                    SizedBox(height: 16),

                                    // Submit Button
                                    ElevatedButton(
                                      onPressed: () => _submitReview(index),
                                      child: Text('Submit Review'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
    );
  }
}
