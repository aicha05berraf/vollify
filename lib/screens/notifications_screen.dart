// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vollify/services/notification_service.dart';
import 'package:vollify/controllers/user_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final userId = Get.find<UserController>().user.value?.id;
    if (userId == null) {
      setState(() {
        _notifications = [];
        _isLoading = false;
      });
      return;
    }
    final notifications = await NotificationService().fetchNotifications(
      userId,
    );
    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Refused':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Accepted':
        return Icons.check_circle;
      case 'Refused':
        return Icons.cancel;
      case 'Pending':
        return Icons.hourglass_empty;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color appBarColor = Color(0xFF20331B);
    const Color bellColor = Color(0xFFC3CA92);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white, // Consistent with SignUp page
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _notifications.isEmpty
                  ? const Center(child: Text('No notifications yet.'))
                  : ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.notifications,
                              color: bellColor,
                              size: 40,
                            ),
                            title: Text(
                              notification['message'] ?? 'No message',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              notification['created_at'] != null
                                  ? DateTime.parse(
                                      notification['created_at'],
                                    ).toLocal().toString()
                                  : '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
