class OpportunityModel {
  final String title;
  final String description;
  final String domain;
  final int volunteersRequired;
  final int currentVolunteers;
  final String skillsRequired;
  final String location;
  final String email;
  final String phone;

  OpportunityModel({
    required this.title,
    required this.description,
    required this.domain,
    required this.volunteersRequired,
    required this.currentVolunteers,
    required this.skillsRequired,
    required this.location,
    required this.email,
    required this.phone,
  });

  // Factory method to create an OpportunityModel from a JSON object
  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      title: json['title'],
      description: json['description'],
      domain: json['domain'],
      volunteersRequired: json['volunteersRequired'],
      currentVolunteers: json['currentVolunteers'] ?? 0,
      skillsRequired: json['skillsRequired'],
      location: json['location'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  // Method to convert an OpportunityModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'domain': domain,
      'volunteersRequired': volunteersRequired,
      'currentVolunteers': currentVolunteers,
      'skillsRequired': skillsRequired,
      'location': location,
      'email': email,
      'phone': phone,
    };
  }
}
