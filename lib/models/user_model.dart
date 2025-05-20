class UserModel {
  final String id;
  final String email;
  final String role;
  final DateTime? createdAt;

  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final List<String>? skills;
  final String? experience;

  final String? orgName;
  final String? location;
  final List<String>? socialMediaLinks;
  final String? contactNumber;

  final String? imageUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.skills,
    this.experience,
    this.orgName,
    this.location,
    this.socialMediaLinks,
    this.contactNumber,
    this.imageUrl,
  });

  String get name {
    if (role == 'volunteer') {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    } else if (role == 'organization') {
      return orgName ?? '';
    }
    return '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'skills': skills,
      'experience': experience,
      'org_name': orgName,
      'location': location,
      'social_media_links': socialMediaLinks,
      'contact_number': contactNumber,
      'profile_image': imageUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      role: map['role'],
      createdAt:
          map['created_at'] != null
              ? DateTime.tryParse(map['created_at'])
              : null,
      firstName: map['first_name'],
      lastName: map['last_name'],
      phoneNumber: map['phone_number'],
      skills: (map['skills'] as List?)?.cast<String>(),
      experience: map['experience'],
      orgName: map['org_name'],
      location: map['location'],
      socialMediaLinks: (map['social_media_links'] as List?)?.cast<String>(),
      contactNumber: map['contact_number'],
      imageUrl: map['profile_image'],
    );
  }
}
