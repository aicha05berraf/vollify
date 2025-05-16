class ReviewsModel {
  final String opportunityTitle;
  final String organizationName;
  final String volunteerName;
  final String reviewText;
  final DateTime reviewDate;

  ReviewsModel({
    required this.opportunityTitle,
    required this.organizationName,
    required this.volunteerName,
    required this.reviewText,
    required this.reviewDate,
  });

  // Factory method to create a ReviewsModel from a JSON object
  factory ReviewsModel.fromJson(Map<String, dynamic> json) {
    return ReviewsModel(
      opportunityTitle: json['opportunityTitle'],
      organizationName: json['organizationName'],
      volunteerName: json['volunteerName'],
      reviewText: json['reviewText'],
      reviewDate: DateTime.parse(json['reviewDate']),
    );
  }

  // Method to convert a ReviewsModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'opportunityTitle': opportunityTitle,
      'organizationName': organizationName,
      'volunteerName': volunteerName,
      'reviewText': reviewText,
      'reviewDate': reviewDate.toIso8601String(),
    };
  }
}
