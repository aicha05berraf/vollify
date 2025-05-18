// Replace your current file with this updated version

// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vollify/services/application_service.dart';
import 'package:vollify/services/notification_service.dart';
import 'package:vollify/controllers/organization_controller.dart';

class ManageVolunteersScreen extends StatefulWidget {
  const ManageVolunteersScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManageVolunteersScreenState createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen> {
  List<Map<String, dynamic>> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final orgId = Get.find<OrganizationController>().id.value;
      if (orgId.isNotEmpty) {
        _fetchApplications(orgId);
      } else {
        print('❌ Org ID is still empty. Not fetching.');
      }
    });
  }

  Future<void> _fetchApplications(String orgId) async {
    try {
      final applications = await ApplicationService()
          .fetchApplicationsForOrganization(orgId);
      setState(() {
        _applications = applications;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Failed to fetch applications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateApplicationStatus(int index, String status) async {
    final application = _applications[index];

    // Handle Accept logic with skills comparison
    if (status == 'Accepted') {
      final volunteerSkills =
          (application['skills'] ?? '')
              .toString()
              .toLowerCase()
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toSet();

      final requiredSkillsRaw = application['skills_required'];
      final requiredSkills =
          requiredSkillsRaw != null
              ? requiredSkillsRaw
                  .toString()
                  .toLowerCase()
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toSet()
              : <String>{};

      final missingSkills = requiredSkills.difference(volunteerSkills);

      print('✅ Volunteer Skills: $volunteerSkills');
      print('📋 Required Skills: $requiredSkills');
      print('❌ Missing Skills: $missingSkills');

      // Show confirmation dialog if skills are missing
      if (missingSkills.isNotEmpty) {
        final proceed =
            await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text("Missing Skills ⚠️"),
                    content: Text(
                      "${application['volunteer_name']} is missing: ${missingSkills.join(', ')}.\nDo you still want to accept?",
                    ),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: Text("Accept Anyway"),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
            ) ??
            false;

        if (!proceed) {
          print('🚫 Acceptance cancelled by user');
          return;
        }
      }
    }

    try {
      await ApplicationService().updateApplicationStatus(
        application['id'],
        status,
      );

      await NotificationService().addNotification({
        'user_id': application['volunteer_id'],
        'message':
            'Your application for "${application['opportunity_title']}" has been $status.',
      });

      setState(() {
        _applications[index]['status'] = status;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Volunteer ${application['volunteer_name']} has been $status for ${application['opportunity_title']}',
          ),
        ),
      );
    } catch (e) {
      print('❌ Error updating application status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF20331B), // Match HomeScreen
        title: const Text(
          'Manage Volunteers',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _applications.length,
                itemBuilder: (context, index) {
                  final application = _applications[index];
                  final status =
                      (application['status'] ?? '').toString().toLowerCase();
                  final fullName =
                      '${application['volunteer_name'] ?? ''} ${application['volunteer_lastname'] ?? ''}';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF20331B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Opportunity: ${application['opportunity_title'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF354C2B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Skills: ${application['skills'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF354C2B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${application['status']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: status == 'accepted'
                                  ? Colors.green
                                  : status == 'rejected'
                                      ? Colors.red
                                      : Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: status == 'pending'
                                      ? () => _updateApplicationStatus(
                                            index,
                                            'Accepted',
                                          )
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // Accept is green
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(color: Colors.white), // White text
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: status == 'pending'
                                      ? () => _updateApplicationStatus(
                                            index,
                                            'Rejected',
                                          )
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red, // Reject is red
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.white), // White text
                                  ),
                                ),
                              ),
                            ],
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
