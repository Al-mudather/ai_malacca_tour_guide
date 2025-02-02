import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_malacca_tour_guide/features/auth/controllers/auth_controller.dart';
import 'package:ai_malacca_tour_guide/routes/app_pages.dart';
import 'package:ai_malacca_tour_guide/services/user_service.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/account_header.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_section.dart';

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
            flexibleSpace: Obx(() => AccountHeader(
                  user: authController.currentUser.value,
                )),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsSection(
                    title: 'Profile Settings',
                    children: [
                      SettingsTile(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        subtitle: 'Change your personal information',
                        onTap: () async {
                          final user = authController.currentUser.value;
                          if (user == null) return;

                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) => EditProfileDialog(user: user),
                          );

                          if (result == true) {
                            // Refresh user data
                            final userService = Get.find<UserService>();
                            final updatedUser =
                                await userService.getCurrentUser();
                            authController.currentUser.value = updatedUser;
                          }
                        },
                      ),
                      // SettingsTile(
                      //   icon: Icons.lock_outline,
                      //   title: 'Change Password',
                      //   subtitle: 'Update your password',
                      //   onTap: () async {
                      //     final result = await showDialog<bool>(
                      //       context: context,
                      //       builder: (context) => const ChangePasswordDialog(),
                      //     );

                      //     if (result == true) {
                      //       Get.snackbar(
                      //         'Success',
                      //         'Your password has been updated',
                      //         backgroundColor: Colors.green[100],
                      //         colorText: Colors.green[800],
                      //       );
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Show settings section only for admin users
                  Obx(() {
                    final user = authController.currentUser.value;

                    if (user?.isAdmin == true) {
                      return Column(
                        children: [
                          SettingsSection(
                            title: 'App Settings',
                            children: [
                              SettingsTile(
                                icon: Icons.settings_outlined,
                                title: 'Settings',
                                subtitle: 'App preferences and configurations',
                                onTap: () => Get.toNamed(Routes.SETTINGS),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  Container(
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
                        onTap: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.logout_rounded,
                                      color: Colors.red[700],
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Are you sure you want to logout from your account?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actionsPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 24),
                              actions: [
                                SizedBox(
                                  width: 120,
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      side:
                                          BorderSide(color: Colors.grey[300]!),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 120,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red[700]!,
                                          Colors.red[500]!
                                        ],
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
                                        onTap: () =>
                                            Navigator.of(context).pop(true),
                                        borderRadius: BorderRadius.circular(12),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: Text(
                                            'Logout',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                            await authController.signOut();
                            Get.offAllNamed(Routes.WELCOME);
                          }
                        },
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
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
