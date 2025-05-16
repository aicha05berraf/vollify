import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final RxList<Map<String, dynamic>> notifications =
      <Map<String, dynamic>>[].obs;

  void setNotifications(List<Map<String, dynamic>> newNotifications) {
    notifications.value = newNotifications;
  }

  void addNotification(Map<String, dynamic> notification) {
    notifications.add(notification);
  }

  void markAsRead(int notificationId) {
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      notifications[index]['isRead'] = true;
      notifications.refresh();
    }
  }

  void clearNotifications() {
    notifications.clear();
  }
}
