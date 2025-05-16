import 'package:get/get.dart';

class OpportunitiesController extends GetxController {
  RxList<Map<String, dynamic>> opportunities = <Map<String, dynamic>>[].obs;

  void setOpportunities(List<Map<String, dynamic>> newOpportunities) {
    opportunities.value = newOpportunities;
  }

  void addOpportunity(Map<String, dynamic> opportunity) {
    opportunities.add(opportunity);
  }

  void clearOpportunities() {
    opportunities.clear();
  }
}
