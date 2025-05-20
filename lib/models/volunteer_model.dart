class VolunteerModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String skills;
  final String experience;
  final String phoneNumber;
  final String? imageUrl;

  VolunteerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.skills,
    required this.experience,
    required this.phoneNumber,
    this.imageUrl,
  });

  factory VolunteerModel.fromJson(Map<String, dynamic> json) {
    return VolunteerModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      skills: json['skills'],
      experience: json['experience'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
    );
  }

  get volunteer => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'skills': skills,
      'experience': experience,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
    };
  }
}
