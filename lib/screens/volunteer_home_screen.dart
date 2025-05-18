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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
                  child: Obx(() {
                    final user = userController.user.value;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user != null
                              ? 'Welcome, ${user.firstName} ${user.lastName}!'
                              : 'Welcome, Volunteer!',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF20331B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 340, // Adjust height as needed for your design
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            childAspectRatio: 1.1,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: cards.map((card) {
                              return _HomeCard(
                                data: card,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        },
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
    return Material(
      // ignore: deprecated_member_use
      color: data.color.withOpacity(0.95),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.pushNamed(context, data.route);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                data.icon,
                size: 44,
                color: Colors.white,
              ),
              const SizedBox(height: 18),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
