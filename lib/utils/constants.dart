import 'dart:ui';

class AppColors {
  static const primaryDark = Color(0xFF20331B);
  static const primary = Color(0xFF4E653D);
  static const secondary = Color(0xFF859864);
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);

  static const primaryLight = Color(0xFFAED581);
  static const accent = Color(0xFFFFC107);
}

class AppTextStyles {
  static final myTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );
}

class AppStrings {
  // Volunteer-related strings
  static const volunteerOpportunities = 'Search Opportunities';
  static const volunteerReviews = 'Write Reviews';
  static const volunteerNotifications = 'Notifications';
  static const volunteerProfile = 'Volunteer Profile';
  static const volunteerHome = 'Volunteer Home';
  static const volunteerSignup = 'Volunteer Signup';

  // Organization-related strings
  static const orgPostOpportunities = 'Post Opportunities';
  static const orgManageVolunteers = 'Manage Volunteers';
  static const orgReviews = 'View Reviews';
  static const orgProfile = 'Organization Profile';
  static const orgHome = 'Organization Home';
  static const orgSignup = 'Organization Signup';

  // Common strings
  static const login = 'Login';
  static const logout = 'Logout';
  static const resetPassword = 'Reset Password';
  static const settings = 'Settings';
  static const privacyPolicy = 'Privacy Policy';
  static const darkMode = 'Dark Mode';
  static const notifications = 'Notifications';
  static const saveChanges = 'Save Changes';
  static const submit = 'Submit';
  static const close = 'Close';

  // Error messages
  static const errorInvalidEmail = 'Please enter a valid email address';
  static const errorEmptyField = 'This field cannot be empty';
  static const errorPasswordMismatch = 'Passwords do not match';
  static const errorShortPassword =
      'Password must be at least 6 characters long';

  // Success messages
  static const successProfileUpdated = 'Profile updated successfully';
  static const successOpportunityPosted = 'Opportunity posted successfully';
  static const successReviewSubmitted = 'Review submitted successfully';
  static const successPasswordReset = 'Password reset successfully';
}
