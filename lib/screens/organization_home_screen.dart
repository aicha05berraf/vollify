import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vollify/controllers/organization_controller.dart';
import 'package:vollify/controllers/user_controller.dart';
//import 'package:vollify/models/organization_model.dart';
//import 'package:vollify/controllers/organization_controller.dart';

class OrganizationHomeScreen extends StatelessWidget {
  const OrganizationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(title: Text('Organization Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              final userController = Get.find<UserController>();

              final user = userController.user.value;

              if (user == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                ); // or a fallback
              }

              // safely access name

              return Text(
                user != null
                    ? 'Welcome, ${user.orgName}!'
                    : 'Welcome, Organization!',

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              );
            }),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                //Get.put(OrganizationController());
                Navigator.pushNamed(context, '/organizationProfile');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Profile Screen'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/postOpportunity');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Post Opportunity'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                //Get.put(OrganizationController());
                await Get.find<OrganizationController>()
                    .fetchOrganizationData();
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, '/manageVolunteers');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Manage Volunteers'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/checkReviews');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Check Reviews'),
            ),
          ],
        ),
      ),
    );
  }
}
