// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vollify/controllers/user_controller.dart';
import 'package:vollify/services/review_service.dart';

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF20331B),
        title: const Text(
          'Check Reviews',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    _reviews.isEmpty
                        ? const Center(child: Text('No reviews yet.'))
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
                                    Text(
                                      review['opportunity_title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF20331B),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Text(
                                      'Volunteer: ${review['reviewer_name'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Text(
                                      review['comment'] ?? '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),

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
                                    const SizedBox(height: 8),

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
