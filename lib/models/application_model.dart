class ApplicationModel {
  final String applicationId;
  final String volunteerId;
  final String opportunityId;
  final String status; // Pending, Accepted, or Rejected
  final DateTime applicationDate;

  ApplicationModel({
    required this.applicationId,
    required this.volunteerId,
    required this.opportunityId,
    required this.status,
    required this.applicationDate,
  });

  // Factory method to create an ApplicationModel from a JSON object
  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      applicationId: json['applicationId'],
      volunteerId: json['volunteerId'],
      opportunityId: json['opportunityId'],
      status: json['status'],
      applicationDate: DateTime.parse(json['applicationDate']),
    );
  }

  // Method to convert an ApplicationModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'applicationId': applicationId,
      'volunteerId': volunteerId,
      'opportunityId': opportunityId,
      'status': status,
      'applicationDate': applicationDate.toIso8601String(),
    };
  }
}
