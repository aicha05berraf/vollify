class NotificationsModel {
  final String opportunityTitle;
  final String organizationName;
  final String status; // Accepted, Refused, or Pending
  final DateTime notificationDate;

  NotificationsModel({
    required this.opportunityTitle,
    required this.organizationName,
    required this.status,
    required this.notificationDate,
  });

  // Factory method to create a NotificationsModel from a JSON object
  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      opportunityTitle: json['opportunityTitle'],
      organizationName: json['organizationName'],
      status: json['status'],
      notificationDate: DateTime.parse(json['notificationDate']),
    );
  }

  // Method to convert a NotificationsModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'opportunityTitle': opportunityTitle,
      'organizationName': organizationName,
      'status': status,
      'notificationDate': notificationDate.toIso8601String(),
    };
  }
}
