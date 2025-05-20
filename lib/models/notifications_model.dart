class NotificationsModel {
  final String opportunityTitle;
  final String organizationName;
  final String status;
  final DateTime notificationDate;

  NotificationsModel({
    required this.opportunityTitle,
    required this.organizationName,
    required this.status,
    required this.notificationDate,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      opportunityTitle: json['opportunityTitle'],
      organizationName: json['organizationName'],
      status: json['status'],
      notificationDate: DateTime.parse(json['notificationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'opportunityTitle': opportunityTitle,
      'organizationName': organizationName,
      'status': status,
      'notificationDate': notificationDate.toIso8601String(),
    };
  }
}
