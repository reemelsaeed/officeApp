import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/features/authentications/presentation/widgets/profile_title_widget.dart';
import 'package:office_application/features/authentications/presentation/widgets/user_header_widget.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});
  final user = UserModel(id: '1', name: 'Reem Elsaeed', role: userRole.Admin);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserHeaderWidget(user: user),

            SizedBox(height: 24),

            Text(
              'Account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 12),
            ProfileTile(icon: Icons.person_outline, title: 'Edit Profile'),
            ProfileTile(icon: Icons.lock_outline, title: 'Change Password'),

            SizedBox(height: 24),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 12),
            ProfileTile(icon: Icons.person_2_outlined, title: 'Users'),
            ProfileTile(icon: Icons.logout, title: 'Logout', color: Colors.red),
          ],
        ),
      ),
    );
  }
}
