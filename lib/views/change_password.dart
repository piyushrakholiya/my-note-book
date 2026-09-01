import 'package:firebase/utils/gradient_background.dart';
import 'package:firebase/utils/ui_helper.dart';
import 'package:firebase/viewmodels/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  Future<void> changePassword() async {
    final viewModel = context.read<ChangePasswordViewModel>();

    final bool success = await viewModel.changePassword(
      currentPassword: currentPassword.text.trim(),
      newPassword: newPassword.text.trim(),
      confirmPassword: confirmPassword.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (success) {
      await UiHelper.customAlertBox(
        context: context,
        text: "Password changed successfully",
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } else {
      UiHelper.customAlertBox(
        context: context,
        text: viewModel.errorMessage ?? "Password change failed",
      );
    }
  }

  @override
  void dispose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<ChangePasswordViewModel>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("change password"),
        centerTitle: true,
        backgroundColor: Color(0xFF6A11CB),
        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: currentPassword,
              obscureText: true,

              decoration: InputDecoration(
                label: const Text(
                  "currentPassword",
                  style: TextStyle(color: Colors.white),
                ),
                hint: const Text(
                  "enter your password",
                  style: TextStyle(color: Colors.white),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Colors.blue),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: newPassword,
              obscureText: true,

              decoration: InputDecoration(
                label: const Text(
                  "newPassword",
                  style: TextStyle(color: Colors.white),
                ),
                hint: const Text(
                  "enter your password",
                  style: TextStyle(color: Colors.white),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Colors.blue),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: confirmPassword,
              obscureText: true,

              decoration: InputDecoration(
                label: const Text(
                  "confirmPassword",
                  style: TextStyle(color: Colors.white),
                ),
                hint: const Text(
                  "enter your password",
                  style: TextStyle(color: Colors.white),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Colors.blue),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(15),
                ),
                minimumSize: Size(200, 40),
              ),
              onPressed: isLoading ? null : changePassword,

              child: isLoading
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(),
                    )
                  : const Text(
                      "update password",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
