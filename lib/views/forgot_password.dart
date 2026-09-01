import 'package:firebase/utils/gradient_background.dart';
import 'package:firebase/utils/ui_helper.dart';
import 'package:firebase/viewmodels/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController forgotController = TextEditingController();

  Future<void> forgotPassword() async {
    final viewModel = context.read<ForgotPasswordViewModel>();

    final bool success = await viewModel.forgotPassword(
      forgotController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (success) {
      await UiHelper.customAlertBox(
        context: context,
        text: "Password reset email sent",
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } else {
      UiHelper.customAlertBox(
        context: context,
        text: viewModel.errorMessage ?? "Something went wrong",
      );
    }
  }

  @override
  void dispose() {
    forgotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<ForgotPasswordViewModel>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
        backgroundColor: Color(0xFF6A11CB),
        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: forgotController,

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: const BorderSide(color: Colors.deepOrange),
                ),

                label: const Text(
                  "Email",
                  style: TextStyle(color: Colors.white),
                ),
                hintText: "Enter your email",
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
              onPressed: isLoading ? null : forgotPassword,

              child: isLoading
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(),
                    )
                  : const Text(
                      "Reset Password",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
