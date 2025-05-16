import 'package:get/get.dart';

class ApplicationsController extends GetxController {
  final RxList<Map<String, dynamic>> applications =
      <Map<String, dynamic>>[].obs;

  void setApplications(List<Map<String, dynamic>> newApplications) {
    applications.value = newApplications;
  }

  void updateApplicationStatus(int applicationId, String newStatus) {
    final index = applications.indexWhere((a) => a['id'] == applicationId);
    if (index != -1) {
      applications[index]['status'] = newStatus;
      applications.refresh();
    }
  }

  void addApplication(Map<String, dynamic> application) {
    applications.add(application);
  }

  void clearApplications() {
    applications.clear();
  }
}
