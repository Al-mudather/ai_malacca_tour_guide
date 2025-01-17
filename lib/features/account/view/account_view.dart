import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/features/debug/debug_menu.dart';
import 'package:ai_malacca_tour_guide/features/auth/controllers/auth_controller.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue[700]!,
                      Colors.blue[500]!,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Obx(() {
                      final user = authController.currentUser.value;
                      return CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              title: Obx(() {
                final user = authController.currentUser.value;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? 'email@example.com',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildSection(
                  //   title: 'Profile Settings',
                  //   children: [
                  //     _buildSettingTile(
                  //       icon: Icons.person_outline,
                  //       title: 'Edit Profile',
                  //       subtitle: 'Change your personal information',
                  //       onTap: () {},
                  //     ),
                  //     _buildSettingTile(
                  //       icon: Icons.lock_outline,
                  //       title: 'Change Password',
                  //       subtitle: 'Update your password',
                  //       onTap: () {},
                  //     ),
                  //     _buildSettingTile(
                  //       icon: Icons.notifications_outlined,
                  //       title: 'Notifications',
                  //       subtitle: 'Manage your notification preferences',
                  //       onTap: () {},
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'App Settings',
                    children: [
                      // _buildSettingTile(
                      //   icon: Icons.language_outlined,
                      //   title: 'Language',
                      //   subtitle: 'English',
                      //   onTap: () {},
                      // ),
                      // _buildSettingTile(
                      //   icon: Icons.dark_mode_outlined,
                      //   title: 'Theme',
                      //   subtitle: 'Light',
                      //   onTap: () {},
                      // ),
                      _buildSettingTile(
                        icon: Icons.bug_report_outlined,
                        title: 'Debug Menu',
                        subtitle: 'Access developer options',
                        onTap: () => Get.to(() => const DebugMenu()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // _buildSection(
                  //   title: 'About',
                  //   children: [
                  //     _buildSettingTile(
                  //       icon: Icons.info_outline,
                  //       title: 'App Version',
                  //       subtitle: '1.0.0',
                  //       onTap: () {},
                  //     ),
                  //     _buildSettingTile(
                  //       icon: Icons.privacy_tip_outlined,
                  //       title: 'Privacy Policy',
                  //       subtitle: 'Read our privacy policy',
                  //       onTap: () {},
                  //     ),
                  //     _buildSettingTile(
                  //       icon: Icons.description_outlined,
                  //       title: 'Terms of Service',
                  //       subtitle: 'Read our terms of service',
                  //       onTap: () {},
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 24),
                  _buildLogoutButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[700]!, Colors.red[500]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showLogoutConfirmation,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[700]!, Colors.red[500]!],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final authController = Get.find<AuthController>();
      authController.signOut();
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}
