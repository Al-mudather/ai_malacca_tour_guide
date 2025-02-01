import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/user_service.dart';
import '../../../config/app_colors.dart';
import 'password_input_field.dart';
import 'dialog_action_buttons.dart';
import 'dialog_header.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userService = Get.find<UserService>();
      await userService.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      Get.back(result: true);
      Get.snackbar(
        'Success',
        'Password changed successfully',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 32,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DialogHeader(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                ),
                const SizedBox(height: 16),
                PasswordInputField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                  hint: 'Enter current password',
                  obscureText: !_showCurrentPassword,
                  onToggleVisibility: () => setState(
                      () => _showCurrentPassword = !_showCurrentPassword),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PasswordInputField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  hint: 'Enter new password',
                  obscureText: !_showNewPassword,
                  onToggleVisibility: () =>
                      setState(() => _showNewPassword = !_showNewPassword),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PasswordInputField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Confirm new password',
                  obscureText: !_showConfirmPassword,
                  onToggleVisibility: () => setState(
                      () => _showConfirmPassword = !_showConfirmPassword),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DialogActionButtons(
                  isLoading: _isLoading,
                  onSubmit: _handleSubmit,
                  submitText: 'Change Password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
