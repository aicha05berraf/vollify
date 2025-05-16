import 'user_model.dart';

class OrganizationModel {
  final String id; // Unique ID for the user (from 'users' table)
  final String name;
  final UserModel
  owner; // The owner is a user (which should be a Volunteer or Organization)
  final String location;
  final List<String> socialMedia;
  final String email;
  final String phoneNumber;

  OrganizationModel({
    required this.id,
    required this.name,
    required this.owner,
    required this.location,
    required this.socialMedia,
    required this.email,
    required this.phoneNumber,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'],
      name: json['name'],
      owner: UserModel.fromJson(json['owner']),
      location: json['location'],
      socialMedia: List<String>.from(json['socialMedia']),
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner': owner.toMap(),
      'location': location,
      'socialMedia': socialMedia,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
