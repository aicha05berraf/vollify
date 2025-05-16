// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vollify/controllers/user_controller.dart';
//import 'package:get/get.dart';
import 'package:vollify/services/review_service.dart';
//import 'package:vollify/controllers/organization_controller.dart';
//import 'package:vollify/services/user_service.dart';

class CheckReviewsScreen extends StatefulWidget {
  const CheckReviewsScreen({super.key});

  @override
  State<CheckReviewsScreen> createState() => _CheckReviewsScreenState();
}

class _CheckReviewsScreenState extends State<CheckReviewsScreen> {
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() => _isLoading = true);
    try {
      final userId = Get.find<UserController>().user.value?.id;

      if (userId == null) throw Exception('User ID not found');

      final fetched = await ReviewService().fetchReviewsForUser(userId);
      setState(() => _reviews = fetched);
    } catch (e) {
      print('🚨 Error fetching reviews: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching reviews')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Check Reviews')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    _reviews.isEmpty
                        ? Center(child: Text('No reviews yet.'))
                        : ListView.builder(
                          itemCount: _reviews.length,
                          itemBuilder: (context, index) {
                            final review = _reviews[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Opportunity Title
                                    Text(
                                      review['opportunity_title'] ?? '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Volunteer Name
                                    Text(
                                      'Volunteer: ${review['reviewer_name'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Review Text
                                    Text(
                                      review['comment'] ?? '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 8),
                                    // Rating
                                    Row(
                                      children: List.generate(5, (i) {
                                        return Icon(
                                          i < (review['rating'] ?? 0)
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      }),
                                    ),
                                    SizedBox(height: 8),

                                    // Review Date
                                    Text(
                                      'Date: ${review['created_at'] != null ? review['created_at'].toString().split(' ')[0] : ''}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
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
