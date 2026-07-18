import 'package:scholr/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/language_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage('assets/profile_placeholder.png'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        authProvider.name ?? 'Parent Name',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        authProvider.user?.email ?? 'parent.email@example.com',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        (authProvider.role ?? '').toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(
                    languageProvider.texts['phone_number'] ?? 'Phone Number',
                  ),
                  subtitle: const Text('+1234567890'),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(
                    languageProvider.texts['address'] ?? 'Address',
                  ),
                  subtitle: const Text('123, Sample Street, City, Country'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(
                    languageProvider.texts['student_name'] ?? 'Student Name',
                  ),
                  subtitle: const Text('Child Name'),
                ),
                ListTile(
                  leading: const Icon(Icons.class_),
                  title: Text(
                    languageProvider.texts['class_section'] ??
                        'Class & Section',
                  ),
                  subtitle: const Text('8th Grade - Section A'),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    languageProvider.texts['academic_year'] ?? 'Academic Year',
                  ),
                  subtitle: const Text('2023-2024'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      languageProvider.texts['edit_profile'] ?? 'Edit Profile',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () async {
                      await authProvider.logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
