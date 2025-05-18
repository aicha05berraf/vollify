import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vollify/controllers/user_controller.dart';

class VolunteerHomeScreen extends StatelessWidget {
  const VolunteerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    final List<_HomeCardData> cards = [
      _HomeCardData(
        title: 'Profile Screen',
        icon: Icons.account_circle_outlined,
        color: const Color(0xFF354C2B),
        route: '/volunteerProfile',
      ),
      _HomeCardData(
        title: 'Search Opportunity',
        icon: Icons.search_outlined,
        color: const Color(0xFF4E653D),
        route: '/searchOpportunity',
      ),
      _HomeCardData(
        title: 'Write Reviews',
        icon: Icons.rate_review_outlined,
        color: const Color(0xFF697E50),
        route: '/writeReviews',
      ),
      _HomeCardData(
        title: 'Notifications',
        icon: Icons.notifications_outlined,
        color: const Color(0xFF859864),
        route: '/notifications',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF20331B),
        title: const Text('Volunteer Home'),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Obx(() {
          final user = userController.user.value;

          return Column(
            children: [
              Text(
                user != null
                    ? 'Welcome, ${user.firstName} ${user.lastName}!'
                    : 'Welcome, Volunteer!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF20331B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9, // Adjusted for larger cards
                  padding: const EdgeInsets.all(8),
                  children:
                      cards.map((card) {
                        return _HomeCard(data: card);
                      }).toList(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _HomeCardData {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _HomeCardData({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class _HomeCard extends StatelessWidget {
  final _HomeCardData data;

  const _HomeCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(context, data.route);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // ignore: deprecated_member_use
            color: data.color.withOpacity(0.95),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(data.icon, size: 48, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18, // Increased font size
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
