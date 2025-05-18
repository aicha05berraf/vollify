import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controllers/organization_controller.dart';
import 'controllers/user_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/user_type_screen.dart';
import 'screens/volunteer_home_screen.dart';
import 'screens/organization_home_screen.dart';
import 'screens/volunteer_signup_screen.dart';
import 'screens/organization_signup_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/post_opportunity_screen.dart';
import 'screens/manage_volunteers_screen.dart';
import 'screens/check_reviews_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/write_reviews_screen.dart';
import 'screens/search_opportunity_screen.dart';
import 'screens/volunteer_profile_screen.dart';
import 'screens/organization_profile_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://uwprgsxgyoyhnssgjwrl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3cHJnc3hneW95aG5zc2dqd3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY2NTczMTQsImV4cCI6MjA2MjIzMzMxNH0.qSMLFqf7fc64nFmJVCQyYdV0QMyJqMx8dJS8ncLE2hU',
  );

  Get.put(UserController());
  Get.put(OrganizationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vollify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/userType', page: () => UserTypeScreen()),
        GetPage(name: '/volunteerHome', page: () => VolunteerHomeScreen()),
        GetPage(
          name: '/organizationHome',
          page: () => OrganizationHomeScreen(),
        ),
        GetPage(name: '/volunteerSignup', page: () => VolunteerSignupScreen()),
        GetPage(
          name: '/organizationSignup',
          page: () => OrganizationSignupScreen(),
        ),
        GetPage(name: '/settings', page: () => SettingsScreen()),
        GetPage(name: '/postOpportunity', page: () => PostOpportunityScreen()),
        GetPage(
          name: '/manageVolunteers',
          page: () => ManageVolunteersScreen(),
        ),
        GetPage(name: '/checkReviews', page: () => CheckReviewsScreen()),
        GetPage(name: '/notifications', page: () => NotificationsScreen()),
        GetPage(name: '/writeReviews', page: () => WriteReviewsScreen()),
        GetPage(
          name: '/searchOpportunity',
          page: () => SearchOpportunityScreen(),
        ),
        GetPage(
          name: '/volunteerProfile',
          page: () => VolunteerProfileScreen(),
        ),
        GetPage(
          name: '/organizationProfile',
          page: () => OrganizationProfileScreen(),
        ),
        GetPage(name: '/login', page: () => LoginScreen()),
      ],
    );
  }
}
