import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vollify/controllers/organization_controller.dart';
import 'package:vollify/controllers/user_controller.dart';

class OrganizationHomeScreen extends StatelessWidget {
  const OrganizationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_HomeCardData> cards = [
      _HomeCardData(
        title: 'Profile Screen',
        icon: Icons.account_circle_outlined,
        color: const Color(0xFF354C2B),
        route: '/organizationProfile',
      ),
      _HomeCardData(
        title: 'Post Opportunity',
        icon: Icons.add_box_outlined,
        color: const Color(0xFF4E653D),
        route: '/postOpportunity',
      ),
      _HomeCardData(
        title: 'Manage Volunteers',
        icon: Icons.group_outlined,
        color: const Color(0xFF697E50),
        route: '/manageVolunteers',
        onTap: () async {
          await Get.find<OrganizationController>().fetchOrganizationData();
          Get.toNamed('/manageVolunteers');
        },
      ),
      _HomeCardData(
        title: 'Check Reviews',
        icon: Icons.reviews_outlined,
        color: const Color(0xFF859864),
        route: '/checkReviews',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF20331B),
        title: const Text('Organization Home'),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Obx(() {
          final userController = Get.find<UserController>();
          final user = userController.user.value;

          return Column(
            children: [
              Text(
                user != null && user.orgName != null
                    ? 'Welcome, ${user.orgName}!'
                    : 'Welcome, Organization!',
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
  final Future<void> Function()? onTap;

  _HomeCardData({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
    this.onTap,
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
        onTap: () async {
          if (data.onTap != null) {
            await data.onTap!();
          } else {
            Navigator.pushNamed(context, data.route);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
