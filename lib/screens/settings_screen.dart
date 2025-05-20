import 'package:flutter/material.dart';
import 'user_type_screen.dart';
import 'package:vollify/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _logout() async {
    await AuthService().signOut();
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => UserTypeScreen()),
      (route) => false,
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy Policy - Vollify'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Effective Date: [16/05/2025]\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Welcome to Vollify! Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you use our mobile application.\n',
                ),
                const Text(
                  '1. 🔍 Information We Collect\n'
                  'We collect the following information:\n\n'
                  'a. Account Information\n'
                  'Full name, email address, password\n\n'
                  'Role (volunteer or organization)\n\n'
                  'Profile details (skills, experience, phone number, location, social media)\n\n'
                  'b. Opportunity Data\n'
                  'Opportunities posted by organizations\n\n'
                  'Applications submitted by volunteers\n\n'
                  'Reviews written by volunteers\n\n'
                  'c. Device & Usage Information\n'
                  'Device type, operating system, crash logs\n\n'
                  'In-app activity (e.g., what features you use)\n',
                ),
                const Text(
                  '\n2. 🛠 How We Use Your Information\n'
                  'We use your data to:\n\n'
                  'Create and manage your user account\n\n'
                  'Match volunteers with suitable opportunities\n\n'
                  'Let organizations manage volunteer applications\n\n'
                  'Enable reviews and feedback\n\n'
                  'Send important updates and notifications\n\n'
                  'Improve and secure the app\n',
                ),
                const Text(
                  '\n3. 🔐 Data Storage & Security\n'
                  'All data is securely stored using Supabase, which provides encrypted database and authentication services. We take appropriate measures to protect your data from unauthorized access or loss.\n',
                ),
                const Text(
                  '\n4. 🔁 Sharing of Information\n'
                  'We do not sell or share your personal information with third parties for marketing purposes.\n\n'
                  'Information may only be shared when:\n\n'
                  'Required by law or legal obligation\n\n'
                  'Necessary to protect the safety or rights of users\n\n'
                  'Explicitly approved by you (e.g., public reviews)\n',
                ),
                const Text(
                  '\n5. 🧽 Your Rights & Choices\n'
                  'You have the right to:\n\n'
                  'View or update your profile information\n\n'
                  'Opt out of non-essential notifications\n\n'
                  'To exercise these rights, please contact us at vollifyapp@gmail.com.\n',
                ),
                const Text(
                  '\n6. 👶 Children\'s Privacy\n'
                  'Vollify is not intended for users under the age of 15. We do not knowingly collect personal information from children.\n',
                ),
                const Text(
                  '\n7. 🔄 Changes to This Policy\n'
                  'We may update this Privacy Policy from time to time. We\'ll notify you of any significant changes via the app or email.\n',
                ),
                const Text(
                  '\n8. 📩 Contact Us\n'
                  'If you have any questions about this policy, please contact us at:\n\n'
                  'Email: vollifyapp@gmail.com\n'
                  'App Name: Vollify\n',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF354C2B);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF20331B),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings, size: 80, color: darkGreen),
              const SizedBox(height: 32),

              ListTile(
                leading: const Icon(Icons.privacy_tip, color: darkGreen),
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: _showPrivacyPolicy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: _logout,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
