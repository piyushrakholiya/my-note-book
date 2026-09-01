import 'dart:io';

import 'package:firebase/utils/gradient_background.dart';

import 'package:firebase/utils/ui_helper.dart';
import 'package:firebase/viewmodels/login_view_model.dart';

import 'package:firebase/views/database_helper.dart';
import 'package:firebase/views/forgot_password.dart';
import 'package:firebase/views/phone_signup_page.dart';

import 'package:firebase/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String? selectedImagePath;

  @override
  void initState() {
    super.initState();

    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    String? path = await DatabaseHelper.myDatabase.getProfileImage();

    if (path != null && mounted) {
      setState(() {
        selectedImagePath = path;
      });
    }
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      UiHelper.customAlertBox(
        context: context,
        text: "enter valid information",
      );

      return;
    }

    final viewModel = context.read<LoginViewModel>();

    final bool success = await viewModel.login(
      email: email,
      password: password,
    );

    if (!mounted) {
      return;
    }

    if (success) {
    } else {
      if (viewModel.errorMessage == "user-not-found") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      } else if (viewModel.errorMessage == "wrong-password") {
        UiHelper.customAlertBox(context: context, text: "wrong password");
      } else {
        UiHelper.customAlertBox(
          context: context,
          text: viewModel.errorMessage ?? "Login failed",
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<LoginViewModel>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "login",
          style: TextStyle(fontSize: 34, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6A11CB),
        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Image
              selectedImagePath != null
                  ? CircleAvatar(
                      radius: 80,
                      backgroundImage: FileImage(File(selectedImagePath!)),
                    )
                  : const CircleAvatar(
                      radius: 80,
                      child: Icon(Icons.person_2, size: 80),
                    ),

              const SizedBox(height: 12),

              // Email
              TextField(
                controller: emailController,

                decoration: InputDecoration(
                  label: const Text(
                    "email",
                    style: TextStyle(color: Colors.white),
                  ),
                  hint: const Text(
                    "enter your email",
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

              // Password
              TextField(
                controller: passwordController,

                obscureText: true,

                decoration: InputDecoration(
                  label: const Text(
                    "password",
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

              // Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                  ),
                ),
                onPressed: isLoading ? null : login,

                child: isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      )
                    : const Text("Login"),
              ),

              const SizedBox(height: 12),

              // Create Account
              const Text(
                "create this new account",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),

              const SizedBox(width: 12),

              UiHelper.customButton(
                text: "sign up",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Phone Signup
              UiHelper.customButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PhoneSignupPage()),
                  );
                },

                text: "Phone Signup",
              ),

              const SizedBox(height: 22),

              // Forgot Password
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );
                },

                child: const Text(
                  "forgot password",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
