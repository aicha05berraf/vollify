import 'package:get/get.dart';

class VolunteerController extends GetxController {
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var skills = ''.obs;
  var experience = ''.obs;
  var imageUrl = ''.obs;

  get id => null;

  void setVolunteer({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String skills,
    required String experience,
    String? imageUrl,
    required id,
  }) {
    this.firstName.value = firstName;
    this.lastName.value = lastName;
    this.email.value = email;
    this.phoneNumber.value = phoneNumber;
    this.skills.value = skills;
    this.experience.value = experience;
    this.imageUrl.value = imageUrl ?? '';
  }

  void clearVolunteer() {
    firstName.value = '';
    lastName.value = '';
    email.value = '';
    phoneNumber.value = '';
    skills.value = '';
    experience.value = '';
    imageUrl.value = '';
  }
}
