import 'package:get/get.dart';

class ReviewsController extends GetxController {
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;

  void setReviews(List<Map<String, dynamic>> newReviews) {
    reviews.value = newReviews;
  }

  void addReview(Map<String, dynamic> review) {
    reviews.add(review);
  }

  void clearReviews() {
    reviews.clear();
  }
}
